import 'package:flutter/material.dart';
import 'package:learning_hub/objects/custom_list_view.dart';
//import 'package:learning_hub/objects/custom_list_view.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';

class CoursesPage extends StatefulWidget {
  final GoogleSignInAccount account;

  CoursesPage({this.account});

  @override
  //initialises the courses page state
  CoursesPageState createState() => CoursesPageState();
}

class CoursesPageState extends State<CoursesPage> {
  GoogleSignInAccount account;

  Widget build(BuildContext context) {
    GoogleSignInAccount account = widget.account;
    return Scaffold(
        //returns the custom app bar with the home page title
        appBar: CustomAppBar.create(context, "Account Details"),
        //checks if the account is null - asks you to sign in if it is, otherwise returns the text: "Signed in!"
        body: FutureBuilder(
            //gets the user to sign in
            future: getCourses(account),
            //if user is still signing in, return loading indicator, otherwise display home page
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(snapshot.data);
                //print("Type: " + snapshot.data.runtimeType);
                return CustomBody.create(
                    context, snapshot.data[0], snapshot.data[1]);
              } else {
                //whilst logging in, return a circular progress indicator
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            }),
        bottomNavigationBar: CustomNavigationBar.create(context, account, 2));
  }
}

class CustomBody {
  //creates the body of the app with the given account to provide consistency
  static Center create(
      BuildContext context, List<String> titles, List<String> subtitles) {
    return new Center(
      child: CustomListView.create(context, titles, subtitles),
    );
  }
}
