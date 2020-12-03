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
            future: signIn(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, the page is loaded
                return _CustomScaffold(name: name, user: user);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar(title: "Your Courses", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 1));
              }
            })
        : _CustomScaffold(name: name, user: user);
  }
}

class _CustomScaffold extends StatefulWidget {
  final String name;
  final CustomUser user;

  _CustomScaffold({this.name, this.user});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

//details the looks of the page
class _CustomScaffoldState extends State<_CustomScaffold> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    return new Scaffold(
        //returns the custom app bar with the courses page title
        appBar: CustomAppBar(title: "Your Courses", reload: false),
        //builds the body
        body: FutureBuilder(
            future: getCourses(user),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<Course> courses = snapshot.data;
                //checks if the user has courses. If they do, return the courses, otherwise return an error message
                try {
                  //creates a list view of the courses
                  return CoursesListView(user: user, courses: courses);
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
            CustomNavigationBar(name: name, user: user, index: 1));
  }
}
