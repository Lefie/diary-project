import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors{
  static Color primaryPurple = Color(0xff210535);
  static Color secondaryPurple = Color(0xff7B337D);
  static Color lightPink = Color(0xffC874B2);
  static Color textWhite = Colors.white;
  static Color textOffwhite = Colors.white70;
  static Color textBlack = Colors.black;
  static Color textGrey = Colors.grey;
}

class AppEmojis {
  static String happy = "🥰";
  static String neutral = "😐";
  static String sad = "😔";
}


ThemeData primaryTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryPurple),
  scaffoldBackgroundColor: AppColors.primaryPurple,
  appBarTheme: AppBarTheme(backgroundColor: AppColors.secondaryPurple),
  textTheme: TextTheme(
    displayLarge:  GoogleFonts.tangerine(
      color: Colors.white
    ),
    headlineLarge: GoogleFonts.tangerine(
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.lexend(
      color: Colors.white,
      fontSize: 16
    ),

    ),
);



