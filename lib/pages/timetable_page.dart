import 'package:flutter/material.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/user.dart';

import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';

import '../pages/web_view_page.dart';

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
    //TODO: Check if events list is empty. If it is, load the webscraping page to fetch events from firefly & then build page. Else, build page.
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
        body: FutureBuilder(
            future: fireflyEventCount(user.firestoreId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == 1) {
                  //https://stackoverflow.com/questions/54691767/navigation-inside-nested-future
                  return WebViewPage(
                    user: user,
                    url: "/dashboard",
                  );
                } else {
                  return Center(
                    child: Text("You have ${snapshot.data} events."),
                  );
                }
              } else {
                //whilst getting courses, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 1));
  }
}
