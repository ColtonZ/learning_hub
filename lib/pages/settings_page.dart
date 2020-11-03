import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/user.dart';

import '../backend/authBackend.dart';

class SettingsPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final User user;

  SettingsPage({this.account, this.user, this.name});

  @override
  //initialises the settings page state
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    User user = widget.user;
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
                    appBar: CustomAppBar.create(context, "Settings"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 4));
              }
            })
        : CustomScaffold.create(context, name, user);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, User user) {
    return new Scaffold(
        //returns the custom app bar with the settings page title
        appBar: CustomAppBar.create(context, "Settings"),
        //builds the body
        body: Center(child: Text(user.name, style: titleStyle)),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 4));
  }
}
