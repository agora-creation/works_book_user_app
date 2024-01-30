import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSectionNoticeModel {
  String _id = '';
  String _groupId = '';
  String _sectionId = '';
  String _title = '';
  String _content = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get sectionId => _sectionId;
  String get title => _title;
  String get content => _content;
  DateTime get createdAt => _createdAt;

  GroupSectionNoticeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _sectionId = map['sectionId'] ?? '';
    _title = map['title'] ?? '';
    _content = map['content'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
