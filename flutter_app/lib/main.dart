import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'config/router.dart';
import 'config/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MoodMapApp()));
}

class MoodMapApp extends ConsumerWidget {
  const MoodMapApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'MoodMap',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AppRouter(),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
