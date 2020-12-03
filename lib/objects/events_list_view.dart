import 'package:flutter/material.dart';

import '../theming.dart';
import 'customUser.dart';
import 'event.dart';

class EventsListView extends StatefulWidget {
  final List<Event> events;
  final CustomUser user;

  EventsListView({this.events, this.user});

  @override
  EventsListViewState createState() => EventsListViewState();
}

//details the looks of the page
class EventsListViewState extends State<EventsListView> {
  Widget build(BuildContext context) {
    List<Event> events = widget.events;
    CustomUser user = widget.user;
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
    return ListTile(
        //the leading value is the event start time, with its end time below
        leading: Text(
            "${event.times[0][1].substring(0, 2)}:${event.times[0][1].substring(2)}\n${event.times[0][2].substring(0, 2)}:${event.times[0][2].substring(2)}"),
        title: Text(
          //returns the tile header as the subject
          event.name, style: subtitleStyle,
        ),
        //returns other details as the subtitle. This changes depending on whether the event has a location or not
        subtitle: Text(
          "${event.location == null ? "" : event.location}${event.location != null && event.teacher != null ? " • " : ""}${event.teacher == null ? "" : event.teacher}",
          style: header3Style,
        ),
        //opens the assignments of the course when you click on it
        //TODO: Set up event deletion & viewing
        onTap: () {});
  }
}
