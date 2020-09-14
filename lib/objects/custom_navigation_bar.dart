import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learning_hub/theming.dart';

class CustomNavigationBar {
  //defines a series of methods, each with the route of the page to push and any additional logic, as well as arguments.
  //each page will ensure that, if coming from the assignments or assignment page to pop back far enough, as otherwise you may end up with too many pages on top of each other
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
  //checks what the current page is, and gives it a name accordingly
  static BottomNavigationBar create(BuildContext context, String name,
      GoogleSignInAccount account, int index) {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(
            'Home Page',
            style: pageTitleStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Your Timetable', style: pageTitleStyle),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text('Your Tasks', style: pageTitleStyle),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox),
          title: Text('Tannoy Notices', style: pageTitleStyle),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings', style: pageTitleStyle),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text('Your Profile', style: pageTitleStyle),
        ),
      ],
      //details other information about the navigation bar
      currentIndex: index,
      selectedItemColor: Colors.blue[600],
      unselectedItemColor: Colors.black,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      //handles logic for what to do when an icon is selected at the bottom
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
