import 'package:cloud_firestore/cloud_firestore.dart';

class GroupSubgroupModel {
  String _id = '';
  String _groupId = '';
  String _code = '';
  String _password = '';
  String _name = '';
  String _image = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get code => _code;
  String get password => _password;
  String get name => _name;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  GroupSubgroupModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _code = map['code'] ?? '';
    _password = map['password'] ?? '';
    _name = map['name'] ?? '';
    _image = map['image'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
