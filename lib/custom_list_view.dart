import 'package:flutter/material.dart';

class CustomListView {
  //creates a list view
  static ListView create(
      BuildContext context, List<String> titles, List<String> subtitles) {
    return ListView.builder(
      itemCount: (titles.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or lesson details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the lesson
        return _buildCustomListRow(titles[index], subtitles[index]);
      },
    );
  }
}

//builds the list tile for the lesson
Widget _buildCustomListRow(String title, String subtitle) {
  //checks if list tile should have subtitle
  return subtitle != "null"
      ? ListTile(
          title: Text(
              //returns the tile header as the subject
              title),
          //returns other details as the subtitle
          subtitle: Text(subtitle))
      : ListTile(title: Text(
          //returns the tile header as the subject
          title));
}
