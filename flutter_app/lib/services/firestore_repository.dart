import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class FirestoreRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Users collection
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
    await usersCollection.doc(userId).update(updates);
  }

  // Main items collection (adaptar nombre según tu dominio)
  CollectionReference get itemsCollection {
    return _db.collection('items');
  }

  Future<void> createItem(String userId, Map<String, dynamic> data) async {
    await itemsCollection.doc().set({
      ...data,
      'userId': userId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<List<Map<String, dynamic>>> getUserItems(String userId) async {
    final snapshot = await itemsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(50)
        .get();
    
    return snapshot.docs.map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>}).toList();
  }

  Future<void> deleteItem(String itemId) async {
    await itemsCollection.doc(itemId).delete();
  }
}
