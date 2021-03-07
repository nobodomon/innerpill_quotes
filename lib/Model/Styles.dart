import 'package:flutter/material.dart';

class Style {
  Style._();

  static final ThemeData lightTheme = new ThemeData(
    brightness: Brightness.light,
    backgroundColor: Colors.white70,
    primarySwatch: Colors.deepPurple,
    primaryColor: Colors.deepPurple[500],
    primaryColorBrightness: Brightness.light,
    accentColor: Colors.deepPurpleAccent[500],
    accentColorBrightness: Brightness.light,
    iconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
    indicatorColor: Colors.deepPurpleAccent[500],
    primaryIconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
    accentIconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurple, foregroundColor: Colors.black),
  );

  static final ThemeData darkTheme = new ThemeData(
      brightness: Brightness.dark,
      backgroundColor: Colors.black87,
      primarySwatch: Colors.deepPurple,
      primaryColor: Colors.deepPurple[500],
      primaryColorBrightness: Brightness.dark,
      accentColor: Colors.deepPurpleAccent[500],
      accentColorBrightness: Brightness.dark,
      primaryColorDark: Colors.deepPurple[500],
      iconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
      indicatorColor: Colors.deepPurpleAccent[500],
      primaryIconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
      accentIconTheme: IconThemeData(color: Colors.deepPurpleAccent[500]),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
      appBarTheme: AppBarTheme(
          brightness: Brightness.dark,
          backgroundColor: Colors.transparent,
          elevation: 0),
      buttonColor: Colors.white);

  static ThemeData dark() {
    return darkTheme;
  }

  static ThemeData light() {
    return lightTheme;
  }
}
