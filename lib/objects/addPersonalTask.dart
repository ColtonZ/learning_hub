import 'package:flutter/material.dart';
import 'package:learning_hub/backend/firestoreBackend.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/customUser.dart';
import 'package:learning_hub/constants.dart';

class AddPersonalTask extends StatefulWidget {
  final CustomUser user;

  @override
  AddPersonalTask({this.user});

  AddPersonalTaskState createState() => AddPersonalTaskState();
}

class AddPersonalTaskState extends State<AddPersonalTask> {
  final _formKey = GlobalKey<FormState>();

  String title;
  String description;
  String subject;
  DateTime dueDate = DateTime.now().add(Duration(days: 1));

  bool dueDateSet = true;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    //returns the details of the course
    return AlertDialog(
      content: Form(
        key: _formKey,
        child: Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Assignment Title',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter the assignment\'s title';
                      }
                      if (value.length > 30) {
                        return "Please ensure the assignment's title is under 30 characters in length.";
                      }
                      setState(() {
                        title = value;
                      });
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                    ),
                    validator: (value) {
                      if (value.length > 30) {
                        return "Please ensure the assignment's subject is under 30 characters in length.";
                      }
                      setState(() {
                        subject = value;
                      });
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Description',
                    ),
                    validator: (value) {
                      setState(() {
                        description = value;
                      });
                      return null;
                    },
                    maxLines: null,
                  ),
                ),
                Divider(),
                Text(
                  "Due Date",
                  style: Theme.of(context).textTheme.caption,
                  textScaleFactor: 1.5,
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: FlatButton(
                    child: Text(
                        "${days[dueDate.weekday - 1]} ${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}"),
                    onPressed: () async {
                      DateTime selected = await showDatePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(Duration(days: 365)),
                          initialDate: dueDate);
                      if (selected != null)
                        setState(() {
                          dueDate = selected;
                        });
                    },
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width - 10,
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    onPressed: () async {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      if (_formKey.currentState.validate()) {
                        Assignment assignment = new Assignment.createCustom(
                            title, description, subject, dueDate);
                        await firestoreToDoAdd(user.firebaseUser, assignment);
                        Navigator.of(context).pop();
                      }
                    },
                    child: Text('Add Personal Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
