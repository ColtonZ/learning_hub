import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';
import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';

import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';
import '../objects/offlineScaffold.dart';

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
                if (user != null) {
                  return _CustomScaffold(name: name, user: user);
                } else {
                  return OfflineScaffold();
                }
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar(title: "Your Account", reload: false),
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
  bool showEventConfirm = false;
  bool showTasksConfirm = false;
  bool showAllConfirm = false;
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String name = widget.name;
    return new Scaffold(
        //returns the custom app bar with the account page title
        appBar: CustomAppBar(title: "Account Details", reload: false),
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
                  }),
              Container(
                height: 10,
              ),
              Divider(),

              Text("Delete Your Data", style: titleStyle),
              Divider(),
              Container(
                height: 10,
              ),
              showEventConfirm
                  ? Column(children: [
                      Text(
                        "Are you sure you wish to delete all event data?\n\nThis action cannot be undone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      Container(height: 5),
                    ])
                  : Container(),
              showEventConfirm
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FlatButton(
                          child: Text(
                            "Delete",
                            style: header3Style,
                          ),
                          onPressed: () {
                            deleteData(user.firebaseUser, 0).then((_) {
                              setState(() {
                                showEventConfirm = false;
                              });
                            });
                          }),
                      Container(
                        width: 15,
                      ),
                      FlatButton(
                          child: Text(
                            "Cancel",
                            style: header3Style,
                          ),
                          onPressed: () {
                            setState(() {
                              showEventConfirm = false;
                            });
                          }),
                    ])
                  : !showTasksConfirm && !showAllConfirm
                      ? FlatButton(
                          child:
                              Text("Delete Your Events", style: header3Style),
                          onPressed: () {
                            setState(() {
                              showTasksConfirm = false;
                              showEventConfirm = true;
                              showAllConfirm = false;
                            });
                          })
                      : Container(),
              showTasksConfirm
                  ? Column(children: [
                      Text(
                        "Are you sure you wish to delete all task data?\n\nThis action cannot be undone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      Container(height: 5),
                    ])
                  : Container(),
              showTasksConfirm
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FlatButton(
                          child: Text(
                            "Delete",
                            style: header3Style,
                          ),
                          onPressed: () {
                            deleteData(user.firebaseUser, 1).then((_) {
                              setState(() {
                                showTasksConfirm = false;
                              });
                            });
                          }),
                      Container(
                        width: 15,
                      ),
                      FlatButton(
                          child: Text(
                            "Cancel",
                            style: header3Style,
                          ),
                          onPressed: () {
                            setState(() {
                              showTasksConfirm = false;
                            });
                          }),
                    ])
                  : !showEventConfirm && !showAllConfirm
                      ? FlatButton(
                          child: Text("Delete Your Tasks", style: header3Style),
                          onPressed: () {
                            setState(() {
                              showTasksConfirm = true;
                              showEventConfirm = false;
                              showAllConfirm = false;
                            });
                          })
                      : Container(),
              showAllConfirm
                  ? Column(children: [
                      Text(
                        "Are you sure you wish to delete all data associated with your account and logout?\n\nThis action cannot be undone.",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.red),
                      ),
                      Container(height: 5),
                    ])
                  : Container(),
              showAllConfirm
                  ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      FlatButton(
                          child: Text(
                            "Delete",
                            style: header3Style,
                          ),
                          onPressed: () {
                            deleteData(user.firebaseUser, 2).then((_) {
                              setState(() {
                                showAllConfirm = false;
                              });
                              _pushSignOut(context, user);
                            });
                          }),
                      Container(
                        width: 15,
                      ),
                      FlatButton(
                          child: Text(
                            "Cancel",
                            style: header3Style,
                          ),
                          onPressed: () {
                            setState(() {
                              showAllConfirm = false;
                            });
                          }),
                    ])
                  : !showTasksConfirm && !showEventConfirm
                      ? FlatButton(
                          child: Text(
                            "Delete Your Data",
                            style: header3Style,
                          ),
                          onPressed: () {
                            setState(() {
                              showTasksConfirm = false;
                              showEventConfirm = false;
                              showAllConfirm = true;
                            });
                          })
                      : Container(),
            ],
          ),
        ),
        //creates the bottom navigation bar
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 3));
  }

  //to sign out, push the account page again, but without any user data, and with an argument telling the page to sign out first
  static void _pushSignOut(BuildContext context, CustomUser user) {
    Map args = {"user": null, "toSignOut": true};
    Navigator.of(context).pushReplacementNamed('/account', arguments: args);
  }
}
