import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:learning_hub/theming.dart';

import '../objects/customUser.dart';

import '../backend/firestoreBackend.dart';

class DashboardWebView extends StatefulWidget {
  //takes in the widget's arguments
  final CustomUser user;
  final String url;
  final bool events;

  DashboardWebView({this.user, this.url, this.events});

  @override
  //initialises the tannoy page state
  DashboardWebViewState createState() => DashboardWebViewState();
}

class DashboardWebViewState extends State<DashboardWebView> {
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String url = widget.url;
    bool events = widget.events;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return _CustomBody(
      user: user,
      url: url,
      events: events,
    );
  }
}

class _CustomBody extends StatefulWidget {
  final String url;
  final CustomUser user;
  final bool events;

  _CustomBody({this.url, this.user, this.events});

  @override
  _CustomBodyState createState() => _CustomBodyState();
}

//details the looks of the page
class _CustomBodyState extends State<_CustomBody> {
  Widget build(BuildContext context) {
    String url = widget.url;
    CustomUser user = widget.user;
    bool events = widget.events;
    return new InAppWebView(
      //load the webview according to the specific page which was passed
      initialUrl: "https://intranet.stpaulsschool.org.uk$url",
      //when loading begins, display a loading dialog box to the user
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
        //this checks if, when a page is loaded, it is the correct one. If it is, the data is scraped and the timetable page returned.
        //https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
        //https://medium.com/flutter-community/inappwebview-the-real-power-of-webviews-in-flutter-c6d52374209d
        //pop the loading dialog box
        Navigator.of(context).pop();

        String currentPage = await controller.getUrl();
        if (currentPage.startsWith(
            "https://intranet.stpaulsschool.org.uk/login/login.aspx")) {
          //automatically fill the username box on the page
          await controller.evaluateJavascript(
              source:
                  "document.getElementById('username').value = \"${user.firebaseUser.email.replaceAll("@stpaulsschool.org.uk", "")}\"");
        }
        //checks if the url ends with the same url that was passed (i.e. we are not on the login page)
        if (currentPage.endsWith("/dashboard")) {
          //shows a dialog box, telling the user that their events are currently being fetched (or that the week is updating, depending on the value of events)
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return WillPopScope(
                    child: AlertDialog(
                      content: Text(
                        events
                            ? "Your events are being fetched from Firefly, please wait.\n\nDo not close this page."
                            : "The current week is being fetched from Firefly, please wait.\n\nDo not close this page.",
                        style: header3Style,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    onWillPop: () async => false);
              });
          //evaluates two pieces of JavaScript. The first gets a list of events as a string, with each event split by a semicolon, having been scraped from the page's html.
          String eventsText = events
              ? await controller.evaluateJavascript(
                  source:
                      "output = \"\";var list = document.getElementsByClassName(\"ff-timetable-block ff-timetable-lesson\");for(var i =0; i<list.length;i++){output+=`\${list[i].childNodes[1].childNodes[0].lastChild.textContent}, \${list[i].childNodes[1].childNodes[2].lastChild.textContent}, \${list[i].firstElementChild.attributes[1].textContent}; `;}output.substring(0, output.length-2);")
              : null;
          //this gets the current week (week A or week B) from the page, using the calendar in the top right of the page. This is important, as the event list is ordered differently depending on which week it is.
          String week = await controller.evaluateJavascript(
              source:
                  "output=\"\";var list = document.getElementsByClassName(\"ff-calendar-item\");for(var i =0; i<list.length;i++){if(list[i].textContent.includes(\"Monday\")){output=list[i].textContent[list[i].textContent.indexOf(\"WEEK \")+5];}};output;");
          //this adds the events to the Firestore database, before popping the dialog box & pushing the timetable page again
          events
              ? addFirestoreEvents(
                  databaseReference,
                  user.firebaseUser,
                  eventsText,
                  week,
                ).then((_) {
                  Navigator.of(context).canPop();
                  _pushTimetablePage(context, user);
                })
              : updateFirestoreWeek(
                      databaseReference,
                      user.firebaseUser,
                      DateTime.now().weekday == 1
                          ? week
                          : week == "A"
                              ? "B"
                              : "A")
                  .then((_) {
                  Navigator.of(context).canPop();
                  _pushTimetablePage(context, user);
                });
        }
      },
    );
  }

//defines the method for pushing the timetable page
  static void _pushTimetablePage(BuildContext context, CustomUser user) {
    Map args = {"user": user};
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/timetable', ModalRoute.withName("/"),
        arguments: args);
  }
}
