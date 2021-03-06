import 'package:flutter/material.dart';

import '../theming.dart';
import 'assignment.dart';
import 'attachments_list_view.dart';
import 'customUser.dart';
import '../backend/courseWorkBackend.dart';
import 'package:url_launcher/url_launcher.dart';
import '../backend/firestoreBackend.dart';

class StudentSubmissions extends StatefulWidget {
  final Assignment assignment;
  final CustomUser user;

  StudentSubmissions({this.assignment, this.user});

  @override
  StudentSubmissionsState createState() => StudentSubmissionsState();
}

//details the looks of the page
class StudentSubmissionsState extends State<StudentSubmissions> {
  String answer;
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    Assignment assignment = widget.assignment;
    //if it is a multiple choice question, return "Your work" page as a series of radio buttons to select from for multiple choice
    if (assignment.type == "MULTIPLE_CHOICE_QUESTION") {
      answer = answer ?? assignment.question.options[0];
      return Center(
          child: Column(
        children: [
          Container(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 125),
                    Column(children: [
                      Icon(Icons.expand_more),
                      Text(
                        "Your work",
                        style: header3Style,
                      ),
                    ]),
                    Container(
                      width: 125,
                      alignment: Alignment.centerRight,
                      child: Text(
                        assignment.state == "RETURNED"
                            ? assignment.grade != null
                                ? "Grade: ${assignment.grade}/${assignment.points}"
                                : "Returned"
                            : assignment.state == "TURNED_IN"
                                ? "Turned In${assignment.isLate != null ? " Late" : ""}"
                                : assignment.isLate != null
                                    ? "Late"
                                    : "Assigned",
                        style: assignment.isLate == null
                            ? header3Style
                            : TextStyle(
                                fontFamily: header3Style.fontFamily,
                                fontWeight: header3Style.fontWeight,
                                fontSize: header3Style.fontSize,
                                color: Colors.red),
                      ),
                    ),
                  ],
                ),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Divider(),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Text(
                    "It is not currently possible to submit multiple choice questions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                Divider(),
                //https://material.io/develop/flutter/components/radio-buttons
                //creates a series of radio buttons, each with one of the options that you can select as an answer to the multiple choice question
                Container(
                  height: 100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        for (int i = 0;
                            i < assignment.question.options.length;
                            i++)
                          ListTile(
                            title: Text(assignment.question.options[i]),
                            leading: Radio(
                              value: assignment.question.options[i],
                              groupValue: answer,
                              activeColor: Theme.of(context).accentColor,
                              onChanged: (selected) {
                                setState(() {
                                  answer = selected;
                                });
                              },
                            ),
                          )
                      ],
                    ),
                  ),
                ),
//allow the user to view the task in Google Classroom
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Theme.of(context)
                                                        .accentColor)),
                    child: Text("View in Classroom"),
                    onPressed: () {
                      launch(assignment.url);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ));
      //if it is a short answer question, return "Your work", and then details about the user's response
    } else if (assignment.type == "SHORT_ANSWER_QUESTION") {
      return Center(
          child: Column(
        children: [
          Container(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 125),
                    Column(children: [
                      Icon(Icons.expand_more),
                      Text(
                        "Your work",
                        style: header3Style,
                      ),
                    ]),
                    Container(
                      width: 125,
                      alignment: Alignment.centerRight,
                      child: Text(
                        assignment.state == "RETURNED"
                            ? assignment.grade != null
                                ? "Grade: ${assignment.grade}/${assignment.points}"
                                : "Returned"
                            : assignment.state == "TURNED_IN"
                                ? "Turned In${assignment.isLate != null ? " Late" : ""}"
                                : assignment.isLate != null
                                    ? "Late"
                                    : "Assigned",
                        style: assignment.isLate == null
                            ? header3Style
                            : TextStyle(
                                fontFamily: header3Style.fontFamily,
                                fontWeight: header3Style.fontWeight,
                                fontSize: header3Style.fontSize,
                                color: Colors.red),
                      ),
                    ),
                  ],
                ),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Divider(),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Container(height: 15),
                Divider(),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Text(
                    "It is not currently possible to submit short answer questions.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Divider(),
                //show the user's response
                if (assignment.answer != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Text(
                      "Your Response:",
                      style: captionStyle,
                      textScaleFactor: 1.5,
                    ),
                  ),
                if (assignment.answer != null)
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                    child: Text(
                      assignment.answer ?? "",
                      textScaleFactor: 1.5,
                    ),
                  ),
              ],
            ),
          ),
//allow the user to view the task in Classroom
          Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: ElevatedButton(
              style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Theme.of(context)
                                                        .accentColor)),
              child: Text("View in Classroom"),
              onPressed: () {
                launch(assignment.url);
              },
            ),
          ),
        ],
      ));
    } else if (assignment.type == "ASSIGNMENT") {
      //if the assignment isn't a question, return the panel as a list view of attachments, showing what the student has attached as their submission
      return Center(
          child: Column(
        children: [
          Container(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 125),
                    Column(children: [
                      Icon(Icons.expand_more),
                      Text(
                        "Your work",
                        style: header3Style,
                      ),
                    ]),
                    Container(
                      width: 125,
                      alignment: Alignment.centerRight,
                      child: Text(
                        assignment.state == "RETURNED"
                            ? assignment.grade != null
                                ? "Grade: ${assignment.grade}/${assignment.points}"
                                : "Returned"
                            : assignment.state == "TURNED_IN"
                                ? "Turned In${assignment.isLate != null ? " Late" : ""}"
                                : assignment.isLate != null
                                    ? "Late"
                                    : "Assigned",
                        style: assignment.isLate == null
                            ? header3Style
                            : TextStyle(
                                fontFamily: header3Style.fontFamily,
                                fontWeight: header3Style.fontWeight,
                                fontSize: header3Style.fontSize,
                                color: Colors.red),
                      ),
                    ),
                  ],
                ),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Divider(),
                if (assignment.state != "TURNED_IN" &&
                    assignment.state != "RETURNED")
                  Container(height: 25),
              ],
            ),
          ),
          if (assignment.state != "TURNED_IN" && assignment.state != "RETURNED")
            Divider(),
          if (assignment.state != "TURNED_IN" && assignment.state != "RETURNED")
            Text(
              "It is not currently possible to submit assignments.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          Divider(),
          assignment.submissionAttachments.length != 0
              ? Flexible(
                  fit: FlexFit.loose,
                  //creates the list view of the attachments, with no 'description' (as it should only say **Attachments:**)
                  child: AttachmentsListView(
                      description: "",
                      attachments: assignment.submissionAttachments))
              : Container(),
          //allow the user to view the task in classroom
          Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: ElevatedButton(
              style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Theme.of(context)
                                                        .accentColor)),
              child: Text("View in Classroom"),
              onPressed: () {
                launch(assignment.url);
              },
            ),
          ),
        ],
      ));
    } else {
      //if the task is a personal task, just allow the user to mark it as done
      return Center(
          child: Column(
        children: [
          Container(
            height: 15,
          ),
          Container(
            child: Column(
              children: [
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                ),
                Container(height: 25),
              ],
            ),
          ),
          //allow the user to mark the personal task as done
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: ElevatedButton(
              style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    Theme.of(context)
                                                        .accentColor)),
              child: Text("Mark task as done"),
              onPressed: () {
                setState(() {
                  //delete the task from the database when marked as done
                  markAsDone(databaseReference, user.firebaseUser, assignment)
                      .then((_) {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacementNamed("/timetable",
                        arguments: {"user": user});
                  });
                });
              },
            ),
          ),
        ],
      ));
    }
  }
}
