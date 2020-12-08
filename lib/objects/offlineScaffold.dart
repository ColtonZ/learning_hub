import 'package:flutter/material.dart';

import '../theming.dart';

import 'custom_app_bar.dart';

class OfflineScaffold extends StatefulWidget {
  //this is what the scaffold of the page will look like if the user is offline
  OfflineScaffold();

  @override
  OfflineScaffoldState createState() => OfflineScaffoldState();
}

class OfflineScaffoldState extends State<OfflineScaffold> {
  Widget build(BuildContext context) {
    return new Scaffold(
      //returns the custom app bar with a message telling the user they are offline
      appBar: CustomAppBar(title: "You Are Offline", reload: false),
      //designs the offline page
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
