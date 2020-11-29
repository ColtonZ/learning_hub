import 'package:flutter/material.dart';

import '../theming.dart';
import 'assignment.dart';
import 'customUser.dart';

class AssignmentsListView {
  //creates a list view
  static ListView create(
      BuildContext context, CustomUser user, List<Assignment> assignments) {
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
        return _buildCustomListRow(context, user, assignments[index]);
      },
    );
  }

//builds the list tile for the assignment
  static Widget _buildCustomListRow(
    BuildContext context,
    CustomUser user,
    Assignment assignment,
  ) {
    return ListTile(
        //if the assignment has a title, return it. Otherwise, set the assignment title to "N/A"
        title: Text(
          assignment.title != null ? assignment.title : "N/A",
          style: subtitleStyle,
        ),
        //trims the tile's subtitle accordingly, and adds a name depending on the type of the assignment
        subtitle: Text(
          //checks if the description is null. If it is, return "this task has no description". Otherwise, return the first line of the description, and if it's too long, cut it after 40 characters and add "..."
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
              //add the type of the assignment to the row below the description:"Assignment", "Short Answer Question" or "Multiple Choice Question"
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
        //if the assignment has been turned in or returned, set the icon to say that it has been done. Otherwise, set the icon to an exclamation mark to show it needs doing.
        leading: (assignment.state != "TURNED_IN" &&
                assignment.state != "RETURNED" &&
                assignment.dueDate != null)
            ? Icon(Icons.notification_important)
            : Icon(Icons.check),
        onTap: () {
          _pushAssignmentPage(context, user, assignment);
        });
  }

//defines that when you tap on the list tile, it will push the assignment page for that assignment.#
//the objects being passed are put into a Map to be passed between pages
  static void _pushAssignmentPage(
    BuildContext context,
    CustomUser user,
    Assignment assignment,
  ) {
    Map args = {
      "user": user,
      "assignment": assignment,
    };
    Navigator.of(context).pushNamed('/assignment', arguments: args);
  }
}
