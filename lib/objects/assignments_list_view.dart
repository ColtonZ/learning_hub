import 'package:flutter/material.dart';
import 'assignment.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AssignmentsListView {
  //creates a list view
  static ListView create(BuildContext context, GoogleSignInAccount account,
      List<Assignment> assignments) {
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
        return _buildCustomListRow(account, assignments[index]);
      },
    );
  }
}

//builds the list tile for the assignment
Widget _buildCustomListRow(GoogleSignInAccount account, Assignment assignment) {
  //checks if list tile should have subtitle
  return ListTile(
      title: Text(
        assignment.title != null ? assignment.title : "N/A",
      ),
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
                        ? assignment.description.substring(0, 40).trim() + "..."
                        : assignment.description.trim()
                : "This task has no description") +
            "\nType: ${assignment.type == "ASSIGNMENT" ? "Assignment" : assignment.type == "SHORT_ANSWER_QUESTION" ? "Short Answer Question" : assignment.type == "MULTIPLE_CHOICE_QUESTION" ? "Multiple Choice Question" : assignment.type}",
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
      leading: null,
      onTap: () {});
}
