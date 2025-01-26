class UserModel {
  // constructor
  UserModel({
    required this.uid,
    required this.userName,
    required this.email,
    required this.createdAt,
    this.address,
    this.phone,
    this.profileImage,
  });

  final String uid;
  final String userName;
  final String email;
  final String? profileImage;
  final String? address;
  final String? phone;
  final DateTime createdAt;

  // from json
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      userName: json['userName'],
      email: json['email'],
      address: json['address'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          json['createdAt'].millisecondsSinceEpoch),
    );
  }

  // to json
  Map<String, dynamic> toJson() => {
        'uid': uid,
        'userName': userName,
        'email': email,
        'profileImage': profileImage,
        'createdAt': createdAt,
        'address': address,
        'phone': phone
      };
}
