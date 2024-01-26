import 'package:cloud_firestore/cloud_firestore.dart';

class UserInGroupModel {
  String _id = '';
  String _groupId = '';
  String _groupName = '';
  String _subgroupId = '';
  String _subgroupName = '';
  String _userId = '';
  String _userName = '';
  bool _accept = false;
  bool _admin = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get groupName => _groupName;
  String get subgroupId => _subgroupId;
  String get subgroupName => _subgroupName;
  String get userId => _userId;
  String get userName => _userName;
  bool get accept => _accept;
  bool get admin => _admin;
  DateTime get createdAt => _createdAt;

  UserInGroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _groupName = map['groupName'] ?? '';
    _subgroupId = map['subgroupId'] ?? '';
    _subgroupName = map['subgroupName'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _accept = map['accept'] ?? false;
    _admin = map['admin'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
