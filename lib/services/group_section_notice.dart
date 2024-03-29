import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSectionNoticeService {
  String collection = 'group';
  String subCollection = 'section';
  String subSubCollection = 'notice';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String id({
    required String? groupId,
    required String? sectionId,
  }) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .doc(sectionId ?? 'error')
        .collection(subSubCollection)
        .doc()
        .id;
  }

  void create(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['sectionId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['sectionId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore
        .collection(collection)
        .doc(values['groupId'])
        .collection(subCollection)
        .doc(values['sectionId'])
        .collection(subSubCollection)
        .doc(values['id'])
        .delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamGroupSectionId({
    String? groupId,
    String? sectionId,
  }) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .doc(sectionId ?? 'error')
        .collection(subSubCollection)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
