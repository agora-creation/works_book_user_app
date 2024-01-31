import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/user_in_apply.dart';

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

  Future<List<UserInApplyModel>> selectList({
    required String? groupId,
    required String? sectionId,
  }) async {
    List<UserInApplyModel> ret = [];
    await firestore
        .collection(collection)
        .where('groupId', isEqualTo: groupId ?? 'error')
        .where('sectionId', isEqualTo: sectionId ?? 'error')
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        ret.add(UserInApplyModel.fromSnapshot(doc));
      }
    });
    return ret;
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
