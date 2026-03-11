import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import '../providers/mood_provider.dart';
import '../config/theme.dart';

class ActivitySuggestionsScreen extends ConsumerWidget {
  final int moodScore;

  const ActivitySuggestionsScreen({
    super.key,
    required this.moodScore,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activities = ActivityDatabase.forMood(moodScore);
    final favorites = ref.watch(favoriteActivitiesProvider);

    final moodEmojis = ['😞', '😕', '😐', '🙂', '😄'];
    final moodLabels = ['Muy mal', 'Mal', 'Regular', 'Bien', 'Excelente'];
    final moodColor = AppTheme.moodColors[moodScore - 1];

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: const Text('Sugerencias'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.popUntil(context, (r) => r.isFirst),
        ),
        actions: [
          if (favorites.isNotEmpty)
            TextButton.icon(
              onPressed: () => _showFavorites(context, ref, favorites),
              icon: const Icon(Icons.favorite, size: 16,
                  color: AppTheme.primaryGreen),
              label: Text(
                '${favorites.length}',
                style: const TextStyle(color: AppTheme.primaryGreen),
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: moodColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: moodColor.withValues(alpha: 0.3), width: 1),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          moodEmojis[moodScore - 1],
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Te sientes ${moodLabels[moodScore - 1].toLowerCase()}',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: moodColor,
                              ),
                            ),
                            const Text(
                              'Registro guardado ✓',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppTheme.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Para ti ahora',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Actividades recomendadas según cómo te sientes hoy.',
                    style: TextStyle(
                      color: AppTheme.mediumGray,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final activity = activities[index];
                  final isFav = favorites.contains(activity.id);
                  return _ActivityCard(
                    activity: activity,
                    isFavorite: isFav,
                    onFavoriteToggle: () => ref
                        .read(favoriteActivitiesProvider.notifier)
                        .toggle(activity.id),
                  );
                },
                childCount: activities.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  void _showFavorites(
      BuildContext context, WidgetRef ref, List<String> favoriteIds) {
    final favActivities =
        ActivityDatabase.all.where((a) => favoriteIds.contains(a.id)).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.warmCream,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Consumer(
        builder: (context, ref, _) {
          final favs = ref.watch(favoriteActivitiesProvider);
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.favorite,
                        color: AppTheme.primaryGreen, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'Favoritos',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...favActivities.map((a) => _ActivityCard(
                      activity: a,
                      isFavorite: favs.contains(a.id),
                      onFavoriteToggle: () => ref
                          .read(favoriteActivitiesProvider.notifier)
                          .toggle(a.id),
                    )),
                const SizedBox(height: 8),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  final Activity activity;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _ActivityCard({
    required this.activity,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: AppTheme.warmCream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  activity.emoji,
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          activity.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onFavoriteToggle,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            key: ValueKey(isFavorite),
                            size: 20,
                            color: isFavorite
                                ? Colors.red.shade400
                                : AppTheme.softSage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: const TextStyle(
                      color: AppTheme.mediumGray,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _Chip(
                        label: activity.category,
                        color: AppTheme.primaryGreen,
                      ),
                      const SizedBox(width: 8),
                      _Chip(
                        label: '${activity.durationMinutes} min',
                        color: AppTheme.mediumGray,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;

  const _Chip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
