import 'package:flutter/material.dart';

class CustomNavigationBar {
  //creates a new navigation bar with the given tabs to provide consistency
  static BottomNavigationBar create(BuildContext context) {
    return new BottomNavigationBar(
      items: <BottomNavigationBarItem>[
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
      currentIndex: 1,
      selectedItemColor: Colors.amber[800],
      unselectedItemColor: Colors.black,
      onTap: null,
    );
  }
}
