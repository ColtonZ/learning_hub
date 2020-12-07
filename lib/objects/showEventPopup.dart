import 'package:flutter/material.dart';
import 'package:learning_hub/objects/customUser.dart';

class ShowEvent extends StatefulWidget {
  final CustomUser user;
  final String id;

  @override
  ShowEvent({this.user, this.id});

  ShowEventState createState() => ShowEventState();
}

class ShowEventState extends State<ShowEvent> {
  List<bool> days = [false, false, false, false, false, false, false];

  String title;
  String location;
  String teacher;
  String start = "0900";
  String end = "0940";

  bool boxValueA = false;
  bool boxValueB = false;
  bool daysFilled = true;
  bool weeksFilled = true;
  bool timesValid = true;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    String id = widget.id;
    //returns the details of the course
    return AlertDialog(
      content: Container(),
    );
  }
}
