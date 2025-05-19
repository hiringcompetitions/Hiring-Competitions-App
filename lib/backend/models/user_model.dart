class UserModel {
  final String name;
  final String nickName;
  final String rollNo;
  final String passedOutYear;
  final String branch;
  final String email;
  final String gender;
  final String uid;
  final String fcmtoken;

  UserModel({
    required this.name,
    required this.nickName,
    required this.rollNo,
    required this.passedOutYear,
    required this.branch,
    required this.email,
    required this.gender,
    required this.uid,
    required this.fcmtoken,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      nickName : map['nickName'] ?? '',
      rollNo: map['rollNo'] ?? '',
      passedOutYear: map['passedOutYear'] ?? '',
      branch: map['branch'] ?? '',
      email: map['email'] ?? '', 
      gender: map['gender'] ?? '',
      uid : map["uid"] ?? '',
      fcmtoken: map['fcmtoken'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "nickName" : nickName,
      "rollNo" : rollNo,
      "passedOutYear" : passedOutYear,
      "branch" : branch,
      "email" : email,
      "gender" : gender,
      "uid" : uid,
      "fcmtoken" : fcmtoken
    };
  }

  UserModel copywith([
    String ? name,
    String ? nickName,
    String ? rollNo,
    String ? passedOutYear,
    String ? branch,
    String ? email,
    String ? gender,
    String ? uid,
    String ? fcmtoken,
  ]) {
    return UserModel(
      name: name ?? this.name, 
      nickName: nickName ?? this.nickName,
      rollNo: rollNo ?? this.rollNo,
      passedOutYear: passedOutYear ?? this.passedOutYear,
      branch: branch ?? this.branch,
      email: email ?? this.email,
      gender: gender ?? this.gender,
      uid : uid ?? this.uid,
      fcmtoken: fcmtoken ?? this.fcmtoken,
    );
  }
}