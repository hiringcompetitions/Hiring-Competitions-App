class UserModel {
  final String name;
  final String email;
  final String gender;
  final String fcmtoken;

  UserModel({
    required this.name,
    required this.email,
    required this.gender,
    this.fcmtoken = '',
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '', 
      email: map['email'] ?? '', 
      gender: map['gender'] ?? '',
      fcmtoken: map['fcmtoken'] ?? ''
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name" : name,
      "email" : email,
      "gender" : gender,
      "fcmtoken" : fcmtoken
    };
  }

  UserModel copywith([
    String ? name,
    String ? email,
    String ? gender,
    String ? fcmtoken,
  ]) {
    return UserModel(
      name: name ?? this.name, 
      email: email ?? this.email,
      gender: gender ?? this.gender,
      fcmtoken: fcmtoken ?? this.fcmtoken,
    );
  }
}