import 'package:flutter/material.dart';

import '../backend/courseWorkBackend.dart';
import '../theming.dart';
import 'customUser.dart';
import 'course.dart';

class CoursesListView extends StatefulWidget {
  final List<Course> courses;
  final CustomUser user;

  CoursesListView({this.courses, this.user});

  @override
  CoursesListViewState createState() => CoursesListViewState();
}

//details the looks of the courses list
class CoursesListViewState extends State<CoursesListView> {
  Widget build(BuildContext context) {
    List<Course> courses = widget.courses;
    CustomUser user = widget.user;
    return ListView.builder(
      addAutomaticKeepAlives: true,
      itemCount: (courses.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or course details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the course
        return _CustomListRow(user: user, course: courses[index]);
      },
    );
  }
}

class _CustomListRow extends StatefulWidget {
  final Course course;
  final CustomUser user;

  _CustomListRow({this.course, this.user});

  @override
  _CustomListRowState createState() => _CustomListRowState();
}

//builds the list tile for the course
class _CustomListRowState extends State<_CustomListRow> {
  Widget build(BuildContext context) {
    Course course = widget.course;
    CustomUser user = widget.user;
    //checks if list tile should have subtitle
    return ListTile(
        leading: FutureBuilder(
            //sends a future to check if the course has work to be done
            future: isCourseDone(course.id, user),
            builder: (context, snapshot) {
              //once the http request has been sent, show an icon saying if the course has work to be done or not. If an error is returned, return an error icon. Whilst loading, return a loading indicator.
              if (snapshot.connectionState == ConnectionState.done) {
                try {
                  return Icon(snapshot.data["done"]
                      ? Icons.check
                      : Icons.notification_important);
                } catch (error) {
                  return Icon(Icons.error);
                }
              } else {
                return Container(
                  child: CircularProgressIndicator(),
                  width: 25,
                  height: 25,
                );
              }
            }),
        title: Text(
          //returns the tile header as the subject
          course.name, style: subtitleStyle,
        ),
        //returns other details as the subtitle
        subtitle: Text(
          course.description,
          style: header3Style,
        ),
        //opens the assignments of the course when you click on it
        onTap: () {
          _pushAssignmentsPage(context, user, course.name, course.id);
        });
  }

//defines that when you tap on the list tile, it will push the assignments page for that course
//the objects being passed are put into a Map to be passed between pages
  static void _pushAssignmentsPage(
      BuildContext context, CustomUser user, String course, String id) {
    Map args = {"user": user, "id": id, "course": course};
    Navigator.of(context).pushNamed('/assignments', arguments: args);
  }
}
