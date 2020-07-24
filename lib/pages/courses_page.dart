import 'package:flutter/material.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';

class CoursesPage extends StatefulWidget {
  @override
  //initialises the courses page state
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create(context, "Courses Page"),
      body: Text("Courses Page"),
      bottomNavigationBar: CustomNavigationBar.create(context, 2),
    );
  }
}
