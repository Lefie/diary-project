
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';


class FirebaseService {


  Future<UserCredential> signupNewUser(String email, String password) async{

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw e;
    }

  }

  Future<UserCredential> signInUser(String email, String password) async{

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return credential;

    }on FirebaseAuthException catch(e) {
      throw e;
    }


  }

}