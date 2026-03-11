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
        .limit(limit)
        .get();

    // Sort in memory to avoid composite index requirement
    final entries = snapshot.docs.map((doc) => doc.data()).toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  Future<void> updateMoodEntry(String entryId, Map<String, dynamic> updates) async {
    await _db.collection('mood_entries').doc(entryId).update(updates);
  }

  Future<void> deleteMoodEntry(String entryId) async {
    await moodEntriesCollection.doc(entryId).delete();
  }

  // ── Favorite Activities (stored per user) ─────────────

  Future<List<String>> getFavoriteActivities(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    final data = doc.data();
    return List<String>.from(data?['favoriteActivities'] ?? []);
  }

  Future<void> updateFavoriteActivities(
      String userId, List<String> activityIds) async {
    await _db.collection('users').doc(userId).update({
      'favoriteActivities': activityIds,
    });
  }
}