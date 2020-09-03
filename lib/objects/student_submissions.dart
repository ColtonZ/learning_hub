import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'attachment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:learning_hub/theming.dart';

class StudentSubmissions {
  //creates a list view
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
          Text(
            "Assignment!",
            style: titleStyle,
          )
        ],
      ));
    }
  }
}
