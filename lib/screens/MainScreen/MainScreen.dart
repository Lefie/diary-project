
import 'package:diary/screens/Entry/EntryScreenContent.dart';
import 'package:diary/screens/EntryList/EntryListScreenContent.dart';
import 'package:diary/screens/Home/HomeScreenContent.dart';
import 'package:diary/screens/Home/Home_Screen.dart';
import 'package:diary/screens/Journal/JournalScreenContent.dart';
import 'package:diary/screens/Login/LoginScreenContent.dart';
import 'package:diary/screens/PersonalHome/PersonalHomeContent.dart';
import 'package:diary/screens/Signup/SignupScreenContent.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.user});

  final User? user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  // authenticated screens
    List<Widget> get _screens => [
      PersonalHomeContent(),
      JournalScreenContent(),
      EntryListContent(),
  ];



  @override
  Widget build(BuildContext context) {
    final isLoggedin = widget.user != null? true : false;

   return Scaffold(
     appBar: AppBar(),
     drawer: isLoggedin ?
     Drawer(
       backgroundColor: Colors.purple[100],
         child:
      ListView(
       padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.secondaryPurple),
            child: Text(''),
           ),
          ListTile(
            title: Text('Log out', style:GoogleFonts.lexend()),
            onTap: () async{
              print("log out");
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ) ) : null ,
     body: isLoggedin ? _screens[_currentIndex] : HomeScreenContent(),
     bottomNavigationBar: isLoggedin ?  BottomNavigationBar(
       currentIndex: _currentIndex,
         onTap: (int index){
            print("at index ${index}");
            setState(() {
              _currentIndex = index;
            });
         },
         items:  [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Entries')
         ]
     ) : null,
   );
  }

}