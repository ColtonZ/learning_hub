import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';

import '../backend/authBackend.dart';

class SettingsPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final CustomUser user;

  SettingsPage({this.account, this.user, this.name});

  @override
  //initialises the settings page state
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
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
                    appBar: CustomAppBar(title: "Settings", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 3));
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
        //TODO: Set up page to allow for all data to be wiped
        //returns the custom app bar with the settings page title
        appBar: CustomAppBar(title: "Settings", reload: false),
        //builds the body
        body: Center(
            child: Text(user.firebaseUser.displayName, style: titleStyle)),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 3));
  }
}
