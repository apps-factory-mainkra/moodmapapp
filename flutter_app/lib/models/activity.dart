class Activity {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final String category;
  final List<int> recommendedMoods;
  final int durationMinutes;

  const Activity({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.category,
    required this.recommendedMoods,
    required this.durationMinutes,
  });
}

class ActivityDatabase {
  static const List<Activity> all = [
    Activity(
      id: 'walk_outside',
      title: 'Caminar al aire libre',
      description: 'Un paseo de 10 minutos puede mejorar tu estado de ánimo significativamente.',
      emoji: '🚶',
      category: 'Movimiento',
      recommendedMoods: [1, 2, 3],
      durationMinutes: 10,
    ),
    Activity(
      id: 'deep_breathing',
      title: 'Respiración profunda',
      description: '5 respiraciones lentas y profundas para calmar el sistema nervioso.',
      emoji: '🫁',
      category: 'Relajación',
      recommendedMoods: [1, 2],
      durationMinutes: 5,
    ),
    Activity(
      id: 'call_friend',
      title: 'Llamar a alguien',
      description: 'Conectar con una persona querida puede aliviar la carga emocional.',
      emoji: '📞',
      category: 'Social',
      recommendedMoods: [1, 2, 3],
      durationMinutes: 15,
    ),
    Activity(
      id: 'warm_drink',
      title: 'Tomar algo caliente',
      description: 'Un té o café caliente tiene efecto calmante y reconfortante.',
      emoji: '☕',
      category: 'Autocuidado',
      recommendedMoods: [1, 2],
      durationMinutes: 10,
    ),
    Activity(
      id: 'journaling',
      title: 'Escribir en un diario',
      description: 'Anotar tus pensamientos te ayuda a clarificar cómo te sientes.',
      emoji: '📝',
      category: 'Reflexión',
      recommendedMoods: [2, 3, 4],
      durationMinutes: 10,
    ),
    Activity(
      id: 'music',
      title: 'Escuchar música',
      description: 'Pon tu playlist favorita y déjate llevar por el sonido.',
      emoji: '🎵',
      category: 'Entretenimiento',
      recommendedMoods: [2, 3, 4, 5],
      durationMinutes: 15,
    ),
    Activity(
      id: 'stretch',
      title: 'Estiramiento',
      description: '10 minutos de estiramientos para liberar tensión corporal.',
      emoji: '🧘',
      category: 'Movimiento',
      recommendedMoods: [2, 3, 4],
      durationMinutes: 10,
    ),
    Activity(
      id: 'read',
      title: 'Leer un libro',
      description: 'Sumérgete en una historia o aprende algo nuevo.',
      emoji: '📚',
      category: 'Entretenimiento',
      recommendedMoods: [3, 4],
      durationMinutes: 20,
    ),
    Activity(
      id: 'exercise',
      title: 'Hacer ejercicio',
      description: 'Canaliza tu energía positiva con una sesión de entrenamiento.',
      emoji: '💪',
      category: 'Movimiento',
      recommendedMoods: [3, 4, 5],
      durationMinutes: 30,
    ),
    Activity(
      id: 'creative',
      title: 'Proyecto creativo',
      description: 'Dibuja, pinta, cocina algo nuevo o crea con tus manos.',
      emoji: '🎨',
      category: 'Creatividad',
      recommendedMoods: [4, 5],
      durationMinutes: 30,
    ),
    Activity(
      id: 'social_plan',
      title: 'Planificar algo social',
      description: 'Organiza una salida o actividad con amigos o familia.',
      emoji: '👥',
      category: 'Social',
      recommendedMoods: [4, 5],
      durationMinutes: 15,
    ),
    Activity(
      id: 'learn',
      title: 'Aprender algo nuevo',
      description: 'Mira un tutorial, haz un curso corto o practica un nuevo skill.',
      emoji: '🧠',
      category: 'Aprendizaje',
      recommendedMoods: [3, 4, 5],
      durationMinutes: 20,
    ),
  ];

  static List<Activity> forMood(int moodScore) {
    return all.where((a) => a.recommendedMoods.contains(moodScore)).toList();
  }
}
