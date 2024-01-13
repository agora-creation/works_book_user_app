import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInApplyService {
  String collection = 'groupInApply';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['userId']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['userId']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['userId']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? userId) {
    return firestore
        .collection(collection)
        .where('userId', isEqualTo: userId ?? 'error')
        .snapshots();
  }
}
