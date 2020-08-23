import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';

class AssignmentPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final String course;
  final String courseId;
  final String assignmentId;

  AssignmentPage(
      {this.account, this.name, this.course, this.courseId, this.assignmentId});

  @override
  //initialises the courses page state
  AssignmentPageState createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    GoogleSignInAccount account = widget.account;
    String courseId = widget.courseId;
    String course = widget.course;
    String assignmentId = widget.assignmentId;
    //checks if the user is signed in, if not, they are signed in
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(
                    context, name, account, course, courseId, assignmentId);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, course),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 2));
              }
            })
        : CustomScaffold.create(
            context, name, account, course, courseId, assignmentId);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(
      BuildContext context,
      String name,
      GoogleSignInAccount account,
      String course,
      String courseId,
      String assignmentId) {
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar.create(context, course),
        //builds the body
        body: FutureBuilder(
            future: getAssignment(courseId, assignmentId, account),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Assignment assignment = snapshot.data;
                //checks if the assignment is valid. If it is, return the assignment page, otherwise return an error message
                try {
                  return Center(
                    child: Text("${assignment.title}"),
                  );
                } catch (error) {
                  return Center(
                    child: Text("${error.toString()}"),
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
