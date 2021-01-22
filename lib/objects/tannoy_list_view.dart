import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

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
        //returns a divider if odd, or tannoy details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the tannoy notice
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

//builds the list tile for the tannoy notice
class _CustomListRowState extends State<_CustomListRow> {
  Widget build(BuildContext context) {
    Notice notice = widget.notice;
    return ListTile(
      isThreeLine: true,
      //return the notice's title
      title: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "${notice.title}",
          style: subtitleStyle,
        ),
      ]),
      //show the notice's body
      subtitle: Linkify(
        text: notice.body,
        onOpen: (link) => launch(link.url),
        style: header3Style,
        //textAlign: TextAlign.justify,
      ),
    );
  }
}
