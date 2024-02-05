import 'package:cloud_firestore/cloud_firestore.dart';

class UserMessageService {
  String collection = 'user';
  String subCollection = 'message';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({
    required String? userId,
  }) {
    return firestore
        .collection(collection)
        .doc(userId ?? 'error')
        .collection(subCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['userId'])
        .collection(subCollection)
        .doc(values['id'])
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamUserId({
    required String? groupId,
    required String? sectionId,
    required String? userId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(userId ?? 'error')
        .collection(subCollection)
        .where('groupId', isEqualTo: groupId ?? 'error')
        .where('sectionId', isEqualTo: sectionId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
