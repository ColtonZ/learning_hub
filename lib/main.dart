import 'package:flutter/material.dart';
import 'pages/account_page.dart';
import 'pages/settings_page.dart';
import 'pages/tannoy_page.dart';
import 'pages/timetable_page.dart';
import 'pages/courses_page.dart';
import 'pages/home_page.dart';
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
          case "/":
            return MaterialPageRoute(builder: (_) {
              try {
                return HomePage(account: arguments["account"]);
              } catch (Exception) {
                return HomePage(account: null);
              }
            });
          case "/timetable":
            return MaterialPageRoute(
                builder: (_) =>
                    TimetablePage(account: arguments["account"], name: name));
          case "/courses":
            return MaterialPageRoute(
                builder: (_) =>
                    CoursesPage(account: arguments["account"], name: name));
          case "/tannoy":
            return MaterialPageRoute(
                builder: (_) =>
                    TannoyPage(account: arguments["account"], name: name));
          case "/settings":
            return MaterialPageRoute(
                builder: (_) =>
                    SettingsPage(account: arguments["account"], name: name));
          case "/account":
            return MaterialPageRoute(
                builder: (_) =>
                    AccountPage(account: arguments["account"], name: name));
          case "/assignments":
            return MaterialPageRoute(
                builder: (_) => AssignmentsPage(
                    account: arguments["account"],
                    name: name,
                    id: arguments["id"],
                    course: arguments["course"]));
          case "/assignment":
            return MaterialPageRoute(
                builder: (_) => AssignmentPage(
                    account: arguments["account"],
                    name: name,
                    course: arguments["course"],
                    assignment: arguments["assignment"]));
          default:
            return MaterialPageRoute(
                builder: (_) =>
                    HomePage(account: arguments["account"], name: name));
        }
      },
      initialRoute: '/',
    );
  }
}
