import 'package:flutter/material.dart';
import 'package:learning_hub/objects/courses_list_view.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend/courseWorkBackend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/course.dart';
import '../backend/authBackend.dart';

class CoursesPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;

  CoursesPage({this.account, this.name});

  @override
  //initialises the courses page state
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    GoogleSignInAccount account = widget.account;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                //once signed in, the page is loaded
                return CustomScaffold.create(context, name, account);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, "Your Courses"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 2));
              }
            })
        : CustomScaffold.create(context, name, account);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(
      BuildContext context, String name, GoogleSignInAccount account) {
    return new Scaffold(
        //returns the custom app bar with the courses page title
        appBar: CustomAppBar.create(context, "Your Courses"),
        //builds the body
        body: FutureBuilder(
            future: getCourses(account),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Course> courses = snapshot.data;
                //checks if the user has courses. If they do, return the courses, otherwise return an error message
                try {
                  //creates a list view of the courses
                  return CoursesListView.create(context, account, courses);
                } catch (Exception) {
                  return Center(
                    child: Text("You have no courses to display."),
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
