import 'package:flutter/material.dart';

import '../theming.dart';
import 'customUser.dart';
import 'event.dart';

class EventsListView {
  //creates a list view
  static ListView create(
      BuildContext context, CustomUser user, List<Event> events) {
    return ListView.builder(
      itemCount: (events.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or event details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the course
        return _buildCustomListRow(context, user, events[index]);
      },
    );
  }

  //builds the list tile for the course
  static Widget _buildCustomListRow(
      BuildContext context, CustomUser user, Event event) {
    //checks if list tile should have subtitle
    return ListTile(
        leading: Text("${event.times[0][1]}\n${event.times[0][2]}"),
        title: Text(
          //returns the tile header as the subject
          event.name, style: subtitleStyle,
        ),
        //returns other details as the subtitle
        subtitle: Text(
          "${event.location == null ? "" : event.location}${event.location != null && event.teacher != null ? " • " : ""}${event.teacher == null ? "" : event.teacher}",
          style: header3Style,
        ),
        //opens the assignments of the course when you click on it
        onTap: () {});
  }
}
