import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/course.dart';
import '../objects/courses_list_view.dart';
import '../objects/customUser.dart';

import '../backend/courseWorkBackend.dart';
import '../backend/authBackend.dart';

class CoursesPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final CustomUser user;

  CoursesPage({this.account, this.user, this.name});

  @override
  //initialises the courses page state
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, the page is loaded
                return CustomScaffold.create(context, name, user);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, "Your Courses"),
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
  static Scaffold create(BuildContext context, String name, CustomUser user) {
    return new Scaffold(
        //returns the custom app bar with the courses page title
        appBar: CustomAppBar.create(context, "Your Courses"),
        //builds the body
        body: FutureBuilder(
            future: getCourses(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Course> courses = snapshot.data;
                //checks if the user has courses. If they do, return the courses, otherwise return an error message
                try {
                  //creates a list view of the courses
                  return CoursesListView.create(context, user, courses);
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
            CustomNavigationBar.create(context, name, user, 1));
  }
}
