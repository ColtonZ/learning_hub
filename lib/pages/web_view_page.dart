import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/user.dart';

import '../backend/authBackend.dart';

class WebViewPage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final User user;
  final String url;

  WebViewPage({this.user, this.name, this.url});

  @override
  //initialises the tannoy page state
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    User user = widget.user;
    String url = widget.url;
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
                    appBar:
                        CustomAppBar.create(context, "Check Your Timetable"),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 1));
              }
            })
        : CustomScaffold.create(context, name, user);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(BuildContext context, String name, User user) {
    InAppWebViewController _webViewController;
    return new Scaffold(
        //returns the custom app bar with the tannoy page title
        appBar: CustomAppBar.create(context, "Login to Firefly"),
        //builds the body
        body: InAppWebView(
            initialUrl: "https://flutter.dev/",
            initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
              debuggingEnabled: true,
            )),
            onWebViewCreated: (InAppWebViewController controller) {
              _webViewController = controller;
            },
            onLoadStart: (InAppWebViewController controller, String url) {},
            onLoadStop:
                (InAppWebViewController controller, String url) async {},
            onProgressChanged:
                (InAppWebViewController controller, int progress) {}),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 1));
  }
}
