import 'package:flutter/material.dart';

//defines various text styles and other theme data, so that it can be used later on in the project and provide consistency
TextStyle pageTitleStyle =
    TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w500);
TextStyle navigationBarStyle = TextStyle(
  fontFamily: "Montserrat",
  fontWeight: FontWeight.w300,
  fontSize: 10,
);
TextStyle titleStyle = TextStyle(
    fontFamily: "Montserrat", fontWeight: FontWeight.w500, fontSize: 22);
TextStyle subtitleStyle = TextStyle(
    fontFamily: "Montserrat", fontWeight: FontWeight.w500, fontSize: 18);
TextStyle header3Style =
    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w300, fontSize: 16);
TextStyle header4Style =
    TextStyle(fontFamily: "Jost", fontWeight: FontWeight.w100, fontSize: 16);
TextStyle paragraph1Style = TextStyle();

ThemeData darkTheme = ThemeData(
    accentColor: Color.fromARGB(255, 37, 147, 130),
    brightness: Brightness.dark,
    buttonColor: Color.fromARGB(255, 216, 225, 230),
    highlightColor: Color.fromARGB(255, 37, 147, 130),
    backgroundColor: Color.fromARGB(255, 41, 41, 41),
    bottomAppBarTheme:
        BottomAppBarTheme(color: Color.fromARGB(255, 171, 146, 191)));
ThemeData lightTheme = ThemeData(
    accentColor: Colors.purple,
    brightness: Brightness.light,
    buttonColor: Colors.black,
    backgroundColor: Colors.white,
    bottomAppBarTheme:
        BottomAppBarTheme(color: Color.fromARGB(255, 209, 52, 91)));
