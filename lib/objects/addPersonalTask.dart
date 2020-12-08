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

//initialises variables for the task
  String title;
  String description;
  String subject;
  DateTime dueDate = DateTime.now().add(Duration(days: 1));

  bool dueDateSet = true;
  @override
  Widget build(BuildContext context) {
    CustomUser user = widget.user;
    //returns the popup to add a personal task
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
                  //creates the input box for the task's title
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Assignment Title',
                    ),
                    validator: (value) {
//ensures that a title is entered & that it is not too long
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
                  //creates an (optional) input box for the task's subject
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Subject',
                    ),
                    validator: (value) {
                      //ensures that if a subject has been entered, it's not too long
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
                  //creates an optional input box for the task's description
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
                    //this means that the input box scales with the size of the description
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
                  //creates a button that the user can press to select the task's due date
                  child: FlatButton(
                    child: Text(
                        "${days[dueDate.weekday - 1]} ${dueDate.day} ${months[dueDate.month - 1]} ${dueDate.year}"),
                    onPressed: () async {
                      //when the button is pressed, show a date picker
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
                      // if a title has been given, add the task to the firestore db, and close the popup
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
