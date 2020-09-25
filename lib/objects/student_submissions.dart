import 'package:flutter/material.dart';

import '../theming.dart';
import 'assignment.dart';
import 'attachments_list_view.dart';

class StudentSubmissions {
  //creates a list view of the student's submission
  //checks on the type of the assignment to work out if it should be looking for attached files, or for a question response
  static Widget create(BuildContext context, Assignment assignment) {
    int _value = 0;
    //if it is a multiple choice question, return the "Your work" page as a series of radio buttons to select from for multiple choice
    if (assignment.type == "MULTIPLE_CHOICE_QUESTION") {
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
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                ),
                //https://material.io/develop/flutter/components/radio-buttons
                //creates a series of radio buttons, each with one of the options that you can select as an answer to the multiple choice question
                Column(children: [
                  for (int i = 0; i < assignment.question.options.length; i++)
                    ListTile(
                      title: Text(assignment.question.options[i]),
                      leading: Radio(
                        value: i,
                        groupValue: _value,
                        activeColor: accentColour,
                        onChanged: i == 5 ? null : (int value) {},
                      ),
                    )
                ]),
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
            color: Colors.white,
            child: Column(
              children: [
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                ),
                Form(
                  //https://api.flutter.dev/flutter/widgets/Form-class.html
                  //creates a form field for the user to submit their answer and then hand it in.
                  child: Column(children: [
                    TextFormField(
                      decoration: InputDecoration(hintText: "Type your answer"),
                    ),
                    RaisedButton(
                      onPressed: null,
                      child: Text(
                        "Turn in",
                        style: header3Style,
                      ),
                    )
                  ]),
                )
              ],
            ),
          ),
        ],
      ));
    } else {
      //if the assignment isn't a question, return the panel as a list view of attachments, showing what the student has attached as their submission
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
                Icon(Icons.expand_more),
                Text(
                  "Your work",
                  style: header3Style,
                )
              ],
            ),
          ),
          Expanded(
              //creates the list view of the attachments, with no 'description' (as it should only say **Attachments:**)
              child: AttachmentsListView.create(
                  context, "", assignment.submissionAttachments))
        ],
      ));
    }
  }
}
