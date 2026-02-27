
import 'package:diary/screens/Login/LoginScreenContent.dart';
import 'package:diary/screens/Signup/SignupScreenContent.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class HomeScreenContent extends StatelessWidget {

  const HomeScreenContent({super.key});



  @override
  Widget build(BuildContext context) {

    return  SingleChildScrollView(child:
      Container(
          width: double.infinity,
          child:
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height:40),
              Container(
                margin: EdgeInsets.only(top:100, bottom:10),
                child: Text(
                    "Welcome to the Diary",
                    style: Theme.of(context).textTheme.displayLarge),),
              Padding(
                padding: EdgeInsets.only(left:100, right:55),
                child:  Text("Journal your insights anytime, anywhere", style: GoogleFonts.lexend(),textAlign: TextAlign.end ,),
              ),
              SizedBox(height:80),
              StyledButton(
                  onPressed:(){
                    print("Login");
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(builder: (context) => const LoginScreenContent()),
                    );

                  },
                  child: Text("Login", style: Theme.of(context).textTheme.headlineLarge)),
              SizedBox(height:40),
              StyledButton(onPressed:(){
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (context) => const SignupScreenContent()),
                );

              },child: Text("Sign up", style: Theme.of(context).textTheme.headlineLarge)),

            ],
           ),),);
  }
}