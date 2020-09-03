import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_hub/theming.dart';
import '../backend.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';

class AccountPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;

  AccountPage({this.account, this.name});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  Widget build(BuildContext context) {
    GoogleSignInAccount account = widget.account;
    String name = widget.name;
    //checks if the user is signed in, if not, they are signed in
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(context, name, account);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, "Account Details"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 5));
              }
            })
        : CustomScaffold.create(context, name, account);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(
      BuildContext context, String name, GoogleSignInAccount account) {
    return new Scaffold(
        //returns the custom app bar with the account page title
        appBar: CustomAppBar.create(context, "Account Details"),
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
              Text(
                //gets Google Account's display name
                "${account.displayName}", style: subtitleStyle,
              ),
              SizedBox(
                height: 10,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                //returns the account's profile picture in the centre
                child: Image.network(
                  account.photoUrl,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              RaisedButton(
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
                  onPressed: () {
                    _pushSignOut(context, account);
                  })
            ],
          ),
        ),
        //creates the bottom navigation bar
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, account, 5));
  }

  static void _pushSignOut(BuildContext context, GoogleSignInAccount account) {
    Map args = {"account": null};
    Navigator.of(context).pushReplacementNamed('/account', arguments: args);
  }
}
