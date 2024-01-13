import 'package:cloud_firestore/cloud_firestore.dart';

class GroupPlanService {
  String collection = 'group';
  String subCollection = 'plan';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? groupId) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
