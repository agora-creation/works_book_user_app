import 'package:cloud_firestore/cloud_firestore.dart';

class UserMessageModel {
  String _id = '';
  String _groupId = '';
  String _userId = '';
  String _content = '';
  String _image = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get userId => _userId;
  String get content => _content;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  UserMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _userId = map['userId'] ?? '';
    _content = map['content'] ?? '';
    _image = map['image'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
