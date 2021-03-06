import 'dart:core';

import 'package:sliding_up_panel/sliding_up_panel.dart'; //https://pub.dev/packages/sliding_up_panel
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';
import '../constants.dart';

import '../objects/assignment.dart';
import '../objects/attachments_list_view.dart';
import '../objects/student_submissions.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';
import '../objects/offlineScaffold.dart';

import '../backend/authBackend.dart';
import '../backend/userAccountsBackend.dart';

class AssignmentPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final Assignment assignment;
  final CustomUser user;

  AssignmentPage({this.account, this.user, this.name, this.assignment});

  @override
  //initialises the assignment page state
  AssignmentPageState createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    Assignment assignment = widget.assignment;
    //checks if the user is signed in, if not, they are signed in. If they are, load the page
    return user == null
        ? FutureBuilder(
            future: signIn(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page, although if the user is offline, show the offline page
                if (user != null) {
                  return _CustomScaffold(
                      name: name, user: user, assignment: assignment);
                } else {
                  return OfflineScaffold();
                }
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar:
                        CustomAppBar(title: "Account Details", reload: false),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar(name: name, user: user, index: 1));
              }
            })
        : _CustomScaffold(name: name, user: user, assignment: assignment);
  }
}

class _CustomScaffold extends StatefulWidget {
  final String name;
  final CustomUser user;
  final Assignment assignment;

  _CustomScaffold({this.name, this.user, this.assignment});

  @override
  _CustomScaffoldState createState() => _CustomScaffoldState();
}

//details the look of the page
class _CustomScaffoldState extends State<_CustomScaffold> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    Assignment assignment = widget.assignment;
    return new Scaffold(
        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar(title: assignment.courseName, reload: false),
        //builds the body
        body: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  //returns an icon depending on the assignment type
                  Container(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Icon(assignment.type == "ASSIGNMENT"
                          ? Icons.assignment
                          : assignment.type == "SHORT_ANSWER_QUESTION"
                              ? Icons.short_text
                              : assignment.type == "MULTIPLE_CHOICE_QUESTION"
                                  ? Icons.check_circle_outline
                                  : assignment.type == "PERSONAL"
                                      ? Icons.person_outline
                                      : Icons.warning),
                    ),
                    width: 50,
                  ),
                  Container(
                    width: 15,
                  ),
                  //returns the assignment title
                  Flexible(
                    fit: FlexFit.loose,
                    child: Text(
                      "${assignment.title}",
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                ],
              ),
              Container(
                height: 15,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      width: 15,
                    ),
                    //tries to get the name of the user who created the task, if it cannot, then it just returns the task's creation date
                    FutureBuilder(
                      future: getGoogleUserName(assignment.creatorId, user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.data != null) {
                            String name = snapshot.data;
                            //checks if the task was edited after creation
                            return Text(
                              "$name • ${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}",
                              style: header3Style,
                            );
                          } else {
                            return Text(
                              "${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}",
                              style: header3Style,
                            );
                          }
                          //returns "loading..." whilst trying to get the task's creator
                        } else {
                          return Text(
                            "Loading...",
                            style: header3Style,
                          );
                        }
                      },
                    ),
                    Container(
                      width: 5,
                    ),
                    Text("|"),
                    Container(
                      width: 5,
                    ),
                    //checks if the task has a due date. If it does, display it
                    Text(
                      assignment.dueDate != null
                          ? "Due ${assignment.dueDate.day} ${months[assignment.dueDate.month - 1]}"
                          : "No due date",
                      textAlign: TextAlign.right,
                      style: header3Style,
                    ),

                    Container(
                      width: 15,
                    ),
                  ],
                ),
              ),
              Divider(
                color: Colors.black38,
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),
              //Returns a list. The first object is is the task's description (if there is one), and the rest of the objects are any attachments that are attached to the task
              Flexible(
                fit: FlexFit.loose,
                child: Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 75),
                      child: AttachmentsListView(
                          description: assignment.description != null
                              ? assignment.description
                              : "This task has no description.",
                          attachments: assignment.attachments),
                    ),
                    //returns a panel which allows the user to slide up and view their attached work
                    //from https://pub.dev/packages/sliding_up_panel
                    SlidingUpPanel(
                      collapsed: Center(
                        child: Column(
                          children: [
                            Container(
                              height: 15,
                            ),
                            //this container fades out when the panel is slid up, thus hiding the pull up arrow and showing the pull down arrow
                            Container(
                              color: Theme.of(context).backgroundColor,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.expand_less),
                                  Text(
                                    "Your work",
                                    style: header3Style,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      backdropTapClosesPanel: true,
                      minHeight: 75,
                      //dependent on the type of assignment and any files the student has uploaded, the size of the sliding up panel changes.
                      maxHeight: assignment.type == "PERSONAL"
                          ? 170
                          : assignment.type == "SHORT_ANSWER_QUESTION"
                              ? 250
                              : assignment.type == "MULTIPLE_CHOICE_QUESTION"
                                  ? 300
                                  : assignment.submissionAttachments.length == 0
                                      ? 250
                                      : 500,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      //creates the list of the student's submissions
                      panel: Center(
                        child: StudentSubmissions(
                          user: user,
                          assignment: assignment,
                        ),
                      ),
                      color: Theme.of(context).backgroundColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar(name: name, user: user, index: 1));
  }
}
