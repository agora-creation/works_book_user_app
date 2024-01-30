import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/group_subgroup.dart';

class GroupSubgroupService {
  String collection = 'group';
  String subCollection = 'subgroup';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GroupSubgroupModel?> select({
    String? groupCode,
    String? subgroupCode,
  }) async {
    GroupSubgroupModel? ret;
    await firestore
        .collection(collection)
        .where('groupCode', isEqualTo: groupCode ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        for (final snapshot in value.docs) {
          GroupSubgroupModel subgroup =
              GroupSubgroupModel.fromSnapshot(snapshot);
          if (subgroup.code == subgroupCode) {
            ret = subgroup;
          }
        }
      }
    });
    return ret;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> stream({
    String? groupId,
    String? subgroupId,
  }) {
    return firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .doc(subgroupId ?? '')
        .snapshots();
  }
}
