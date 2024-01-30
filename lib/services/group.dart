import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/group.dart';

class GroupService {
  String collection = 'group';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GroupModel?> select({
    String? groupCode,
  }) async {
    GroupModel? ret;
    await firestore
        .collection(collection)
        .where('code', isEqualTo: groupCode ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = GroupModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream({
    String? groupId,
  }) {
    String id = 'error';
    if (groupId != null) {
      if (groupId != '') {
        id = groupId;
      }
    }
    return firestore.collection(collection).doc(id).snapshots();
  }
}
