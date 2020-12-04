import 'package:flutter/material.dart';

import '../theming.dart';
import 'assignment.dart';
import 'attachments_list_view.dart';
import 'customUser.dart';
import '../backend/courseWorkBackend.dart';
import 'package:url_launcher/url_launcher.dart';

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
    //if it is a multiple choice question, retur"Your work" page as a series of radio buttons to select from for multiple choice
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
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                ),
                Divider(),
                Text(
                  "It is not currently possible to submit multiple choice questions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Divider(),
                //https://material.io/develop/flutter/components/radio-buttons
                //creates a series of radio buttons, each with one of the options that you can select as an answer to the multiple choice question
                Container(
                  height: 275,
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

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 25, 0, 0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
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
      //if it is a short answer question, return "Your work", and then a text box to enter your response
    } else if (assignment.type == "SHORT_ANSWER_QUESTION") {
      return Center(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 50,
          ),
          Container(
            child: Column(
              children: [
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                ),
                Divider(),
                Text(
                  "It is not currently possible to submit short answer questions.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
                Divider(),
                Row(
                  children: [
                    Text(assignment.answer != null
                        ? "Your response: ${assignment.answer}"
                        : "You have not submitted this task."),
                  ],
                )
              ],
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
            height: MediaQuery.of(context).size.height / 50,
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
          Divider(),
          Text(
            "It is not currently possible to submit assignments.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.red, fontSize: 12),
          ),
          Divider(),
          Expanded(
              //creates the list view of the attachments, with no 'description' (as it should only say **Attachments:**)
              child: AttachmentsListView(
                  description: "",
                  attachments: assignment.submissionAttachments)),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 25, 0, 25),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text("View in Classroom"),
              onPressed: () {
                launch(assignment.url);
              },
            ),
          ),
        ],
      ));
    } else {
      return Center(
          child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 50,
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
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              child: Text("Mark task as done"),
              onPressed: () {
                setState(() {
                  markAsDone(user, assignment).then((refreshedAssignment) {
                    assignment = refreshedAssignment;
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
