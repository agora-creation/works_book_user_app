import 'package:cloud_firestore/cloud_firestore.dart';

class GroupModel {
  String _id = '';
  String _code = '';
  String _password = '';
  String _name = '';
  String _zip = '';
  String _address = '';
  String _tel = '';
  String _image = '';
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get code => _code;
  String get password => _password;
  String get name => _name;
  String get zip => _zip;
  String get address => _address;
  String get tel => _tel;
  String get image => _image;
  DateTime get createdAt => _createdAt;

  GroupModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _code = map['code'] ?? '';
    _password = map['password'] ?? '';
    _name = map['name'] ?? '';
    _zip = map['zip'] ?? '';
    _address = map['address'] ?? '';
    _tel = map['tel'] ?? '';
    _image = map['image'] ?? '';
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
