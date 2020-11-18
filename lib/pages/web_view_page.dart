import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../objects/user.dart';

import '../backend/firestoreBackend.dart';

class WebViewPage extends StatefulWidget {
  //takes in the widget's arguments
  final User user;
  final String url;

  WebViewPage({this.user, this.url});

  @override
  //initialises the tannoy page state
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  Widget build(BuildContext context) {
    User user = widget.user;
    String url = widget.url;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return CustomBody.create(context, user, url);
  }
}

//details the looks of the page
class CustomBody {
  static Widget create(BuildContext context, User user, String url) {
    InAppWebViewController _webViewController;
    return new InAppWebView(
      initialUrl: "https://intranet.stpaulsschool.org.uk$url",
      onWebViewCreated: (InAppWebViewController controller) {
        _webViewController = controller;
      },
      onLoadStop: (InAppWebViewController controller, String url) async {
        //https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
        //https://medium.com/flutter-community/inappwebview-the-real-power-of-webviews-in-flutter-c6d52374209d
        String currentPage = await controller.getUrl();
        if (currentPage.endsWith(url)) {
          String eventsText = await controller.evaluateJavascript(
              source:
                  "output = \"\";var list = document.getElementsByClassName(\"ff-timetable-block ff-timetable-lesson\");for(var i =0; i<list.length;i++){output+=`\${list[i].childNodes[1].childNodes[0].lastChild.textContent}, \${list[i].childNodes[1].childNodes[2].lastChild.textContent}, \${list[i].firstElementChild.attributes[1].textContent}; `;}output.substring(0, output.length-2);");
          String week = await controller.evaluateJavascript(
              source:
                  "output=\"\";var list = document.getElementsByClassName(\"ff-calendar-item\");for(var i =0; i<list.length;i++){if(list[i].textContent.includes(\"Monday\")){output=list[i].textContent[list[i].textContent.indexOf(\"WEEK \")+5];}};output;");
          addFirestoreEvents(eventsText, week, user.firestoreId).then((_) {
            _pushTimetablePage(context, user);
          });
        }
      },
    );
  }

  static void _pushTimetablePage(BuildContext context, User user) {
    Map args = {"user": user};
    Navigator.of(context).pushReplacementNamed('/timetable', arguments: args);
  }
}
