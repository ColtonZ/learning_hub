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
  //initialises confirmation, to ensure that a user does not delete an event accidentaly
  bool showConfirm = false;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String id = widget.id;
    //returns the event popup
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
                    //shows the event's name
                    Text(
                      "${event.name}",
                      style: subtitleStyle,
                    ),
                    Container(
                      height: 5,
                    ),
                    //shows the event's location and teacher, if either exist
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
                      style: captionStyle,
                      textScaleFactor: 1.5,
                    ),
                    Divider(),
                    //creates a list of the event's timings. Each tile in the list consists of the day the event occurs, followed by any weeks it repeats. Below that is the timings of the event on that day and week.
                    for (int i = 0; i < event.times.length; i++)
                      ListTile(
                        title: Text(
                            "${days[int.parse(event.times[i][0])]} • ${event.times[i][3] == "AB" ? "A & B" : event.times[i][3]}"),
                        subtitle: Text(
                            "${event.times[i][1].substring(0, 2)}:${event.times[i][1].substring(2)} - ${event.times[i][2].substring(0, 2)}:${event.times[i][2].substring(2)}"),
                      ),
                    //if the event was added by the user and they have requested to delete the event, a button is shown allowing for event deletion
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
                    //if the event was added by the user
                    event.platform == "LH"
                        ? showConfirm
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    //if the user has confirmed they want to delete the event and the event was added from Learning Hub, show a button allowing for the event to be deleted.
                                    FlatButton(
                                        child: Text("Delete"),
                                        color: Theme.of(context).accentColor,
                                        onPressed: () async {
                                          await deleteEvent(
                                              user.firebaseUser, id);
                                          Navigator.of(context).pop();
                                        }),
                                    //allow the user to cancel the deletion of the data
                                    FlatButton(
                                        child: Text("Cancel"),
                                        color: Theme.of(context).accentColor,
                                        onPressed: () {
                                          setState(() {
                                            showConfirm = false;
                                          });
                                        }),
                                  ])
                            //create the first delete event button
                            : RaisedButton(
                                child: Text("Delete Event"),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  setState(() {
                                    //show the confirmation dialogue when button pressed
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
