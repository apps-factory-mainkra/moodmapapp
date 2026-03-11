import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/mood_entry.dart';
import '../services/firestore_repository.dart';
import 'auth_provider.dart';

// Mood entries list provider
final moodEntriesProvider = FutureProvider<List<MoodEntry>>((ref) async {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) async {
      if (user == null) return [];
      final repo = ref.read(firestoreRepositoryProvider);
      return await repo.getMoodEntries(user.uid);
    },
    loading: () => [],
    error: (_, __) => [],
  );
});

// Today's mood entry
final todaysMoodProvider = Provider<AsyncValue<MoodEntry?>>((ref) {
  final entries = ref.watch(moodEntriesProvider);
  return entries.when(
    data: (list) {
      final today = DateTime.now();
      final todaysEntry = list.where((e) {
        return e.createdAt.year == today.year &&
            e.createdAt.month == today.month &&
            e.createdAt.day == today.day;
      }).firstOrNull;
      return AsyncValue.data(todaysEntry);
    },
    loading: () => const AsyncValue.loading(),
    error: (e, s) => AsyncValue.error(e, s),
  );
});

// Favorite activities provider
final favoriteActivitiesProvider =
    StateNotifierProvider<FavoriteActivitiesNotifier, List<String>>((ref) {
  return FavoriteActivitiesNotifier();
});

class FavoriteActivitiesNotifier extends StateNotifier<List<String>> {
  FavoriteActivitiesNotifier() : super([]);

  void toggle(String activityId) {
    if (state.contains(activityId)) {
      state = state.where((id) => id != activityId).toList();
    } else {
      state = [...state, activityId];
    }
  }

  bool isFavorite(String activityId) => state.contains(activityId);
}

// Mood entry notifier
class MoodEntryNotifier extends StateNotifier<AsyncValue<void>> {
  final FirestoreRepository _repository;
  final User _user;
  final Ref _ref;

  MoodEntryNotifier(this._repository, this._user, this._ref)
      : super(const AsyncValue.data(null));

  Future<void> saveMoodEntry(int moodScore, String? note) async {
    state = const AsyncValue.loading();
    try {
      final entry = MoodEntry(
        userId: _user.uid,
        moodScore: moodScore,
        note: note,
        createdAt: DateTime.now(),
      );
      await _repository.saveMoodEntry(entry);
      _ref.invalidate(moodEntriesProvider);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e.toString(), StackTrace.current);
    }
  }
}

final moodEntryNotifierProvider =
    StateNotifierProvider<MoodEntryNotifier, AsyncValue<void>>((ref) {
  final user = FirebaseAuth.instance.currentUser!;
  final repo = ref.read(firestoreRepositoryProvider);
  return MoodEntryNotifier(repo, user, ref);
});
