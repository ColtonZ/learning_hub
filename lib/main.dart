import 'package:flutter/material.dart';
import 'package:learning_hub/theming.dart';

import 'pages/account_page.dart';
import 'pages/settings_page.dart';
import 'pages/tannoy_page.dart';
import 'pages/email_page.dart';
import 'pages/timetable_page.dart';
import 'pages/courses_page.dart';
import 'pages/assignments_page.dart';
import 'pages/assignment_page.dart';

void main() => runApp(MyApp());

//builds the app, using the HomePage as the default page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //deals with passing arguments when a new page is pushed onto the navigator
      onGenerateRoute: (route) {
        final Map arguments = route.arguments;
        final String name = route.name;
        //if the route is to the assignments page or a specific assignment page, pass the specific assignment details, otherwise just pass the account and the route name
        //if the route is / and there is no account signed in, pass null for the account
        switch (route.name) {
          //pushes the assignment page
          case "/":
            return MaterialPageRoute(builder: (_) {
              try {
                return TimetablePage(user: arguments["user"]);
              } catch (Exception) {
                return TimetablePage(user: null);
              }
            });
          //pushes the timetable page, with arguments of the user's account and the page's name
          case "/timetable":
            return MaterialPageRoute(
                builder: (_) =>
                    TimetablePage(user: arguments["user"], name: name));
          //pushes the courses page, with arguments of the user's account and the page's name
          case "/courses":
            return MaterialPageRoute(
                builder: (_) =>
                    CoursesPage(user: arguments["user"], name: name));
          //pushes the tannoy page, with arguments of the user's account and the page's name
          case "/tannoy":
            return MaterialPageRoute(
                builder: (_) =>
                    TannoyPage(user: arguments["user"], name: name));
                    case "/email":
            return MaterialPageRoute(
                builder: (_) =>
                    EmailPage(user: arguments["user"], name: name));
          //pushes the settings page, with arguments of the user's account and the page's name
          case "/settings":
            return MaterialPageRoute(
                builder: (_) =>
                    SettingsPage(user: arguments["user"], name: name));
          //pushes the account page, with arguments of the user's account and the page's name, as well as a boolean value dictating whether or not the user should be signed out before the page is loaded
          case "/account":
            return MaterialPageRoute(
                builder: (_) => AccountPage(
                    user: arguments["user"],
                    toSignOut: arguments["toSignOut"],
                    name: name));
          //pushes the assignments page, with arguments of the user's account and the page's name, as well as the id of the course (who's assignemnets you want to view) and the course's name
          case "/assignments":
            return MaterialPageRoute(
                builder: (_) => AssignmentsPage(
                      user: arguments["user"],
                      name: name,
                      id: arguments["id"],
                      course: arguments["course"],
                    ));
          //pushes the page for a specific assignment, with arguments of the user's account and the page's name, as well as the name of the course the assignment belongs to and the full assignment object
          case "/assignment":
            return MaterialPageRoute(
                builder: (_) => AssignmentPage(
                    user: arguments["user"],
                    name: name,
                    assignment: arguments["assignment"]));
          default:
            //if no route is passed, push the timetable page, with arguments of the user's account and the page's name
            return MaterialPageRoute(
                builder: (_) =>
                    TimetablePage(user: arguments["user"], name: name));
        }
      },
      initialRoute: '/',
      theme:
          WidgetsBinding.instance.window.platformBrightness == Brightness.dark
              ? darkTheme
              : lightTheme,
    );
  }
}
