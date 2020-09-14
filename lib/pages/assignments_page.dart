import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/assignments_list_view.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';

class AssignmentsPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final String id;
  final String course;

  AssignmentsPage({this.account, this.name, this.id, this.course});

  @override
  //initialises the courses page state
  AssignmentsPageState createState() => AssignmentsPageState();
}

class AssignmentsPageState extends State<AssignmentsPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    GoogleSignInAccount account = widget.account;
    String id = widget.id;
    String course = widget.course;
    //checks if the user is signed in, if not, they are signed in
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(
                    context, name, account, course, id);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, course),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 2));
              }
            })
        : CustomScaffold.create(context, name, account, course, id);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name,
      GoogleSignInAccount account, String course, String id) {
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar.create(context, course),
        //builds the body
        body: FutureBuilder(
            future: getAssignments(id, account),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Assignment> assignments = snapshot.data;
                //checks if the user has assignments. If they do, return the assignments, otherwise return an error message
                try {
                  return AssignmentsListView.create(
                      context, account, course, id, assignments);
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
            CustomNavigationBar.create(context, name, account, 2));
  }
}
