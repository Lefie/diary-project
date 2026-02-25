import 'package:diary/screens/Entry/Entry_Screen.dart';
import 'package:diary/screens/MainScreen/MainScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EntryScreen extends StatelessWidget {
  const EntryScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot){
          if (snapshot.hasError){
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: Text("An error occured ${snapshot.error}"),) ,);
          }

          if(snapshot.connectionState == ConnectionState.waiting ) {
            return Scaffold(
              appBar: AppBar(),
              body: Center(child: CircularProgressIndicator(),) ,);
          }

          if (snapshot.data == null){
            print("no one is logged in");
          }else{
            print("user ${snapshot.data!.email} is currently logged in");
          }

          return MainScreen(user : snapshot.data);

        });
  }
}