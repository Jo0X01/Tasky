class UserModel {
  static const String collectionName = 'Users';
  String? userName;
  String? id;
  String? email;
  String? password;

  UserModel({this.id, this.userName, this.email, this.password});
  UserModel.fromJson(Map<String, dynamic> json) : this(
    userName: json['userName'],
    id: json['id'],
    email: json['email'],
    password: json['password'],
  );

  static Map<String, dynamic> toJson(UserModel userModel) {
    return {
      'userName': userModel.userName,
      'id': userModel.id,
      'email': userModel.email,
      'password': userModel.password,
    };
  }
}
