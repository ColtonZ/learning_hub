import 'package:flutter/material.dart';
import 'package:learning_hub/backend/firestoreBackend.dart';
import 'package:learning_hub/objects/customUser.dart';

class AddEvent extends StatefulWidget {
  final CustomUser user;

  @override
  AddEvent({this.user});

  AddEventState createState() => AddEventState();
}

class AddEventState extends State<AddEvent> {
  final _formKey = GlobalKey<FormState>();
  List<bool> days = [false, false, false, false, false, false, false];

//initialise the details of the event.
  String title;
  String location;
  String teacher;
  String start = "0900";
  String end = "0940";

//these are used for validation of the user input later.
  bool boxValueA = false;
  bool boxValueB = false;
  bool daysFilled = true;
  bool weeksFilled = true;
  bool timesValid = true;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    //returns the add event popup
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  //the text input box for the event's name
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Event Name',
                    ),
                    validator: (value) {
                      //ensures that a title is entered and that it is not too long
                      if (value.isEmpty) {
                        return 'Please enter the event\'s name';
                      }
                      if (value.length > 30) {
                        return "Please ensure the event's name is under 30 characters in length.";
                      }
                      setState(() {
                        title = value;
                      });
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: Row(
                    children: [
                      Expanded(
                        //the text input box (optional) for the event's teacher
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Teacher',
                          ),
                          validator: (value) {
                            //ensures that if a value is given, its not too long
                            if (value.length > 30) {
                              return "Please ensure the teacher's name is under 30 characters in length.";
                            }
                            setState(() {
                              teacher = value;
                            });
                            return null;
                          },
                        ),
                      ),
                      Container(
                        width: 25,
                      ),
                      Expanded(
                        //the input box for the (optional) event location details
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Location',
                          ),
                          validator: (value) {
                            //ensures that, if a location is given, it's not too long
                            if (value.length > 30) {
                              return "Please ensure the post's location is under 30 characters in length.";
                            }
                            setState(() {
                              location = value;
                            });
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(),
                Text(
                  "Days",
                  style: Theme.of(context).textTheme.caption,
                  textScaleFactor: 1.5,
                ),
                Container(
                  height: 5,
                ),
                Text(
                  "Scroll horizontally to view all days",
                  style: Theme.of(context).textTheme.caption,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: FormField(
                    builder: (_) {
                      //creates a horizontally scrolling list of checkboxes, one for each day.
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            //for each checkbox, it has the initial of the day above it. If it is selected, the list of selected days initialised at the beginning of the popup is modified to reflect the addition of the selected day.
                            Column(children: [
                              Text("M"),
                              Checkbox(
                                  value: days[0],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[0] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("T"),
                              Checkbox(
                                  value: days[1],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[1] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("W"),
                              Checkbox(
                                  value: days[2],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[2] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("T"),
                              Checkbox(
                                  value: days[3],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[3] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("F"),
                              Checkbox(
                                  value: days[4],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[4] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("S"),
                              Checkbox(
                                  value: days[5],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[5] = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("S"),
                              Checkbox(
                                  value: days[6],
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      days[6] = newValue;
                                    });
                                  }),
                            ]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //if no days have been selected, an error message is returned.
                Text(
                  "${!daysFilled ? "You must select at least one day for this event." : ""}",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Divider(),
                Text(
                  "Repeats",
                  style: Theme.of(context).textTheme.caption,
                  textScaleFactor: 1.5,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: FormField(
                    builder: (_) {
                      //creates two checkboxes, allowing for the event to repeat on week As or Bs. When selected, the respective variable for that week is updated.
                      return Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(children: [
                              Text("Week A"),
                              Checkbox(
                                  value: boxValueA,
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      boxValueA = newValue;
                                    });
                                  }),
                            ]),
                            Column(children: [
                              Text("Week B"),
                              Checkbox(
                                  value: boxValueB,
                                  activeColor: Theme.of(context).accentColor,
                                  onChanged: (bool newValue) {
                                    setState(() {
                                      boxValueB = newValue;
                                    });
                                  }),
                            ]),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                //returns an error if no week has been selected.
                Text(
                  "${!weeksFilled ? "You must select at least one week for this event." : ""}",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Divider(),
                Text(
                  "Time",
                  style: Theme.of(context).textTheme.caption,
                  textScaleFactor: 1.5,
                ),
                Container(
                  height: 5,
                ),
                Text(
                  "Tap on a time to modify it",
                  style: Theme.of(context).textTheme.caption,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      //creates two flat buttons, one for the event's start time and one for the event's end time.
                      //when one of these buttons is tapped, the corresponding time is changed, and the text on the button is updated to reflect that.
                      FlatButton(
                        child: Text(
                            "${start.substring(0, 2)}:${start.substring(2)}"),
                        onPressed: () async {
                          TimeOfDay selected = await showTimePicker(
                            context: context,
                            initialTime: (TimeOfDay(
                                hour: int.parse(start.substring(0, 2)),
                                minute: int.parse(start.substring(2)))),
                          );
                          if (selected != null)
                            setState(() {
                              start =
                                  "${selected.hour.toString().padLeft(2, "0")}${selected.minute.toString().padLeft(2, "0")}";
                            });
                        },
                      ),
                      FlatButton(
                        child:
                            Text("${end.substring(0, 2)}:${end.substring(2)}"),
                        onPressed: () async {
                          TimeOfDay selected = await showTimePicker(
                            context: context,
                            initialTime: (TimeOfDay(
                                hour: int.parse(end.substring(0, 2)),
                                minute: int.parse(end.substring(2)))),
                          );
                          if (selected != null)
                            setState(() {
                              end =
                                  "${selected.hour.toString().padLeft(2, "0")}${selected.minute.toString().padLeft(2, "0")}";
                            });
                        },
                      ),
                    ],
                  ),
                ),
                //if the event ends before it starts, an error is returned
                Text(
                  "${!timesValid ? "Your event must end after it starts." : ""}",
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //a raised button allowing for the event to be added. It ensures that the requirements for a valid event are fulfilled, and then it is added to the db.
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      // this ensures that the event timings and repeats are valid
                      if (_formKey.currentState.validate() &&
                          days.contains(true) &&
                          (boxValueA || boxValueB) &&
                          int.parse(start) < int.parse(end)) {
                        daysFilled = true;
                        await addCustomEvent(user.firebaseUser, title, teacher,
                            location, days, boxValueA, boxValueB, start, end);
                        Navigator.of(context).pop();
                      }
                      //if no day has been selected return that error
                      if (!days.contains(true)) {
                        setState(() {
                          daysFilled = false;
                        });
                      } else {
                        setState(() {
                          daysFilled = true;
                        });
                      }
                      //if neither week A or B have been selected, return that error
                      if (!boxValueA && !boxValueB) {
                        setState(() {
                          weeksFilled = false;
                        });
                      } else {
                        setState(() {
                          weeksFilled = true;
                        });
                      }
                      //if the event ends before (or at the same time as) it starts, return that error
                      if (int.parse(end) <= int.parse(start)) {
                        setState(() {
                          timesValid = false;
                        });
                      } else {
                        setState(() {
                          timesValid = true;
                        });
                      }
                    },
                    child: Text('Add Event'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
