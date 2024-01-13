import 'package:cloud_firestore/cloud_firestore.dart';

class GroupInApplyModel {
  String _groupId = '';
  String _groupName = '';
  String _userId = '';
  String _userName = '';
  bool _accept = false;
  DateTime _createdAt = DateTime.now();

  String get groupId => _groupId;
  String get groupName => _groupName;
  String get userId => _userId;
  String get userName => _userName;
  bool get accept => _accept;
  DateTime get createdAt => _createdAt;

  GroupInApplyModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _groupId = map['groupId'] ?? '';
    _groupName = map['groupName'] ?? '';
    _userId = map['userId'] ?? '';
    _userName = map['userName'] ?? '';
    _accept = map['accept'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
