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
        appBar: CustomAppBar.create(context, "Your Timetable"),
        //checks if the account is null - asks you to sign in if it is, otherwise returns the text: "Signed in!"
        body: Center(child: Text(account.email)),
        bottomNavigationBar: CustomNavigationBar.create(context, account, 1));
  }
}
