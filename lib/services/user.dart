import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/user.dart';

class UserService {
  String collection = 'user';
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

  Future<UserModel?> select({
    String? userId,
  }) async {
    UserModel? ret;
    await firestore
        .collection(collection)
        .doc(userId ?? 'error')
        .get()
        .then((value) {
      ret = UserModel.fromSnapshot(value);
    });
    return ret;
  }

  Future<List<UserModel>> selectList({
    required List<String> userIds,
  }) async {
    List<UserModel> ret = [];
    await firestore
        .collection(collection)
        .where('id', whereIn: userIds.isNotEmpty ? userIds : ['error'])
        .get()
        .then((value) {
      for (DocumentSnapshot<Map<String, dynamic>> doc in value.docs) {
        ret.add(UserModel.fromSnapshot(doc));
      }
    });
    return ret;
  }
}
