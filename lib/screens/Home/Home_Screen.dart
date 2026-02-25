import 'package:diary/screens/Journal/Journal_Screen.dart';
import 'package:diary/theme.dart';
import 'package:diary/ui_widgets/StyledButton.dart';
import 'package:flutter/material.dart';
import 'package:diary/screens/EntryList/EntryList_Screen.dart';


/*
class HomeScreen extends StatelessWidget {

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(child:
          Container(
         width: double.infinity,
          child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              spacing:20,
              children: [
                SizedBox(height:40),
                Container(
                  margin: EdgeInsets.only(top:100),
                  child: Text(
                  "Welcome to the Diary",
                   style: Theme.of(context).textTheme.displayLarge),),
                SizedBox(height:40),
                StyledButton(
                    onPressed:(){
                      print("journal button pressed");
                      Navigator.of(context).push(MaterialPageRoute<void>(
                        builder: (context) => JournalScreen(),
                      ),);
                      },
                    child: Text("Journal", style: Theme.of(context).textTheme.headlineLarge)),
                StyledButton(onPressed:(){
                  print("entry button pressed");

                  // Navigator.of(context).push(MaterialPageRoute<void>(
                  //   builder: (context) => EntryList(),
                  // ),);
               },child: Text("Entries", style: Theme.of(context).textTheme.headlineLarge)),

                ],
              )
            ),),
    );
  }

}

 */