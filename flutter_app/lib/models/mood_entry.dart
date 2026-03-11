import 'package:cloud_firestore/cloud_firestore.dart';

class MoodEntry {
  final String? id;
  final String userId;
  final int moodScore; // 1-5
  final String? note;
  final List<String> activities;
  final DateTime createdAt;

  MoodEntry({
    this.id,
    required this.userId,
    required this.moodScore,
    this.note,
    this.activities = const [],
    required this.createdAt,
  });

  factory MoodEntry.fromJson(Map<String, dynamic> json, String id) {
    return MoodEntry(
      id: id,
      userId: json['userId'] ?? '',
      moodScore: json['moodScore'] ?? 3,
      note: json['note'],
      activities: List<String>.from(json['activities'] ?? []),
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'moodScore': moodScore,
      'note': note,
      'activities': activities,
      'createdAt': createdAt,
    };
  }

  String get moodLabel {
    switch (moodScore) {
      case 1: return 'Muy mal';
      case 2: return 'Mal';
      case 3: return 'Regular';
      case 4: return 'Bien';
      case 5: return 'Excelente';
      default: return 'Regular';
    }
  }

  String get moodEmoji {
    switch (moodScore) {
      case 1: return '😞';
      case 2: return '😕';
      case 3: return '😐';
      case 4: return '🙂';
      case 5: return '😄';
      default: return '😐';
    }
  }

  MoodEntry copyWith({
    String? id,
    String? userId,
    int? moodScore,
    String? note,
    List<String>? activities,
    DateTime? createdAt,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      moodScore: moodScore ?? this.moodScore,
      note: note ?? this.note,
      activities: activities ?? this.activities,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
