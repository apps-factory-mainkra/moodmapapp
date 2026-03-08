import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {{
  final String id;
  final String email;
  final String? name;
  final DateTime createdAt;
  final DateTime? lastActiveAt;

  AppUser({{
    required this.id,
    required this.email,
    this.name,
    required this.createdAt,
    this.lastActiveAt,
  }});

  factory AppUser.fromJson(Map<String, dynamic> json, String id) {{
    return AppUser(
      id: id,
      email: json['email'] ?? '',
      name: json['name'],
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActiveAt: (json['lastActiveAt'] as Timestamp?)?.toDate(),
    );
  }}

  Map<String, dynamic> toJson() {{
    return {{
      'email': email,
      'name': name,
      'createdAt': createdAt,
      'lastActiveAt': lastActiveAt,
    }};
  }}
}}
