import 'package:flutter/material.dart';

import '../theming.dart';

import 'custom_app_bar.dart';

class OfflineScaffold extends StatefulWidget {
  //takes in the widget's arguments

  OfflineScaffold();

  @override
  OfflineScaffoldState createState() => OfflineScaffoldState();
}

class OfflineScaffoldState extends State<OfflineScaffold> {
  Widget build(BuildContext context) {
    return new Scaffold(
      //returns the custom app bar with the account page title
      appBar: CustomAppBar(title: "You Are Offline", reload: false),
      //designs the account page
      body: Center(
          child: Padding(
              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
              child: Text(
                "This app does not work offline.\n\nPlease reopen the app when online to access your data.",
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ))),
    );
  }
}
