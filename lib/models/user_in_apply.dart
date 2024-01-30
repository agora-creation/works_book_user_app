import 'package:cloud_firestore/cloud_firestore.dart';

class UserInApplyModel {
  String _id = '';
  String _groupId = '';
  String _groupName = '';
  String _sectionId = '';
  String _sectionName = '';
  String _userId = '';
  String _userName = '';
  bool _accept = false;
  bool _admin = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get groupName => _groupName;
  String get sectionId => _sectionId;
  String get sectionName => _sectionName;
  String get userId => _userId;
  String get userName => _userName;
  bool get accept => _accept;
  bool get admin => _admin;
  DateTime get createdAt => _createdAt;

  UserInApplyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _groupName = map['groupName'] ?? '';
    _sectionId = map['sectionId'] ?? '';
    _sectionName = map['sectionName'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _accept = map['accept'] ?? false;
    _admin = map['admin'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
