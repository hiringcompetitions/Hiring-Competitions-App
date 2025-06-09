import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicationModel {
  final String name;
  final String rollNo;
  final String branch;
  final String batch;
  final String status;
  final String email;
  final Timestamp appliedOn;

  ApplicationModel({
    required this.name,
    required this.rollNo,
    required this.branch,
    required this.batch,
    required this.status,
    required this.email,
    required this.appliedOn,
  });

  Map<String, dynamic> toMap() {
    return {
      'name' : name,
      'rollNo' : rollNo,
      'branch' : branch,
      'batch' : batch,
      'status' : status,
      'email' : email,
      'appliedOn' : appliedOn,
    };
  }

  Map<String, dynamic> updateValue(String key, String val) {
    final data = toMap();
    data[key] = val;
    return data;
  }

  dynamic getValue(String key) {
    final data = toMap();
    return data['key'];
  }
}