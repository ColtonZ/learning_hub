import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../objects/customUser.dart';

import '../backend/firestoreBackend.dart';

class DashboardWebView extends StatefulWidget {
  //takes in the widget's arguments
  final CustomUser user;
  final String url;

  DashboardWebView({this.user, this.url});

  @override
  //initialises the tannoy page state
  DashboardWebViewState createState() => DashboardWebViewState();
}

class DashboardWebViewState extends State<DashboardWebView> {
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
      initialUrl: "https://intranet.stpaulsschool.org.uk$url",
      onLoadStop: (InAppWebViewController controller, String url) async {
        //this checks if, when a page is loaded, it is the correct one. If it is, the data is scraped and the timetable page returned.
        //https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
        //https://medium.com/flutter-community/inappwebview-the-real-power-of-webviews-in-flutter-c6d52374209d
        String currentPage = await controller.getUrl();
        if (currentPage.startsWith(
            "https://intranet.stpaulsschool.org.uk/login/login.aspx")) {
          //automatically fill the username box on the page
          await controller.evaluateJavascript(
              source:
                  "document.getElementById('username').value = \"${user.firebaseUser.email.replaceAll("@stpaulsschool.org.uk", "")}\"");
        }
        //checks if the url ends with the same url that was passed (i.e. we are not on the login page)
        if (currentPage.endsWith("dashboard")) {
          //evaluates two pieces of JavaScript. The first gets a list of events as a string, with each event split by a semicolon, having been scraped from the page's html.
          String eventsText = await controller.evaluateJavascript(
              source:
                  "output = \"\";var list = document.getElementsByClassName(\"ff-timetable-block ff-timetable-lesson\");for(var i =0; i<list.length;i++){output+=`\${list[i].childNodes[1].childNodes[0].lastChild.textContent}, \${list[i].childNodes[1].childNodes[2].lastChild.textContent}, \${list[i].firstElementChild.attributes[1].textContent}; `;}output.substring(0, output.length-2);");
          //this gets the current week (week A or week B) from the page, using the calendar in the top right of the page. This is important, as the event list is ordered differently depending on which week it is.
          String week = await controller.evaluateJavascript(
              source:
                  "output=\"\";var list = document.getElementsByClassName(\"ff-calendar-item\");for(var i =0; i<list.length;i++){if(list[i].textContent.includes(\"Monday\")){output=list[i].textContent[list[i].textContent.indexOf(\"WEEK \")+5];}};output;");
          //this adds the events to the Firestore database, before pushing the timetable page again
          addFirestoreEvents(
            user.firebaseUser,
            eventsText,
            week,
          ).then((_) {
            _pushTimetablePage(context, user);
          });
        }
      },
    );
  }

//defines the method for pushing the timetable page
  static void _pushTimetablePage(BuildContext context, CustomUser user) {
    Map args = {"user": user};
    Navigator.of(context).pushReplacementNamed('/timetable', arguments: args);
  }
}
