import 'package:flutter/material.dart';

import 'package:learning_hub/objects/assignments_list_view.dart';
import 'package:learning_hub/theming.dart';
import 'package:learning_hub/constants.dart';

import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';
import '../objects/customUser.dart';
import '../objects/events_list_view.dart';
import '../objects/addEventPopup.dart';
import '../objects/addPersonalTask.dart';

import '../backend/authBackend.dart';
import '../backend/firestoreBackend.dart';
import '../backend/eventsBackend.dart';
import '../backend/courseWorkBackend.dart';

import '../pages/web_view_page.dart';

class TimetablePage extends StatefulWidget {
  //takes in the widget's arguments
  final String name;
  final CustomUser user;

  TimetablePage({this.user, this.name});

  @override
  //initialises the timetable page state
  TimetablePageState createState() => TimetablePageState();
}

class TimetablePageState extends State<TimetablePage> {
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
                //once the user has been signed in, load the page
                return _CustomScaffold(user: user, name: name);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar(title: "Your Timetable", reload: true),
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
    DateTime time = DateTime.now();
    return Scaffold(
        //returns the custom app bar with the timetable page title
        appBar: CustomAppBar(title: "Your Timetable", reload: true),
        //builds the body
        //checks if the user has at least one event in the Firestore database added automatically from Firefly. If they do, load the timetable page.
        //Otherwise, display a web view, which will allow the user to login to Firefly and then will scrape the dashboard for the user's timetable data.
        body: FutureBuilder(
            //counts how many Firefly events the user has
            future: getEventsList(user.firebaseUser),
            //https://flutter.dev/docs/development/ui/interactive
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null || snapshot.data.length == 0) {
                  //if they have no events, return a web view body so the user can login to Firefly
                  //https://stackoverflow.com/questions/54691767/navigation-inside-nested-future
                  return WebViewPage(
                    user: user,
                    //this url is the page on the site https://intranet.stpaulsschool.org.uk to access
                    url: "/dashboard",
                  );
                } else {
                  //otherwise build the page
                  return _MainPage(time: time, name: name, user: user);
                }
              } else {
                //whilst getting courses, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 0));
  }
}

class _MainPage extends StatefulWidget {
  final CustomUser user;
  final String name;
  final DateTime time;
  final String week;

  _MainPage({this.user, this.name, this.time, this.week});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<_MainPage> {
  DateTime time = DateTime.now();
  String week = "A";
  bool tasksReload = false;

  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;

    return Column(
      //split the page into two: today's events, and the tasks that need doing
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () async {
                  DateTime picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now().subtract(Duration(days: 365)),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (picked != null && picked != DateTime.now())
                    setState(() {
                      time = picked;
                    });
                },
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_left),
                    onPressed: () {
                      setState(() {
                        time = time.subtract(Duration(days: 1));
                      });
                    },
                  ),
                  Text(
                    "Your Events",
                    style: titleStyle,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_right),
                    onPressed: () {
                      setState(() {
                        time = time.add(Duration(days: 1));
                      });
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddEvent(user: user);
                      }).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        ),
        Container(
          height: 5,
        ),
        FutureBuilder(
            future: getCurrentWeek(user.firebaseUser, time),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                week = snapshot.data;
                return Text(
                  "${days[time.weekday - 1]} ${time.day} ${months[time.month - 1]} ${time.year} | Week ${snapshot.data}",
                  style: subtitleStyle,
                );
              } else {
                return Text(
                  "${days[time.weekday - 1]} ${time.day} ${months[time.month - 1]} ${time.year} | Week $week",
                  style: subtitleStyle,
                );
              }
            }),
        Divider(),
        Expanded(
          child: FutureBuilder(
            //get a list of today's events
            future: getEventsList(user.firebaseUser)
                .then((events) => getEvents(time, user.firebaseUser, events)),
            builder: (context, eventsSnaphsot) {
              if (eventsSnaphsot.connectionState == ConnectionState.done) {
                if (eventsSnaphsot.data.length > 0) {
                  //if there's more than one event today, create a list view of today's events
                  return EventsListView(
                      user: user, events: eventsSnaphsot.data);
                } else {
                  //if there are no events in the calendar today, tell the user as much
                  return Center(
                    child:
                        Text("You have no events in the calendar on this day."),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 0, 0),
              child: IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () {
                  setState(() {
                    tasksReload = true;
                  });
                },
              ),
            ),
            Expanded(
              child: Text(
                "Tasks To-Do",
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 14, 0),
              child: IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AddPersonalTask(user: user);
                      }).then((_) {
                    setState(() {});
                  });
                },
              ),
            ),
          ],
        ),
        Divider(),
        Expanded(
          child: FutureBuilder(
            //get the user's tasks that need doing
            future: tasksToDo(user, tasksReload),
            builder: (context, tasksSnapshot) {
              if (tasksSnapshot.connectionState == ConnectionState.done) {
                tasksReload = false;
                if (tasksSnapshot.data.length > 0) {
                  //if the user has tasks to do, return a list view of their tasks
                  return AssignmentsListView(
                      user: user, assignments: tasksSnapshot.data);
                } else {
                  //if a user has no tasks to do, tell them as much.
                  return Center(
                      child: Text("You have no incomplete assignments."));
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ],
    );
  }
}
