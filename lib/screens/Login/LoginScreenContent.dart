
import 'package:diary/services/firebase_service.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class LoginScreenContent extends StatefulWidget {

  const LoginScreenContent({super.key});


  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();

}

class _LoginScreenContentState extends State<LoginScreenContent> {

  final _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _displayErrMsg = false;

  void showErrMsg(){
    setState(() {
      _displayErrMsg = true;
    });

    Future.delayed(Duration(seconds: 4), (){
      if(mounted) {
        setState(() {
          _displayErrMsg = false;
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(height: 50),
          Text("Login", style: Theme.of(context).textTheme.displayLarge),
          SizedBox(height: 50,),
          Form(
            key: _loginFormKey,
            child: Column(
              children: [
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                      icon: Icon(Icons.email, color: Colors.white,),
                      labelText: 'email',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      hintText: 'lemonade123@gmail.com',
                      hintStyle: TextStyle(color: Colors.white54)
                  ),
                  controller: _emailController,
                  validator: (value){
                    if (value!.isEmpty) {
                      return 'please enter a username';
                    }

                    final bool isEmailValid = EmailValidator.validate(value);

                    if (!isEmailValid) {
                      return "please enter an email in a proper format";
                    }

                    return null;
                  },

                ),
                SizedBox(height: 30,),
                TextFormField(
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                      icon: Icon(Icons.password, color: Colors.white,),
                      labelText: 'password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                      hintText: '12345',
                      hintStyle: TextStyle(color: Colors.white54)
                  ),
                  controller: _passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'please enter your password';
                    }
                    // check password
                    return null;
                  },

                ),

                SizedBox(height: 35,),
                if (_displayErrMsg == true) Visibility(
                    visible: _displayErrMsg ,
                    child: Text("invalid email or password", style: TextStyle(color:Colors.redAccent,),
                    )),
                SizedBox(height: 35,),
                StyledButtonLite(child:
                Text("Submit", style: Theme.of(context).textTheme.headlineLarge),
                  onPressed: () async{
                    if (_loginFormKey.currentState!.validate()){
                      print("Submit");
                      print(_passwordController.text);
                      print(_emailController.text);

                      try {
                        FirebaseService fb_service = FirebaseService();
                        await fb_service.signInUser(_emailController.text, _passwordController.text);
                        Navigator.pop(context);


                      }on FirebaseAuthException catch(e) {
                         if (e.code == "invalid-credential"){
                           showErrMsg();
                           return;
                         }
                         print("${e.code}, ${e.message}");
                      }
                    }


                  })
              ],
            ),
          )
        ],
      )
    ),);
  }
}