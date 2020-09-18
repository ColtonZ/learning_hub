import 'package:flutter/material.dart';
import 'package:learning_hub/theming.dart';
import 'assignment.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AssignmentsListView {
  //creates a list view
  static ListView create(BuildContext context, GoogleSignInAccount account,
      String course, String id, List<Assignment> assignments) {
    return ListView.builder(
      itemCount: (assignments.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or assignment details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the assignment
        return _buildCustomListRow(
            context, account, course, id, assignments[index]);
      },
    );
  }

//builds the list tile for the assignment
  static Widget _buildCustomListRow(
      BuildContext context,
      GoogleSignInAccount account,
      String course,
      String id,
      Assignment assignment) {
    //checks if list tile should have subtitle
    //print(
    //    "Title: ${assignment.title}, State: ${assignment.state}, DueDate: ${assignment.dueDate}, isLate: ${assignment.isLate}");
    return ListTile(
        title: Text(
          assignment.title != null ? assignment.title : "N/A",
          style: subtitleStyle,
        ),
        //trims the tile's subtitle accordingly, and adds a name depending on the type of the assignment
        subtitle: Text(
          (assignment.description != null
                  ? assignment.description.split("\n").length > 1
                      ? assignment.description.split("\n")[0].length > 40
                          ? assignment.description
                                  .split("\n")[0]
                                  .substring(0, 40)
                                  .trim() +
                              "..."
                          : assignment.description.split("\n")[0].trim() + "..."
                      : assignment.description.length > 40
                          ? assignment.description.substring(0, 40).trim() +
                              "..."
                          : assignment.description.trim()
                  : "This task has no description") +
              "\nType: ${assignment.type == "ASSIGNMENT" ? "Assignment" : assignment.type == "SHORT_ANSWER_QUESTION" ? "Short Answer Question" : assignment.type == "MULTIPLE_CHOICE_QUESTION" ? "Multiple Choice Question" : assignment.type}",
          style: header3Style,
        ),
        //applies an icon to the tile, dependent on the type of assignment
        trailing: Icon(assignment.type == "ASSIGNMENT"
            ? Icons.assignment
            : assignment.type == "SHORT_ANSWER_QUESTION"
                ? Icons.short_text
                : assignment.type == "MULTIPLE_CHOICE_QUESTION"
                    ? Icons.check_circle_outline
                    : Icons.warning),
        isThreeLine: true,
        //TODO: checks if the task needs doing (i.e. if it has not been turned in or returned, is due in the future and is not late)
        //TODO: seems it can't get the task's state - that needs doing!
        //TODO: rewrite getAssignments to include getting the student submissions
        leading: (assignment.state != "TURNED_IN" &&
                assignment.state != "RETURNED" &&
                assignment.dueDate != null &&
                assignment.isLate != true)
            ? Icon(Icons.notification_important)
            : Icon(Icons.check),
        onTap: () {
          _pushAssignmentPage(context, account, course, assignment);
        });
  }

//defines that when you tap on the list tile, it will push the assignment page for that assignment
  static void _pushAssignmentPage(
    BuildContext context,
    GoogleSignInAccount account,
    String course,
    Assignment assignment,
  ) {
    Map args = {
      "account": account,
      "assignment ": assignment,
      "course": course,
    };
    Navigator.of(context).pushNamed('/assignment', arguments: args);
  }
}
