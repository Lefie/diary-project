

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

class UserService {

  final db = FirebaseFirestore.instance;

  // method 1: save a new user to db user collections

  Future<void> addUser(UserModel user, String uid) async{

    try {
      await db.collection("users").doc(uid).set(user.toJson());
    }catch(e) {
      throw Exception(e);
    }

  }


  
  Future<UserModel> getUserById(String user_id) async{
    try {
      final docRef = await db.collection("users").doc(user_id);
      DocumentSnapshot<Map<String, dynamic>> doc =  await docRef.get();
      final data = doc.data() as Map<String, dynamic>;

      UserModel res = UserModel.fromJson(data);
      print(res);
      return res;

    }catch(e){
      throw Exception(e);
    }
  }

  Future<bool> userExistsByUsername(String username) async {
    try {
      final userRef = await db.collection("users");
      final query = userRef.where("username", isEqualTo: username);
      QuerySnapshot<Map<String, dynamic>> res = await query.get();
      for (var doc in res.docs) {
        if (doc.data()["username"] == username) {
          return true;
        }
      }

      return false;

    }catch(e) {
      throw Exception(e);
    }

  }



}