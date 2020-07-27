import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CustomNavigationBar {
  static void _pushAccountPage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/account', arguments: args);
  }

  static void _pushCoursesPage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/courses', arguments: args);
  }

  static void _pushHomePage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/', arguments: args);
  }

  static void _pushSettingsPage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/settings', arguments: args);
  }

  static void _pushTannoyPage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/tannoy', arguments: args);
  }

  static void _pushTimetablePage(
      BuildContext context, String name, GoogleSignInAccount account) {
    Map args = {"account": account};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/timetable', arguments: args);
  }

  //creates a new navigation bar with the given tabs to provide consistency
  static BottomNavigationBar create(BuildContext context, String name,
      GoogleSignInAccount account, int index) {
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
            _pushHomePage(context, name, account);
            break;
          case 1:
            _pushTimetablePage(context, name, account);
            break;
          case 2:
            _pushCoursesPage(context, name, account);
            break;
          case 3:
            _pushTannoyPage(context, name, account);
            break;
          case 4:
            _pushSettingsPage(context, name, account);
            break;
          case 5:
            _pushAccountPage(context, name, account);
            break;
          default:
        }
      },
    );
  }
}
