import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  String _id = '';
  String _groupId = '';
  String _userId = '';
  String _userName = '';
  String _content = '';
  String _image = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get userId => _userId;
  String get userName => _userName;
  String get content => _content;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  MessageModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _content = map['content'] ?? '';
    _image = map['image'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}