import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../objects/assignment.dart';
import '../objects/assignments_list_view.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';

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
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page
                return CustomScaffold.create(context, name, user, course, id);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, course),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 1));
              }
            })
        : CustomScaffold.create(context, name, user, course, id);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, CustomUser user,
      String course, String id) {
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar.create(context, course),
        //builds the body
        body: FutureBuilder(
            future: getAssignments(id, user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Assignment> assignments = snapshot.data;
                //checks if the user has assignments. If they do, return the assignments as a list view, otherwise return an error message
                try {
                  //creates a list view of the assignments
                  return AssignmentsListView.create(
                      context, user, course, id, assignments);
                } catch (error) {
                  return Center(
                    child: Text("You have no assignments to display."),
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
