import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';
import '../models/mood_entry.dart';

class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────

  CollectionReference<AppUser> get usersCollection {
    return _db.collection('users').withConverter<AppUser>(
      fromFirestore: (doc, _) => AppUser.fromJson(doc.data() ?? {}, doc.id),
      toFirestore: (user, _) => user.toJson(),
    );
  }

  Future<void> createUser(AppUser user) async {
    await usersCollection.doc(user.id).set(user);
  }

  Future<AppUser?> getUser(String userId) async {
    final doc = await usersCollection.doc(userId).get();
    return doc.data();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> updates) async {
    await _db.collection('users').doc(userId).update(updates);
  }

  // ── Mood Entries ───────────────────────────────────────

  CollectionReference<MoodEntry> get moodEntriesCollection {
    return _db.collection('mood_entries').withConverter<MoodEntry>(
      fromFirestore: (doc, _) => MoodEntry.fromJson(doc.data() ?? {}, doc.id),
      toFirestore: (entry, _) => entry.toJson(),
    );
  }

  Future<void> saveMoodEntry(MoodEntry entry) async {
    await moodEntriesCollection.add(entry);
  }

  Future<List<MoodEntry>> getMoodEntries(String userId, {int limit = 30}) async {
    final snapshot = await moodEntriesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  Future<void> deleteMoodEntry(String entryId) async {
    await moodEntriesCollection.doc(entryId).delete();
  }
}
