import 'package:flutter/material.dart';
import 'package:learning_hub/pages/portal_web_view.dart';

import 'package:learning_hub/theming.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';
import '../objects/tannoy_list_view.dart';
import '../objects/offlineScaffold.dart';

import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';

class TannoyPage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final CustomUser user;

  TannoyPage({this.user, this.name});

  @override
  //initialises the tannoy page state
  TannoyPageState createState() => TannoyPageState();
}

class TannoyPageState extends State<TannoyPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    //checks if the user is signed in, if not, they are signed in. If they are, the page is loaded
    return user == null
        ? FutureBuilder(
            future: signIn(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page, although if the user is offline, show the offline page
                if (user != null) {
                  return _CustomScaffold(user: user, name: name);
                } else {
                  return OfflineScaffold();
                }
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar:
                        CustomAppBar(title: "Tannoy Notices", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 0));
              }
            })
        : _CustomScaffold(user: user, name: name);
  }
}

class _CustomScaffold extends StatefulWidget {
  final CustomUser user;
  final String name;

  _CustomScaffold({this.user, this.name});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

//details the looks of the page
class _CustomScaffoldState extends State<_CustomScaffold> {
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String name = widget.name;
    return Scaffold(
        //returns the custom app bar with the tannoy page title
        appBar: CustomAppBar(title: "Tannoy Notices", reload: false),
        //builds the body
        //checks if the user has at least one tannoy notice in the Firestore database added automatically from the pupil portal. If they do, load the tannoy page.
        //Otherwise, display a web view, which will allow the user to login to the portal and then will scrape the dashboard for the user's tannoy data.
        body: FutureBuilder(
            //check when the tannoy notices were last updated
            future: tannoyRecentlyChecked(databaseReference, user.firebaseUser),
            //https://flutter.dev/docs/development/ui/interactive
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.data) {
                  //if the tannoy notices were not updated recently, return a web view body so the user can login to the portal
                  //https://stackoverflow.com/questions/54691767/navigation-inside-nested-future
                  return PortalWebView(
                    user: user,
                    //this url is the page on the co-curricular hub to access
                    url:
                        "https://sites.google.com/stpaulsschool.org.uk/sps-co-curricular-hub",
                  );
                } else {
                  //otherwise build the page
                  return FutureBuilder(
                      //get the tannoy notices from the user's firebase profile. If there are no tannoy notices, tell the user as such, and allow them to refresh the page.
                      future: getNotices(user.firebaseUser),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null) {
                            //return the user's tannoy notices
                            return TannoysListView(notices: snapshot.data);
                          } else {
                            //if the user has no tannoy notices, return text telling them as such.
                            //this text is inside a gesture detector, allowing them to swipe down to refresh.
                            return Center(
                              child: Container(
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onVerticalDragEnd: (details) async {
                                    if (details.primaryVelocity > 0) {
                                      //if the user swipes down, refresh the page, and search for tannoy notices again.
                                      await clearTannoy(user.firebaseUser);
                                      _pushTannoyPage(context, user);
                                    }
                                  },
                                  child: Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.fromLTRB(15, 0, 15, 0),
                                      child: Text(
                                        "You have no tannoy notices from today available to view at this time.\n\nSwipe down to refresh.",
                                        style: header3Style,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          //while loading, return a loading indicator
                        } else {
                          return Center(child: CircularProgressIndicator());
                        }
                      });
                }
              } else {
                //whilst getting notices, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 2));
  }

//defines the method for pushing the tannoy page
  static void _pushTannoyPage(BuildContext context, CustomUser user) {
    Map args = {"user": user};
    Navigator.of(context).pushNamedAndRemoveUntil(
        '/tannoy', ModalRoute.withName("/"),
        arguments: args);
  }
}
