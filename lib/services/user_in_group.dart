import 'package:cloud_firestore/cloud_firestore.dart';

class UserInGroupService {
  String collection = 'userInGroup';
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream({
    String? userId,
  }) {
    String id = 'error';
    if (userId != null) {
      if (userId != '') {
        id = userId;
      }
    }
    return FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .snapshots();
  }
}
