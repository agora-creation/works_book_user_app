import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoticeService {
  String collection = 'user';
  String subCollection = 'notice';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    required String? groupId,
    required String? sectionId,
    required String? userId,
  }) {
    return firestore
        .collection(collection)
        .doc(userId ?? 'error')
        .collection(subCollection)
        .where('groupId', isEqualTo: groupId ?? 'error')
        .where('sectionId', isEqualTo: sectionId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
