import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../backend.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';

class AccountPage extends StatefulWidget {
  final GoogleSignInAccount account;

  AccountPage({this.account});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  @override
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
        bottomNavigationBar: CustomNavigationBar.create(context, 5));
  }
}

class CustomBody {
  //creates the body of the app with the given account to provide consistency
  static Center create(BuildContext context, GoogleSignInAccount account) {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Account Name:"),
          SizedBox(
            height: 5,
          ),
          Text(
              //gets Google Account's display name
              "${account.displayName}"),
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
        ],
      ),
    );
  }
}