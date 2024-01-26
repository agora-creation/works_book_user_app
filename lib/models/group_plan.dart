import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:works_book_user_app/common/style.dart';

class GroupPlanModel {
  String _id = '';
  String _groupId = '';
  String _subgroupId = '';
  String _title = '';
  String _content = '';
  DateTime _startedAt = DateTime.now();
  DateTime _endedAt = DateTime.now();
  Color _color = kPlanColors.first;
  bool _allDay = false;
  DateTime _createdAt = DateTime.now();

  String get id => _id;
  String get groupId => _groupId;
  String get subgroupId => _subgroupId;
  String get title => _title;
  String get content => _content;
  DateTime get startedAt => _startedAt;
  DateTime get endedAt => _endedAt;
  Color get color => _color;
  bool get allDay => _allDay;
  DateTime get createdAt => _createdAt;

  GroupPlanModel.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    Map<String, dynamic> map = snapshot.data() ?? {};
    _id = map['id'] ?? '';
    _groupId = map['groupId'] ?? '';
    _subgroupId = map['subgroupId'] ?? '';
    _title = map['title'] ?? '';
    _content = map['content'] ?? '';
    if (map['startedAt'] != null) {
      _startedAt = map['startedAt'].toDate() ?? DateTime.now();
    }
    if (map['endedAt'] != null) {
      _endedAt = map['endedAt'].toDate() ?? DateTime.now();
    }
    if (map['color'] != null) {
      _color = Color(int.parse(map['color'], radix: 16));
    }
    _allDay = map['allDay'] ?? false;
    if (map['createdAt'] != null) {
      _createdAt = map['createdAt'].toDate() ?? DateTime.now();
    }
  }
}
