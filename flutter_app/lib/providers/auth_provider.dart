import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/firestore_repository.dart';
import '../models/app_user.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

// Firestore repository provider
final firestoreRepositoryProvider =
    Provider<FirestoreRepository>((ref) => FirestoreRepository());

// Auth state stream - watches if user is logged in
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Current user data from Firestore
final currentUserProvider = FutureProvider<AppUser?>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return null;
      final repo = ref.read(firestoreRepositoryProvider);
      return await repo.getUser(user.uid);
    },
    loading: () => null,
    error: (_, __) => null,
  );
});

// Auth notifier for login/register actions
class AuthNotifier extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;
  final FirestoreRepository _repository;

  AuthNotifier(this._authService, this._repository)
      : super(const AsyncValue.data(null));

  Future<void> register(String email, String password, String name) async {
    state = const AsyncValue.loading();
    try {
      final credential = await _authService.registerWithEmail(email, password);
      final user = credential.user!;

      final appUser = AppUser(
        id: user.uid,
        email: email,
        name: name.isNotEmpty ? name : null,
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );
      await _repository.createUser(appUser);

      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapAuthError(e.code), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await _authService.loginWithEmail(email, password);
      final user = _authService.currentUser;
      if (user != null) {
        await _repository.updateUser(user.uid, {
          'lastActiveAt': DateTime.now(),
        });
      }
      state = const AsyncValue.data(null);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(_mapAuthError(e.code), StackTrace.current);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = const AsyncValue.data(null);
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No existe una cuenta con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta con este email.';
      case 'weak-password':
        return 'La contraseña debe tener al menos 6 caracteres.';
      case 'invalid-email':
        return 'El email no es válido.';
      case 'too-many-requests':
        return 'Demasiados intentos. Espera un momento.';
      default:
        return 'Error de autenticación. Inténtalo de nuevo.';
    }
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<void>>((ref) {
  return AuthNotifier(
    ref.read(authServiceProvider),
    ref.read(firestoreRepositoryProvider),
  );
});
