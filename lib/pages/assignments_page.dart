import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';

import '../objects/assignments_list_view.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';
import '../objects/offlineScaffold.dart';

import '../backend/courseWorkBackend.dart';
import '../backend/authBackend.dart';

class AssignmentsPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final String id;
  final String course;
  final CustomUser user;

  AssignmentsPage({this.account, this.user, this.name, this.id, this.course});

  @override
  //initialises the courses page state
  AssignmentsPageState createState() => AssignmentsPageState();
}

class AssignmentsPageState extends State<AssignmentsPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    String id = widget.id;
    String course = widget.course;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page, although if the user is offline, show the offline page
                if (user != null) {
                  return _CustomScaffold(
                      name: name, user: user, course: course, id: id);
                } else {
                  return OfflineScaffold();
                }
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar:
                        CustomAppBar(title: "Account Details", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 1));
              }
            })
        : _CustomScaffold(name: name, user: user, course: course, id: id);
  }
}

class _CustomScaffold extends StatefulWidget {
  final String name;
  final CustomUser user;
  final String course;
  final String id;

  _CustomScaffold({this.name, this.user, this.course, this.id});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

//details the looks of the page
class _CustomScaffoldState extends State<_CustomScaffold> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    String course = widget.course;
    String id = widget.id;
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar(title: course, reload: false),
        //builds the body
        body: FutureBuilder(
            future: sendAssignmentsRequest(id, user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<dynamic> assignments = snapshot.data;
                //checks if the user has assignments. If they do, return the assignments as a list view, otherwise return an error message
                if (assignments != null) {
                  try {
                    //creates a list view of the assignments
                    return AssignmentsListView(
                        user: user,
                        assignments: assignments,
                        courseId: id,
                        courseName: course);
                  } catch (error) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                        child: Text(
                          "This course has no assignments to display.",
                          textAlign: TextAlign.center,
                          style: header3Style,
                        ),
                      ),
                    );
                  }
                } else {
                  //if there are no assignments, return a message saying so
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Text(
                        "This course has no assignments to display. If this is an error, please ensure you are online, and try again.",
                        textAlign: TextAlign.center,
                        style: header3Style,
                      ),
                    ),
                  );
                }
              } else {
                //whilst getting courses, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 1));
  }
}
