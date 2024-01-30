import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSubgroupPlanService {
  String collection = 'group';
  String subCollection = 'subgroup';
  String subSubCollection = 'notice';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({
    String? groupId,
    String? subgroupId,
  }) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .doc(subgroupId ?? 'error')
        .collection(subSubCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['subgroupId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['subgroupId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['subgroupId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    String? groupId,
    String? subgroupId,
  }) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .doc(subgroupId ?? 'error')
        .collection(subSubCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
