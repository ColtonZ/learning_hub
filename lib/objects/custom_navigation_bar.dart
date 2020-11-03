import 'package:flutter/material.dart';

import 'user.dart';
import '../theming.dart';

class CustomNavigationBar {
  //defines a series of methods, each with the route of the page to push and any additional logic, as well as arguments.
  //each page will ensure that, if coming from the assignments or assignment page to pop back far enough, as otherwise you may end up with too many pages on top of each other
  static void _pushAccountPage(BuildContext context, String name, User user) {
    Map args = {"user": user};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/account', arguments: args);
  }

  static void _pushCoursesPage(BuildContext context, String name, User user) {
    Map args = {"user": user};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/courses', arguments: args);
  }

  static void _pushHomePage(BuildContext context, String name, User user) {
    Map args = {"user": user};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/', arguments: args);
  }

  static void _pushSettingsPage(BuildContext context, String name, User user) {
    Map args = {"user": user};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/settings', arguments: args);
  }

  static void _pushTannoyPage(BuildContext context, String name, User user) {
    Map args = {"user": user};
    if (name == "/assignments") {
      Navigator.of(context).pop();
    }
    if (name == "/assignment") {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed('/tannoy', arguments: args);
  }

  static void _pushTimetablePage(BuildContext context, String name, User user) {
    Map args = {"user": user};
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
  static BottomNavigationBar create(
      BuildContext context, String name, User user, int index) {
    return new BottomNavigationBar(
      //this is just a list of BottomNavigationBarItems - for each item, it has an icon and a title
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          title: Text(
            'Home',
            style: navigationBarStyle,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text(
            'Timetable',
            style: navigationBarStyle,
            textAlign: TextAlign.center,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          title: Text(
            'Tasks',
            style: navigationBarStyle,
            textAlign: TextAlign.center,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inbox),
          title: Text(
            'Tannoy',
            style: navigationBarStyle,
            textAlign: TextAlign.center,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text(
            //this has a blank line at the end so it's the same height as the other icons
            'Settings',
            style: navigationBarStyle,
            textAlign: TextAlign.center,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_box),
          title: Text(
            'Profile',
            style: navigationBarStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ],
      //details other information about the navigation bar
      currentIndex: index,
      selectedItemColor: accentColour,
      unselectedItemColor: Colors.black,
      //the type just says that the icons should not move when selected
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      //handles logic for what to do when an icon is selected at the bottom
      //for each case, check the index of the icon that was pressed, and push the correct page accordingly
      onTap: (value) {
        switch (value) {
          case 0:
            _pushHomePage(context, name, user);
            break;
          case 1:
            _pushTimetablePage(context, name, user);
            break;
          case 2:
            _pushCoursesPage(context, name, user);
            break;
          case 3:
            _pushTannoyPage(context, name, user);
            break;
          case 4:
            _pushSettingsPage(context, name, user);
            break;
          case 5:
            _pushAccountPage(context, name, user);
            break;
          default:
        }
      },
    );
  }
}
