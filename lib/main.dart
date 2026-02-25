import 'package:diary/screens/Entry/Entry_Screen.dart';
import 'package:diary/screens/EntryList/EntryList_Screen.dart';
import 'package:diary/screens/EntryScreen/EntryScreen.dart';
import 'package:diary/screens/Home/Home_Screen.dart';
import 'package:diary/screens/Journal/Journal_Screen.dart';
import 'package:diary/screens/MainScreen/MainScreen.dart';
import 'package:diary/theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: EntryScreen(),
        theme:primaryTheme,
    );
  }
}
