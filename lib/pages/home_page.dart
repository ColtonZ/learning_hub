import 'package:flutter/material.dart';
import 'package:learning_hub/theming.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_hub/backend.dart';

class HomePage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;

  HomePage({this.account, this.name});

  @override
  //initialises the home page state
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    GoogleSignInAccount account = widget.account;
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
                    appBar: CustomAppBar.create(context, "Home"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 0));
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
        //returns the custom app bar with the home page title
        appBar: CustomAppBar.create(context, "Home"),
        //builds the body
        body: Center(child: Text(account.email, style: titleStyle)),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, account, 0));
  }
}
