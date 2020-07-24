import 'package:flutter/material.dart';

class CustomNavigationBar {
  static void _pushAccountPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/account');
  }

  static void _pushCoursesPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/courses');
  }

  static void _pushHomePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/');
  }

  static void _pushSettingsPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/settings');
  }

  static void _pushTannoyPage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/tannoy');
  }

  static void _pushTimetablePage(BuildContext context) {
    Navigator.of(context).pushReplacementNamed('/timetable');
  }

  //creates a new navigation bar with the given tabs to provide consistency
  static BottomNavigationBar create(BuildContext context, int index) {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text('Home Page'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Your Timetable'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Your Tasks'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox),
          title: Text('Tannoy Notices'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text('Your Profile'),
        ),
      ],
      currentIndex: index,
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (value) {
        switch (value) {
          case 0:
            _pushHomePage(context);
            break;
          case 1:
            _pushTimetablePage(context);
            break;
          case 2:
            _pushCoursesPage(context);
            break;
          case 3:
            _pushTannoyPage(context);
            break;
          case 4:
            _pushSettingsPage(context);
            break;
          case 5:
            _pushAccountPage(context);
            break;
          default:
        }
      },
    );
  }
}
