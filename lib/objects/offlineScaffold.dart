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
      appBar: CustomAppBar(title: "You Are Offline", reload: true),
      //designs the offline page
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onVerticalDragEnd: (details) {
          if (details.primaryVelocity > 0) {
            Navigator.of(context).pushReplacementNamed("/");
          }
        },
        child: Center(
          child: Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This app does not work offline.\n\nPlease refresh the page when online to access your data.",
                  style: subtitleStyle,
                  textAlign: TextAlign.center,
                ),
                Container(
                  height: 15,
                ),
                Text(
                  "This can be done by swiping down, or by tapping the reload icon in the top right hand corner.",
                  style: header3Style,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
