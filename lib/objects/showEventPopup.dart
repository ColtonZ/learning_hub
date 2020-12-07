import 'package:flutter/material.dart';
import 'package:learning_hub/constants.dart';
import 'package:learning_hub/objects/customUser.dart';
import 'package:learning_hub/theming.dart';
import '../backend/firestoreBackend.dart';
import '../objects/event.dart';

class ShowEvent extends StatefulWidget {
  final CustomUser user;
  final String id;

  @override
  ShowEvent({this.user, this.id});

  ShowEventState createState() => ShowEventState();
}

class ShowEventState extends State<ShowEvent> {
  bool showConfirm = false;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String id = widget.id;
    //returns the details of the course
    return AlertDialog(
      content: FutureBuilder(
          future: getEvent(user.firebaseUser, id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              Event event = snapshot.data;
              return (SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Text(
                      "${event.name}",
                      style: subtitleStyle,
                    ),
                    Container(
                      height: 5,
                    ),
                    Text(
                      "${event.location == null ? "" : event.location}${event.location != null && event.teacher != null ? " • " : ""}${event.teacher == null ? "" : event.teacher}",
                      style: header3Style,
                    ),
                    Container(
                      height: 5,
                    ),
                    Divider(),
                    Text(
                      "Timings",
                      style: Theme.of(context).textTheme.caption,
                      textScaleFactor: 1.5,
                    ),
                    Divider(),
                    for (int i = 0; i < event.times.length; i++)
                      ListTile(
                        title: Text(
                            "${days[int.parse(event.times[i][0])]} • ${event.times[i][3] == "AB" ? "A & B" : event.times[i][3]}"),
                        subtitle: Text(
                            "${event.times[i][1].substring(0, 2)}:${event.times[i][1].substring(2)} - ${event.times[i][2].substring(0, 2)}:${event.times[i][2].substring(2)}"),
                      ),
                    event.platform == "LH" && showConfirm
                        ? Column(children: [
                            Text(
                              "Are you sure you wish to delete this event?\nThis action cannot be undone.",
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.red, fontSize: 12),
                            ),
                            Divider(),
                          ])
                        : Container(),
                    event.platform == "LH"
                        ? showConfirm
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    FlatButton(
                                        child: Text("Delete"),
                                        color: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          await deleteEvent(
                                              user.firebaseUser, id);
                                          Navigator.of(context).pop();
                                        }),
                                    FlatButton(
                                        child: Text("Cancel"),
                                        color: Theme.of(context).accentColor,
                                        onPressed: () {
                                          setState(() {
                                            showConfirm = false;
                                          });
                                        }),
                                  ])
                            : RaisedButton(
                                child: Text("Delete Event"),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  setState(() {
                                    showConfirm = true;
                                  });
                                })
                        : Container(),
                  ],
                ),
              ));
            } else {
              return (Text("Loading..."));
            }
          }),
    );
  }
}
