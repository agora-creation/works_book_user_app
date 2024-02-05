import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:works_book_user_app/models/group_section.dart';

class GroupSectionService {
  String collection = 'group';
  String subCollection = 'section';
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<GroupSectionModel?> select({
    String? groupId,
    String? sectionCode,
  }) async {
    GroupSectionModel? ret;
    await firestore
        .collection(collection)
        .doc(groupId ?? 'error')
        .collection(subCollection)
        .where('code', isEqualTo: sectionCode ?? 'error')
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        ret = GroupSectionModel.fromSnapshot(value.docs.first);
      }
    });
    return ret;
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamGroupSectionId({
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
