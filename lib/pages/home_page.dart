import 'package:flutter/material.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  //initialises the home page state
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create(context, "Home Page"),
      body: Text("Home Page"),
      bottomNavigationBar: CustomNavigationBar.create(context, 0),
    );
  }
}
