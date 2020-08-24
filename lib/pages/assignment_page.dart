import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import '../objects/custom_app_bar.dart';
import 'package:learning_hub/backend.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../objects/custom_navigation_bar.dart';
import 'dart:core';
import '../objects/google_user.dart';

class AssignmentPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final String course;
  final String courseId;
  final String assignmentId;

  AssignmentPage(
      {this.account, this.name, this.course, this.courseId, this.assignmentId});

  @override
  //initialises the courses page state
  AssignmentPageState createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    GoogleSignInAccount account = widget.account;
    String courseId = widget.courseId;
    String course = widget.course;
    String assignmentId = widget.assignmentId;
    //checks if the user is signed in, if not, they are signed in
    return account == null
        ? FutureBuilder(
            future: signIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                account = snapshot.data;
                return CustomScaffold.create(
                    context, name, account, course, courseId, assignmentId);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, course),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, account, 2));
              }
            })
        : CustomScaffold.create(
            context, name, account, course, courseId, assignmentId);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(
    BuildContext context,
    String name,
    GoogleSignInAccount account,
    String course,
    String courseId,
    String assignmentId,
  ) {
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar.create(context, course),
        //builds the body
        body: FutureBuilder(
            future: getAssignment(courseId, assignmentId, account),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                Assignment assignment = snapshot.data;
                //checks if the assignment is valid. If it is, return the assignment page, otherwise return an error message
                try {
                  List<String> months = [
                    "Jan",
                    "Feb",
                    "Mar",
                    "Apr",
                    "May",
                    "Jun",
                    "Jul",
                    "Aug",
                    "Sep",
                    "Oct",
                    "Nov",
                    "Dec"
                  ];
                  return Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: MediaQuery.of(context).size.height / 100,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 15,
                            ),
                            Container(
                              child: FittedBox(
                                fit: BoxFit.contain,
                                child: Icon(assignment.type == "ASSIGNMENT"
                                    ? Icons.assignment
                                    : assignment.type == "SHORT_ANSWER_QUESTION"
                                        ? Icons.short_text
                                        : assignment.type ==
                                                "MULTIPLE_CHOICE_QUESTION"
                                            ? Icons.check_circle_outline
                                            : Icons.warning),
                              ),
                              width: MediaQuery.of(context).size.width / 10,
                            ),
                            Container(
                              width: 15,
                            ),
                            Expanded(
                              child: Text(
                                "${assignment.title}",
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Container(
                              width: 15,
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 50,
                        ),
                        Row(
                          children: <Widget>[
                            Container(
                              width: 15,
                            ),
                            Expanded(
                              child: FutureBuilder(
                                future: getGoogleUser(
                                    assignment.creatorId, account),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    try {
                                      GoogleUser creator = snapshot.data;
                                      return Text(assignment.creationTime
                                              .add(Duration(minutes: 5))
                                              .isBefore(assignment.updateTime)
                                          ? "${creator.name} • ${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]} (Edited ${assignment.updateTime.day.toString()} ${months[assignment.updateTime.month - 1]})"
                                          : "${creator.name} • ${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}");
                                    } catch (error) {
                                      return Text(assignment.creationTime
                                              .add(Duration(minutes: 5))
                                              .isBefore(assignment.updateTime)
                                          ? "${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]} (Edited ${assignment.updateTime.day.toString()} ${months[assignment.updateTime.month - 1]})"
                                          : "${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}");
                                    }
                                  } else {
                                    return Text("Loading...");
                                  }
                                },
                              ),
                            ),
                            Container(
                              width: 5,
                            ),
                            Text(
                              assignment.dueDate != null
                                  ? "Due ${assignment.dueDate.day} ${months[assignment.dueDate.month - 1]}"
                                  : "No due date",
                              textAlign: TextAlign.right,
                            ),
                            Container(
                              width: 15,
                            ),
                          ],
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 50,
                        ),
                        Divider(
                          color: Colors.black38,
                          thickness: 1,
                          indent: 15,
                          endIndent: 15,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 50,
                        ),
                        Container(
                          child: Text(
                            "${assignment.description != null ? assignment.description : "This task has no description."}",
                          ),
                          width: MediaQuery.of(context).size.width - 30,
                        ),
                      ],
                    ),
                  );
                } catch (error) {
                  return Center(
                    child: Text("An error occured. Please try again."),
                  );
                }
              } else {
                //whilst getting courses, return a loading indicator
                return Center(child: CircularProgressIndicator());
              }
            }),
        //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, account, 2));
  }
}
