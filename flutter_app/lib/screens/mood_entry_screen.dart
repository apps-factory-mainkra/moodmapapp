import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';
import '../config/theme.dart';
import 'activity_suggestions_screen.dart';

class MoodEntryScreen extends ConsumerStatefulWidget {
  const MoodEntryScreen({super.key});

  @override
  ConsumerState<MoodEntryScreen> createState() => _MoodEntryScreenState();
}

class _MoodEntryScreenState extends ConsumerState<MoodEntryScreen>
    with TickerProviderStateMixin {
  int _selectedMood = 3;
  final _noteController = TextEditingController();
  late AnimationController _emojiController;
  late Animation<double> _emojiScale;

  final _moods = [
    (score: 1, emoji: '😞', label: 'Muy mal', color: const Color(0xFFE53E3E)),
    (score: 2, emoji: '😕', label: 'Mal', color: const Color(0xFFED8936)),
    (score: 3, emoji: '😐', label: 'Regular', color: const Color(0xFFECC94B)),
    (score: 4, emoji: '🙂', label: 'Bien', color: const Color(0xFF48BB78)),
    (score: 5, emoji: '😄', label: 'Excelente', color: const Color(0xFF2D5A3D)),
  ];

  @override
  void initState() {
    super.initState();
    _emojiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _emojiScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _emojiController, curve: Curves.elasticOut),
    );
    _emojiController.forward();
  }

  @override
  void dispose() {
    _noteController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  void _selectMood(int mood) {
    setState(() => _selectedMood = mood);
    _emojiController.reset();
    _emojiController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final saveState = ref.watch(moodEntryNotifierProvider);
    final isLoading = saveState is AsyncLoading;
    final currentMood = _moods[_selectedMood - 1];

    ref.listen(moodEntryNotifierProvider, (_, next) {
      if (next is AsyncData && !isLoading) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                ActivitySuggestionsScreen(moodScore: _selectedMood),
          ),
        );
      }
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppTheme.warmCream,
      appBar: AppBar(
        title: const Text('¿Cómo te sientes?'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              ScaleTransition(
                scale: _emojiScale,
                child: Text(
                  currentMood.emoji,
                  style: const TextStyle(fontSize: 80),
                ),
              ),
              const SizedBox(height: 12),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  currentMood.label,
                  key: ValueKey(_selectedMood),
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Georgia',
                    color: currentMood.color,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _moods.map((mood) {
                  final isSelected = _selectedMood == mood.score;
                  return GestureDetector(
                    onTap: () => _selectMood(mood.score),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isSelected ? 64 : 52,
                      height: isSelected ? 64 : 52,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? mood.color.withValues(alpha: 0.15)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? mood.color : AppTheme.lightGray,
                          width: isSelected ? 2.5 : 1.5,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: mood.color.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                )
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          mood.emoji,
                          style: TextStyle(
                            fontSize: isSelected ? 30 : 24,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Muy mal',
                    style: TextStyle(fontSize: 11, color: AppTheme.mediumGray),
                  ),
                  Text(
                    'Excelente',
                    style: TextStyle(fontSize: 11, color: AppTheme.mediumGray),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _noteController,
                maxLines: 3,
                maxLength: 200,
                decoration: const InputDecoration(
                  labelText: '¿Algo que quieras anotar? (opcional)',
                  alignLabelWithHint: true,
                  hintText: 'Ej: Tuve una reunión difícil, me siento cansado...',
                  counterStyle: TextStyle(
                    color: AppTheme.softSage,
                    fontSize: 11,
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: isLoading ? null : _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentMood.color,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Guardar y ver sugerencias'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _save() async {
    await ref.read(moodEntryNotifierProvider.notifier).saveMoodEntry(
          _selectedMood,
          _noteController.text.trim().isNotEmpty
              ? _noteController.text.trim()
              : null,
        );
  }
}
