import 'package:flutter/material.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';

import '../backend/authBackend.dart';

class TannoyPage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final CustomUser user;

  TannoyPage({this.user, this.name});

  @override
  //initialises the tannoy page state
  TannoyPageState createState() => TannoyPageState();
}

class TannoyPageState extends State<TannoyPage> {
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
                    appBar: CustomAppBar.create(context, "Tannoy Notices"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 2));
              }
            })
        : CustomScaffold.create(context, name, user);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, CustomUser user) {
    return new Scaffold(
        //returns the custom app bar with the tannoy page title
        appBar: CustomAppBar.create(context, "Tannoy Notices"),
        //builds the body
        body: Center(
            child: Text(
          user.firebaseUser.displayName,
          style: titleStyle,
        )),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 2));
  }
}
