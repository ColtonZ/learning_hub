import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:learning_hub/theming.dart';

import '../objects/customUser.dart';

import '../backend/firestoreBackend.dart';

class PortalWebView extends StatefulWidget {
  //takes in the widget's arguments
  final CustomUser user;
  final String url;

  PortalWebView({this.user, this.url});

  @override
  //initialises the tannoy page state
  PortalWebViewState createState() => PortalWebViewState();
}

class PortalWebViewState extends State<PortalWebView> {
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String url = widget.url;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return _CustomBody(user: user, url: url);
  }
}

class _CustomBody extends StatefulWidget {
  final String url;
  final CustomUser user;

  _CustomBody({this.url, this.user});

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

//details the looks of the page
class _CustomBodyState extends State<_CustomBody> {
  Widget build(BuildContext context) {
    String url = widget.url;
    CustomUser user = widget.user;
    return new InAppWebView(
      //load the webview according to the specific page which was passed
      initialUrl: "https://pupils.stpaulsschool.org.uk$url",
      onLoadStart: (InAppWebViewController controller, String url) async {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                  child: AlertDialog(
                    content: Text(
                      "Page loading...",
                      style: header3Style,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onWillPop: () async => false);
            });
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        //this checks if, when a page is loaded, it is the correct one. If it is, the data is scraped and the tannoy page returned.
        //https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
        //https://medium.com/flutter-community/inappwebview-the-real-power-of-webviews-in-flutter-c6d52374209d
        Navigator.of(context).canPop();

        String currentPage = await controller.getUrl();
        //automatically fill the username box of the page
        if (currentPage.startsWith("https://isams.stpaulsschool.org.uk/auth")) {
          await controller.evaluateJavascript(
              source:
                  "document.getElementById('login-username').value = \"${user.firebaseUser.email.replaceAll("@stpaulsschool.org.uk", "")}\"");
        }
        //checks if the url ends with the same url that was passed (i.e. we are not on the login page)
        if (currentPage.contains("/api/information/bulletin/")) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    child: AlertDialog(
                      content: Text(
                        "Today's tannoy notices are being fetched from ISAMS, please wait.\n\nDo not close this page.",
                        style: header3Style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onWillPop: () async => false);
              });
          //evaluates the JavaScript, which gets a list of tannoy notices as a string, with each notice split by a semicolon, having been scraped from the page's html.
          String tannoyText = await controller.evaluateJavascript(
              source:
                  "output = \"\"; var list = document.getElementsByTagName(\"td\");for(var i = 4; i<list.length; i++){if(i%4!=3){output += list[i].textContent;output+=\":-:\"}}");
          //this adds the tannoy notices to the Firestore database, before pushing the tannoy page again
          addTannoy(user.firebaseUser, tannoyText).then((_) {
            Navigator.of(context).canPop();
            _pushTannoyPage(context, user);
          });
        }
      },
    );
  }

//defines the method for pushing the tannoy page
  static void _pushTannoyPage(BuildContext context, CustomUser user) {
    Map args = {"user": user};
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/tannoy', ModalRoute.withName("/"),
        arguments: args);
  }
}
