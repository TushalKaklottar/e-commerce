class UserModel {
  late String name;
  late String email;
  late String profilePic;
  late String createdAt;
  late String? phoneNumber;
  late String uid;


  UserModel({
    required this.name,
    required this.email,
    required this.profilePic,
    required this.createdAt,
    required this.uid,
  });

  //FROM MAP
  factory UserModel.fromMap (Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email:  map['email'] ?? '',
      profilePic:  map['profilePic'] ?? '',
      createdAt:  map['createdAt'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  //TO MAP
  Map<String, dynamic> toMap() {
    return{
      "name": name,
      "email": email,
      "profilePic":profilePic,
      "createdAt": createdAt,
      "uid": uid,
    };
  }
}
