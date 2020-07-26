import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    GoogleSignInAccount account = widget.account;
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(context, account);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            })
        : CustomScaffold.create(context, account);
  }
}

class CustomScaffold {
  //creates the body of the app with the given account to provide consistency
  static Scaffold create(BuildContext context, GoogleSignInAccount account) {
    return new Scaffold(
        //returns the custom app bar with the home page title
        appBar: CustomAppBar.create(context, "Your Courses"),
        //checks if the account is null - asks you to sign in if it is, otherwise returns the text: "Signed in!"
        body: Center(child: Text(account.email)),
        bottomNavigationBar: CustomNavigationBar.create(context, account, 2));
  }
}
