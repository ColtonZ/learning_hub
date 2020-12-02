import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';
import '../backend/authBackend.dart';

import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';

class AccountPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final CustomUser user;
  final bool toSignOut;

  AccountPage({this.account, this.user, this.name, this.toSignOut});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    bool toSignOut = widget.toSignOut;

    //checks if the user is signed in, if not, they are signed in, otherwise the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(toSignOut),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page
                return _CustomScaffold(name: name, user: user);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar(title: "Account Details"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 4));
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
    CustomUser user = widget.user;
    String name = widget.name;
    return new Scaffold(
        //returns the custom app bar with the account page title
        appBar: CustomAppBar(title: "Account Details"),
        //designs the account page
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Account Name:",
                style: titleStyle,
              ),
              SizedBox(
                height: 5,
              ),
              //creates a widget with the account's name
              Text(
                //gets Google Account's display name
                "${user.firebaseUser.displayName}", style: subtitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
              //returns the account's profile picture, within a square with curved corners
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                //returns the account's profile picture in the centre
                child: Image.network(
                  user.firebaseUser.photoURL,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              //creates a Sign Out button
              RaisedButton(
                  color: Theme.of(context).accentColor,
                  child: Container(
                    width: 100,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Sign Out",
                            style: header3Style,
                          ),
                        ),
                        Icon(Icons.logout),
                      ],
                    ),
                  ),
                  //when pressed, call the sign out method
                  onPressed: () {
                    _pushSignOut(context, user);
                  })
            ],
          ),
        ),
        //creates the bottom navigation bar
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 4));
  }

  //to sign out, push the account page again, but without any user data, and with an argument telling the page to sign out first
  static void _pushSignOut(BuildContext context, CustomUser user) {
    Map args = {"user": null, "toSignOut": true};
    Navigator.of(context).pushReplacementNamed('/account', arguments: args);
  }
}
