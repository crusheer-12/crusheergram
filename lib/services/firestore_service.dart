import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> createPost({
    required String userId,
    required String username,
    required String imageUrl,
    required String caption,
  }) async {
    await _db.collection('posts').add({
      'userId': userId,
      'username': username,
      'imageUrl': imageUrl,
      'caption': caption,
      'likesCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }
}
