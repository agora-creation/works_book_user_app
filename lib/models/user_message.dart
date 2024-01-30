import 'package:cloud_firestore/cloud_firestore.dart';

class UserMessageModel {
  String _id = '';
  String _userId = '';
  String _groupId = '';
  String _sectionId = '';
  String _content = '';
  String _image = '';
  String _createdUserId = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get userId => _userId;
  String get groupId => _groupId;
  String get sectionId => _sectionId;
  String get content => _content;
  String get image => _image;
  String get createdUserId => _createdUserId;
  DateTime get createdAt => _createdAt;

  UserMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _userId = map['userId'] ?? '';
    _groupId = map['groupId'] ?? '';
    _sectionId = map['sectionId'] ?? '';
    _content = map['content'] ?? '';
    _image = map['image'] ?? '';
    _createdUserId = map['createdUserId'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
