import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/attachments_list_view.dart';
import 'package:learning_hub/theming.dart';

class StudentSubmissions {
  //creates a list view of the student's submission
  //checks on the type of the assignment to work out if it should be looking for attached files, or for a question response
  static Widget create(BuildContext context, Assignment assignment) {
    if (assignment.type == "MULTIPLE_CHOICE_QUESTION") {
      return Center(
          child: Column(
        children: [
          Text(
            "Multiple Choice!",
            style: titleStyle,
          )
        ],
      ));
    } else if (assignment.type == "SHORT_ANSWER_QUESTION") {
      return Center(
          child: Column(
        children: [
          Text(
            "Short Answer!",
            style: titleStyle,
          )
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
            color: Colors.white,
            child: Column(
              children: [
                Icon(Icons.keyboard_arrow_down_outlined),
                Text(
                  "Your work",
                  style: header3Style,
                )
              ],
            ),
          ),
          Expanded(
              child: AttachmentsListView.create(
                  context, "", assignment.submissionAttachments))
        ],
      ));
    }
  }
}
