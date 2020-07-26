import 'package:flutter/material.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_hub/backend.dart';

class TimetablePage extends StatefulWidget {
  final GoogleSignInAccount account;

  TimetablePage({this.account});

  @override
  //initialises the timetable page state
  TimetablePageState createState() => TimetablePageState();
}

class TimetablePageState extends State<TimetablePage> {
  GoogleSignInAccount account;

  Widget build(BuildContext context) {
    GoogleSignInAccount account = widget.account;
    return Scaffold(
        //returns the custom app bar with the home page title
        appBar: CustomAppBar.create(context, "Account Details"),
        //checks if the account is null - asks you to sign in if it is, otherwise returns the text: "Signed in!"
        body: account != null
            ? CustomBody.create(context, account)
            : FutureBuilder(
                //gets the user to sign in
                future: signIn(),
                //if user is still signing in, return loading indicator, otherwise display home page
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    account = snapshot.data;
                    //returns home page
                    return CustomBody.create(context, account);
                  } else {
                    //whilst logging in, return a circular progress indicator
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
        bottomNavigationBar: CustomNavigationBar.create(context, account, 1));
  }
}

class CustomBody {
  //creates the body of the app with the given account to provide consistency
  static Center create(BuildContext context, GoogleSignInAccount account) {
    return new Center();
  }
}
