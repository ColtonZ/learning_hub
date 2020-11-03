import 'package:flutter/material.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/user.dart';

import '../backend/authBackend.dart';

class TimetablePage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final User user;

  TimetablePage({this.user, this.name});

  @override
  //initialises the timetable page state
  TimetablePageState createState() => TimetablePageState();
}

class TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    User user = widget.user;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once the user has been signed in, load the page
                return CustomScaffold.create(context, name, user);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, "Your Timetable"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 1));
              }
            })
        : CustomScaffold.create(context, name, user);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, User user) {
    return new Scaffold(
        //returns the custom app bar with the timetable page title
        appBar: CustomAppBar.create(context, "Your Timetable"),
        //builds the body
        body: Center(
            child: Text(
          user.name,
          style: titleStyle,
        )),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 1));
  }
}
