import 'package:flutter/material.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';
import '../objects/events_list_view.dart';

import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';

import '../pages/web_view_page.dart';

class TimetablePage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final CustomUser user;

  TimetablePage({this.user, this.name});

  @override
  //initialises the timetable page state
  TimetablePageState createState() => TimetablePageState();
}

class TimetablePageState extends State<TimetablePage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(false),
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
                        CustomNavigationBar.create(context, name, user, 0));
              }
            })
        : CustomScaffold.create(context, name, user);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, CustomUser user) {
    return new Scaffold(
        //returns the custom app bar with the timetable page title
        appBar: CustomAppBar.create(context, "Your Timetable"),
        //builds the body
        //checks if the user has at least one event in the Firestore database added automatically from Firefly. If they do, load the timetable page.
        //Otherwise, display a web view, which will allow the user to login to Firefly and then will scrape the dashboard for the user's timetable data.
        body: FutureBuilder(
            //counts how many Firefly events the user has
            future: getEventsList(user.firebaseUser),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  //if they have no events, return a web view body so the user can login to Firefly
                  //https://stackoverflow.com/questions/54691767/navigation-inside-nested-future
                  return WebViewPage(
                    user: user,
                    //this url is the page on the site https://intranet.stpaulsschool.org.uk to access
                    url: "/dashboard",
                  );
                } else {
                  //otherwise build the page
                  return EventsListView.create(context, user, snapshot.data);
                }
              } else {
                //whilst getting courses, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 0));
  }
}
