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

  Future<UserModel?> select(String? id) async {
    UserModel? ret;
    await firestore.collection(collection).doc(id).get().then((value) {
      ret = UserModel.fromSnapshot(value);
    });
    return ret;
  }
}
