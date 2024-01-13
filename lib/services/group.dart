import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/group.dart';

class GroupService {
  String collection = 'group';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GroupModel?> select(String? number) async {
    GroupModel? ret;
    await firestore
        .collection(collection)
        .where('number', isEqualTo: number ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = GroupModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamList(String? id) {
    return firestore
        .collection(collection)
        .where('id', isEqualTo: id ?? 'error')
        .snapshots();
  }
}
