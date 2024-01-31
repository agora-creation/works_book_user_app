import 'package:cloud_firestore/cloud_firestore.dart';

class UserInApplyService {
  String collection = 'userInApply';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  void create(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).set(values);
  }

  void update(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).update(values);
  }

  void delete(Map<String, dynamic> values) {
    firestore.collection(collection).doc(values['id']).delete();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList({
    required String? userId,
  }) {
    return FirebaseFirestore.instance
        .collection(collection)
        .where('id', isEqualTo: userId ?? 'error')
        .snapshots();
  }
}
