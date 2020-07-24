import 'package:flutter/material.dart';
import 'custom_navigation_bar.dart';
import 'custom_app_bar.dart';

class TimetablePage extends StatefulWidget {
  @override
  //initialises the timetable page state
  TimetablePageState createState() => TimetablePageState();
}

class TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create(context, "Timetable Page"),
      body: Text("Timetable Page"),
      bottomNavigationBar: CustomNavigationBar.create(context, 1),
    );
  }
}
