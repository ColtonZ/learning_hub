import 'package:flutter/material.dart';

import '../theming.dart';
import 'notice.dart';

class TannoysListView extends StatefulWidget {
  final List<Notice> notices;

  TannoysListView({this.notices});

  @override
  TannoysListViewState createState() => TannoysListViewState();
}

//details the looks of the page
class TannoysListViewState extends State<TannoysListView> {
  Widget build(BuildContext context) {
    List<Notice> notices = widget.notices;
    return ListView.builder(
      itemCount: (notices.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or assignment details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the assignment
        return _CustomListRow(
          notice: notices[index],
        );
      },
    );
  }
}

class _CustomListRow extends StatefulWidget {
  final Notice notice;

  _CustomListRow({this.notice});

  @override
  _CustomListRowState createState() => _CustomListRowState();
}

//TODO: Set up tannoy page
//builds the list tile for the course
class _CustomListRowState extends State<_CustomListRow> {
  Widget build(BuildContext context) {
    Notice notice = widget.notice;
    return ListTile(
      //if the assignment has a title, return it. Otherwise, set the assignment title to "N/A"
      title: Text(
        notice.title,
        style: subtitleStyle,
      ),
      //trims the tile's subtitle accordingly, and adds a name depending on the type of the assignment
      subtitle: Text(
        //checks if the description is null. If it is, return "this task has no description". Otherwise, return the first line of the description, and if it's too long, cut it after 40 characters and add "..."
        notice.body,
        style: header3Style,
      ),
    );
    //applies an icon to the tile, dependent on the type of assignment
    //if the assignment has been turned in or returned, set the icon to say that it has been done. Otherwise, set the icon to an exclamation mark to show it needs doing.
  }
}
