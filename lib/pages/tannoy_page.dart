import 'package:flutter/material.dart';
import 'package:learning_hub/pages/portal_web_view.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';
import '../objects/tannoy_list_view.dart';
import '../objects/notice.dart';
import '../objects/offlineScaffold.dart';

import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';

class TannoyPage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final CustomUser user;

  TannoyPage({this.user, this.name});

  @override
  //initialises the tannoy page state
  TannoyPageState createState() => TannoyPageState();
}

class TannoyPageState extends State<TannoyPage> {
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
                //once signed in, load the page, although if the user is offline, show the offline page
                if (user != null) {
                  return _CustomScaffold(user: user, name: name);
                } else {
                  return OfflineScaffold();
                }
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar(title: "Tannoy Notices", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 0));
              }
            })
        : _CustomScaffold(user: user, name: name);
  }
}

class _CustomScaffold extends StatefulWidget {
  final CustomUser user;
  final String name;

  _CustomScaffold({this.user, this.name});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

//details the looks of the page
class _CustomScaffoldState extends State<_CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String name = widget.name;
    return Scaffold(
        //returns the custom app bar with the timetable page title
        appBar: CustomAppBar(title: "Tannoy Notices", reload: false),
        //builds the body
        //checks if the user has at least one tannoy notice in the Firestore database added automatically from the pupil portal. If they do, load the tannoy page.
        //Otherwise, display a web view, which will allow the user to login to the portal and then will scrape the dashboard for the user's tannoy data.
        body: FutureBuilder(
            //gets the user's tannoy notices
            future: getTannoy(user.firebaseUser),
            //https://flutter.dev/docs/development/ui/interactive
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if ((snapshot.data == null) &&
                    DateTime.now().hour > 7 &&
                    DateTime.now().weekday < 5) {
                  //if they have no tannoy notices, return a web view body so the user can login to the portal
                  //https://stackoverflow.com/questions/54691767/navigation-inside-nested-future
                  return PortalWebView(
                    user: user,
                    //this url is the page on the site https://pupils.stpaulsschool.org.uk to access
                    url: "/api/homepage/",
                  );
                } else {
                  //otherwise build the page
                  List<Notice> notices = snapshot.data;
                  //checks if the user has any notices. If they do, return the notices as a list view, otherwise return an error message
                  try {
                    if (notices.length != 0) {
                      //creates a list view of the tannoy notices
                      return TannoysListView(notices: notices);
                    } else {
                      return Center(
                        child: Text("There are no tannoy notices to display."),
                      );
                    }
                  } catch (error) {
                    return Center(
                      child: Text("There are no tannoy notices to display."),
                    );
                  }
                }
              } else {
                //whilst getting notices, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 2));
  }
}
