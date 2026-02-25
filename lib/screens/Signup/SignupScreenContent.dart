

import 'package:diary/models/user_model.dart';
import 'package:diary/services/firebase_service.dart';
import 'package:diary/services/user_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class SignupScreenContent extends StatefulWidget {

  const SignupScreenContent({super.key});

  @override
  State<SignupScreenContent> createState() => _SignupScreenContentState();

}

class _SignupScreenContentState extends State<SignupScreenContent> {

  final _signupFormKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _email = TextEditingController();
  bool _displayErrMsgUserExists = false;
  bool _displayErrMsgEmailIUse = false;
  bool _displayOtherErr = false;


  void showErrMsg(int type){
    if (type == 1) {
      setState(() {
        _displayErrMsgUserExists = true;
      });

      Future.delayed(Duration(seconds: 4), (){
        setState(() {
          _displayErrMsgUserExists = false;
        });
      });
    }

    else if (type == 2) {
      setState(() {
        _displayErrMsgEmailIUse = true;
      });

      Future.delayed(Duration(seconds: 4), (){
        setState(() {
          _displayErrMsgEmailIUse = false;
        });
      });
    }
    else {
      setState(() {
        _displayOtherErr = true;
      });

      Future.delayed(Duration(seconds: 4), (){
        setState(() {
          _displayOtherErr = false;
        });
      });

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(height: 50),
            Text("Singup", style: Theme.of(context).textTheme.displayLarge),
            SizedBox(height: 50,),
              Form(
                key: _signupFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(Icons.person, color: Colors.white,),
                          labelText: 'username',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                          hintText: 'sophie_123',
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
                      controller: _username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter your username';
                        }
                        // make sure no duplicate username in db

                        // check password
                        return null;
                      },

                    ),
                    SizedBox(height:24),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          icon: Icon(Icons.email, color: Colors.white,),
                          labelText: 'email',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                          hintText: 'sophie@gmail.com',
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
                      controller: _email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'email should not be left empty ';
                        }

                        final bool isEmailValid = EmailValidator.validate(value);
                        print("is email valid ? $isEmailValid");
                        if (!isEmailValid) {
                          return "please enter an email in a proper format";
                        }

                        // check password
                        return null;
                      },

                    ),
                    SizedBox(height:24),
                    TextFormField(
                      style: TextStyle(color: Colors.white),
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(Icons.email, color: Colors.white,),
                          labelText: 'password',
                          labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                          hintText: '12345abc',
                          hintStyle: TextStyle(color: Colors.white54)
                      ),
                      controller: _password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'please enter a valid password  ';
                        }
                        if(value.length < 6) {
                          return "password should be more than 6 characters/numbers";
                        }
                        // make sure no duplicate username in db

                        // check password
                        return null;
                      },

                    ),
                    SizedBox(height:24),
                    if (_displayErrMsgUserExists) Text("username already exists", style: TextStyle(color: Colors.yellowAccent),),
                    if (_displayErrMsgEmailIUse) Text("email already in use", style: TextStyle(color: Colors.yellowAccent),),
                    if (_displayOtherErr) Text("An issue occurred with signup", style: TextStyle(color: Colors.yellowAccent),),
                    SizedBox(height:24),
                    StyledButtonLite(
                child: Text("Sign up", style: Theme.of(context).textTheme.headlineLarge,),
                onPressed: () async {
                  if(_signupFormKey.currentState!.validate()) {
                    print("create a user object with ");
                    final Map<String, dynamic> json = {
                      "username": _username.text,
                      "email": _email.text,
                      "password": _password.text,
                    };

                    UserService uservice = UserService();
                    bool userAlreadyExists = await uservice.userExistsByUsername(_username.text);
                    if (userAlreadyExists == true) {
                      showErrMsg(1);
                      return;
                    }

                    try {
                      FirebaseService fbService = new FirebaseService();
                      final userCred = await fbService.signupNewUser(
                          _email.text, _password.text);

                      if (userCred != null) {
                        print("user cred: $userCred");
                        print(userCred.user!.email);
                        print(userCred.user!.uid);
                        UserService userService = UserService();
                        await userService.addUser(
                            UserModel(
                                username: _username.text,
                                email: _email.text,
                                password: _password.text,
                                created_at: DateTime.now(),
                                user_id: userCred.user!.uid),
                            userCred.user!.uid);
                        Navigator.pop(context);
                      }
                    } on FirebaseAuthException catch (e){
                      // email-already-in-use
                      if(e.code == "email-already-in-use"){
                        showErrMsg(2);
                      }
                      else{
                        showErrMsg(3);
                      }
                    }
                  }
                }),]
              ),
              ),

          ],
        )
      )
    ),
    );
  }
}