import 'package:cloud_firestore/cloud_firestore.dart';

class UserNoticeModel {
  String _id = '';
  String _groupId = '';
  String _subgroupId = '';
  String _userId = '';
  String _title = '';
  String _content = '';
  bool _isRead = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get subgroupId => _subgroupId;
  String get userId => _userId;
  String get title => _title;
  String get content => _content;
  bool get isRead => _isRead;
  DateTime get createdAt => _createdAt;

  UserNoticeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _subgroupId = map['subgroupId'] ?? '';
    _userId = map['userId'] ?? '';
    _title = map['title'] ?? '';
    _content = map['content'] ?? '';
    _isRead = map['isRead'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
