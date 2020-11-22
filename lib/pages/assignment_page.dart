import 'dart:core';

import 'package:sliding_up_panel/sliding_up_panel.dart'; //https://pub.dev/packages/sliding_up_panel
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../theming.dart';

import '../objects/assignment.dart';
import '../objects/attachments_list_view.dart';
import '../objects/student_submissions.dart';
import '../objects/custom_app_bar.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/customUser.dart';

import '../backend/authBackend.dart';
import '../backend/userAccountsBackend.dart';

class AssignmentPage extends StatefulWidget {
  //takes in the widget's arguments
  final GoogleSignInAccount account;
  final String name;
  final String course;
  final Assignment assignment;
  final CustomUser user;

  AssignmentPage(
      {this.account, this.user, this.name, this.course, this.assignment});

  @override
  //initialises the courses page state
  AssignmentPageState createState() => AssignmentPageState();
}

class AssignmentPageState extends State<AssignmentPage> {
  Widget build(BuildContext context) {
    String name = widget.name;
    CustomUser user = widget.user;
    String course = widget.course;
    Assignment assignment = widget.assignment;
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
    //checks if the user is signed in, if not, they are signed in. If they are, load the page
    return user == null
        ? FutureBuilder(
            future: signIn(false),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                user = snapshot.data;
                //once signed in, load the page
                return CustomScaffold.create(
                    context, name, user, course, assignment, months);
              } else {
                //whilst signing in, return a loading indicator
                return Scaffold(
                    appBar: CustomAppBar.create(context, course),
                    body: Center(child: CircularProgressIndicator()),
                    bottomNavigationBar:
                        CustomNavigationBar.create(context, name, user, 1));
              }
            })
        : CustomScaffold.create(
            context, name, user, course, assignment, months);
  }
}

//details the looks of the page
class CustomScaffold {
  static Scaffold create(
    BuildContext context,
    String name,
    CustomUser user,
    String course,
    Assignment assignment,
    List<String> months,
  ) {
    return new Scaffold(

        //returns the custom app bar with the assignments page title
        appBar: CustomAppBar.create(context, course),
        //builds the body
        body: Center(
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
                                  : Icons.warning),
                    ),
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                  Container(
                    width: 15,
                  ),
                  //returns the assignment title
                  Expanded(
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
                height: MediaQuery.of(context).size.height / 52,
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: 15,
                  ),
                  //tries to get the name of the user who created the task, if it cannot, then it just returns the task's creation date
                  Expanded(
                    child: FutureBuilder(
                      future: getGoogleUserName(assignment.creatorId, user),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          try {
                            String name = snapshot.data;
                            //checks if the task was edited after creation
                            return Text(
                              assignment.creationTime
                                      .add(Duration(minutes: 5))
                                      .isBefore(assignment.updateTime)
                                  //returns the task's creator and its due date
                                  ? "$name • ${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]} (Edited ${assignment.updateTime.day.toString()} ${months[assignment.updateTime.month - 1]})"
                                  : "$name • ${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}",
                              style: header3Style,
                            );
                          } catch (error) {
                            return Text(
                              assignment.creationTime
                                      .add(Duration(minutes: 5))
                                      .isBefore(assignment.updateTime)
                                  //returns just the task's due date
                                  ? "${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]} (Edited ${assignment.updateTime.day.toString()} ${months[assignment.updateTime.month - 1]})"
                                  : "${assignment.creationTime.day.toString()} ${months[assignment.creationTime.month - 1]}",
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
                  ),
                  Container(
                    width: 5,
                  ),
                  //checks if the task has a due date. If it does, display it
                  Expanded(
                    child: ListTile(
                      title: Text(
                        assignment.dueDate != null
                            ? "Due ${assignment.dueDate.day} ${months[assignment.dueDate.month - 1]}"
                            : "No due date",
                        textAlign: TextAlign.right,
                        style: header3Style,
                      ),
                    ),
                  ),
                  Container(
                    width: 15,
                  ),
                ],
              ),
              Divider(
                color: Colors.black38,
                thickness: 1,
                indent: 15,
                endIndent: 15,
              ),

              //Returns a list. The first object is is the task's description (if there is one), and the rest of the objects are any attachments that are attached to the task
              Expanded(
                child: Stack(
                  children: [
                    AttachmentsListView.create(
                        context,
                        assignment.description != null
                            ? assignment.description
                            : "This task has no description.",
                        assignment.attachments),
                    //returns a panel which allows the user to slide up and view their attached work
                    //from https://pub.dev/packages/sliding_up_panel
                    SlidingUpPanel(
                      collapsed: Center(
                        child: Column(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height / 50,
                            ),
                            //this container fades out when the panel is slid up, thus hiding the pull up arrow and showing the pull down arrow
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  Icon(Icons.expand_less),
                                  Text(
                                    "Your work",
                                    style: header3Style,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                      minHeight: MediaQuery.of(context).size.height / 10,
                      maxHeight: MediaQuery.of(context).size.height / 2,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(
                              MediaQuery.of(context).size.width / 20),
                          topRight: Radius.circular(
                              MediaQuery.of(context).size.width / 20)),
                      //creates the list of the student's submissions
                      panel: Center(
                        child: StudentSubmissions.create(context, assignment),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ), //builds the navigation bar for the given page
        bottomNavigationBar:
            CustomNavigationBar.create(context, name, user, 1));
  }
}
