import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/mood_entry_screen.dart';
import '../screens/activity_suggestions_screen.dart';

class AppRouter extends ConsumerWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          return const HomeScreen();
        }
        return const AuthScreen();
      },
      loading: () => const _SplashScreen(),
      error: (_, __) => const AuthScreen(),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF2D5A3D),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.mood, color: Colors.white, size: 44),
            ),
            const SizedBox(height: 20),
            const Text(
              'MoodMap',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Color(0xFF2D5A3D),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppRoutes {
  static const home = '/';
  static const auth = '/auth';
  static const moodEntry = '/mood-entry';
  static const activitySuggestions = '/activity-suggestions';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthScreen());
      case moodEntry:
        return MaterialPageRoute(builder: (_) => const MoodEntryScreen());
      case activitySuggestions:
        final mood = settings.arguments as int? ?? 3;
        return MaterialPageRoute(
          builder: (_) => ActivitySuggestionsScreen(moodScore: mood),
        );
      default:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
    }
  }
}
