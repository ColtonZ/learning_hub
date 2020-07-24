import 'package:flutter/material.dart';
import 'account_page.dart';
import 'settings_page.dart';
import 'tannoy_page.dart';
import 'timetable_page.dart';
import 'courses_page.dart';
import 'home_page.dart';

void main() => runApp(MyApp());

//builds the app, using the HomePage as the default page
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => new HomePage(),
        '/timetable': (BuildContext context) => new TimetablePage(),
        '/courses': (BuildContext context) => new CoursesPage(),
        '/tannoy': (BuildContext context) => new TannoyPage(),
        '/settings': (BuildContext context) => new SettingsPage(),
        '/account': (BuildContext context) => new AccountPage(),
      },
    );
  }
}
