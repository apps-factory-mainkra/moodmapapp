import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/mood_provider.dart';
import '../models/mood_entry.dart';
import '../config/theme.dart';
import 'mood_entry_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moodEntries = ref.watch(moodEntriesProvider);
    final todaysMood = ref.watch(todaysMoodProvider);

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: const Text('MoodMap'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_outlined, size: 22),
            onPressed: () => ref.read(authNotifierProvider.notifier).signOut(),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(moodEntriesProvider),
        color: AppTheme.primaryGreen,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _TodayCard(todaysMood: todaysMood),
              const SizedBox(height: 24),
              moodEntries.when(
                data: (entries) => entries.isEmpty
                    ? const _EmptyState()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Últimos 7 días',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 16),
                          _MoodChart(entries: entries.take(7).toList()),
                          const SizedBox(height: 24),
                          Text(
                            'Historial',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          ...entries
                              .take(10)
                              .map((e) => _MoodEntryTile(entry: e)),
                        ],
                      ),
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToMoodEntry(context, ref),
        backgroundColor: AppTheme.primaryGreen,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(
          todaysMood.value != null ? 'Actualizar ánimo' : 'Registrar ánimo',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  void _navigateToMoodEntry(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const MoodEntryScreen()),
    ).then((_) => ref.invalidate(moodEntriesProvider));
  }
}

// ── Today Card ─────────────────────────────────────────────

class _TodayCard extends StatelessWidget {
  final AsyncValue<MoodEntry?> todaysMood;

  const _TodayCard({required this.todaysMood});

  @override
  Widget build(BuildContext context) {
    return todaysMood.when(
      data: (entry) {
        if (entry == null) {
          return Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getGreeting(),
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '¿Cómo te sientes\nhoy?',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Aún no has registrado',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final moodColor = AppTheme.moodColors[entry.moodScore - 1];
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: moodColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hoy te sientes',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      entry.moodLabel,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Georgia',
                      ),
                    ),
                    if (entry.note != null && entry.note!.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        '"${entry.note}"',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Text(
                entry.moodEmoji,
                style: const TextStyle(fontSize: 52),
              ),
            ],
          ),
        );
      },
      loading: () => Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppTheme.lightGray,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Buenos días ☀️';
    if (hour < 18) return 'Buenas tardes 🌤️';
    return 'Buenas noches 🌙';
  }
}

// ── Mood Chart ─────────────────────────────────────────────

class _MoodChart extends StatelessWidget {
  final List<MoodEntry> entries;

  const _MoodChart({required this.entries});

  @override
  Widget build(BuildContext context) {
    final days = List.generate(7, (i) {
      final date = DateTime.now().subtract(Duration(days: 6 - i));
      final entry = entries.where((e) {
        return e.createdAt.year == date.year &&
            e.createdAt.month == date.month &&
            e.createdAt.day == date.day;
      }).firstOrNull;
      return (date: date, entry: entry);
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((d) {
          final score = d.entry?.moodScore;
          final color = score != null
              ? AppTheme.moodColors[score - 1]
              : AppTheme.lightGray;
          final height = score != null ? (score / 5.0) * 60 : 8.0;

          return Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 32,
                height: height,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                _dayLabel(d.date),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppTheme.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (score != null)
                Text(
                  d.entry!.moodEmoji,
                  style: const TextStyle(fontSize: 12),
                )
              else
                const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  String _dayLabel(DateTime date) {
    const days = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];
    return days[date.weekday - 1];
  }
}

// ── Mood Entry Tile ────────────────────────────────────────

class _MoodEntryTile extends StatelessWidget {
  final MoodEntry entry;

  const _MoodEntryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.moodColors[entry.moodScore - 1];

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                entry.moodEmoji,
                style: const TextStyle(fontSize: 22),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.moodLabel,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                if (entry.note != null && entry.note!.isNotEmpty)
                  Text(
                    entry.note!,
                    style: const TextStyle(
                      color: AppTheme.mediumGray,
                      fontSize: 13,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            _formatDate(entry.createdAt),
            style: const TextStyle(
              color: AppTheme.mediumGray,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.day == now.day && date.month == now.month) return 'Hoy';
    final yesterday = now.subtract(const Duration(days: 1));
    if (date.day == yesterday.day && date.month == yesterday.month) {
      return 'Ayer';
    }
    return '${date.day}/${date.month}';
  }
}

// ── Empty State ────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Column(
        children: [
          const Text('🌱', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            'Aún no hay registros',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const Text(
            'Comienza a registrar tu estado\nde ánimo diariamente.',
            textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.mediumGray, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
