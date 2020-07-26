import 'package:flutter/material.dart';
import 'pages/account_page.dart';
import 'pages/settings_page.dart';
import 'pages/tannoy_page.dart';
import 'pages/timetable_page.dart';
import 'pages/courses_page.dart';
import 'pages/home_page.dart';

void main() => runApp(MyApp());

//builds the app, using the HomePage as the default page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //deals with passing arguments when a new page is pushed onto the navigator
      onGenerateRoute: (route) {
        final arguments = route.arguments;
        //if the route is to the assignment page, pass the specific assignment details, otherwise just pass the account
        switch (route.name) {
          case "/":
            return MaterialPageRoute(builder: (_) => HomePage());
          case "/timetable":
            return MaterialPageRoute(builder: (_) => TimetablePage());
          case "/courses":
            return MaterialPageRoute(builder: (_) => CoursesPage());
          case "/tannoy":
            return MaterialPageRoute(builder: (_) => TannoyPage());
          case "/settings":
            return MaterialPageRoute(builder: (_) => SettingsPage());
          case "/account":
            return MaterialPageRoute(builder: (_) => AccountPage());
          default:
            return MaterialPageRoute(builder: (_) => HomePage());
        }
      },
      initialRoute: '/',
      //defines the named routes
      /*routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new HomePage(),
        '/timetable': (BuildContext context) => new TimetablePage(),
        '/courses': (BuildContext context) => new CoursesPage(),
        '/tannoy': (BuildContext context) => new TannoyPage(),
        '/settings': (BuildContext context) => new SettingsPage(),
        '/account': (BuildContext context) => new AccountPage(),
        //'/assignment': (BuildContext context) => new AssignmentPage(),
      },*/
    );
  }
}
