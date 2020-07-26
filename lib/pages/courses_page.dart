import 'package:flutter/material.dart';
import 'package:learning_hub/objects/custom_list_view.dart';
//import 'package:learning_hub/objects/custom_list_view.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';

class CoursesPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;

  CoursesPage({this.account});

  @override
  //initialises the courses page state
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  Widget build(BuildContext context) {
    GoogleSignInAccount account = widget.account;
    //checks if the user is signed in, if not, they are signed in
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(context, account);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, "Your Courses"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, account, 2));
              }
            })
        : CustomScaffold.create(context, account);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, GoogleSignInAccount account) {
    return new Scaffold(
        //returns the custom app bar with the courses page title
        appBar: CustomAppBar.create(context, "Your Courses"),
        //builds the body
        body: FutureBuilder(
            future: getCourses(account),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                List<List<String>> combinedList = snapshot.data;
                combinedList.forEach((element) {
                  element.forEach((item) {
                    print(item);
                  });
                });
                //checks if the user has courses. If they do, return the courses, otherwise return an error message
                try {
                  return CustomListView.create(
                      context, combinedList[0], combinedList[1]);
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
        bottomNavigationBar: CustomNavigationBar.create(context, account, 2));
  }
}
