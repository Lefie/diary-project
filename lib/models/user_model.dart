
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {

  final String username;
  final String email;
  final String password;
  final String? user_id;
  final DateTime created_at;

  const UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.created_at,
    this.user_id
  });

  //
  Map<String, dynamic> toJson() {
    return {
      "username" : username,
      "email" : email,
      "password" : password,
      "created_at": created_at,
      if (user_id != null) "user_id": user_id
    };
  }

  // convert from json to user model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username : json["username"],
      email: json["email"],
      password: json["password"],
      created_at: (json["created_at"] as Timestamp).toDate() ,
      user_id: json["user_id"]
    );
  }

}