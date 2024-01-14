import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoticeService {
  String collection = 'user';
  String subCollection = 'notice';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['id'])
        .update(values);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    String? userId,
    String? groupId,
  }) {
    return firestore
        .collection(collection)
        .doc(userId ?? 'error')
        .collection(subCollection)
        .where('groupId', isEqualTo: groupId ?? 'error')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
