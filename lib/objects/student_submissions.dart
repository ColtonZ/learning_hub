import 'package:flutter/material.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/attachments_list_view.dart';
import 'package:learning_hub/theming.dart';

class StudentSubmissions {
  //creates a list view of the student's submission
  //checks on the type of the assignment to work out if it should be looking for attached files, or for a question response
  static Widget create(BuildContext context, Assignment assignment) {
    int _value = 0;
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
      //if the assignment isn't a question, return the panel as a list view of attachments
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
              child: AttachmentsListView.create(
                  context, "", assignment.submissionAttachments))
        ],
      ));
    }
  }
}
