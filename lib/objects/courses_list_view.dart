import 'package:flutter/material.dart';
import 'course.dart';
import 'package:google_sign_in/google_sign_in.dart';

class CoursesListView {
  //creates a list view
  static ListView create(
      BuildContext context, GoogleSignInAccount account, List<Course> courses) {
    return ListView.builder(
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
        return _buildCustomListRow(context, account, courses[index]);
      },
    );
  }

  //builds the list tile for the course
  static Widget _buildCustomListRow(
      BuildContext context, GoogleSignInAccount account, Course course) {
    //checks if list tile should have subtitle
    return course.description != "null"
        ? ListTile(
            title: Text(
                //returns the tile header as the subject
                course.name),
            //returns other details as the subtitle
            subtitle: Text(course.description),
            onTap: () {
              _pushAssignmentsPage(context, account, course.name, course.id);
            })
        : ListTile(
            title: Text(
                //returns the tile header as the subject
                course.name),
            onTap: () {
              _pushAssignmentsPage(context, account, course.name, course.id);
            });
  }

//defines that when you tap on the list tile, it will push the assignments page for that course
  static void _pushAssignmentsPage(BuildContext context,
      GoogleSignInAccount account, String course, String id) {
    Map args = {"account": account, "id": id, "course": course};
    Navigator.of(context).pushNamed('/assignments', arguments: args);
  }
}
