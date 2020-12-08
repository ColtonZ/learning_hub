import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../objects/course.dart';
import '../objects/assignment.dart';
import '../objects/customUser.dart';

import 'firestoreBackend.dart';

Future<List<Course>> getCourses(CustomUser user) async {
  //gets the user's auth headers
  Map<String, String> headers = user.authHeaders;

  //requests the user's courses with an http request
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/courses?fields=courses(id,name,descriptionHeading,courseState)"),
      headers: headers);

  //converts the response into JSON
  var data = json.decode(response.body);

  //decodes the json into a list of jsons
  var courses = data["courses"] as List;
  var courseList = <Course>[];

  courses.forEach((details) {
    //parses each json request into a course, and, if they are an active course, adds them to the course list
    Course course = Course.fromJson(details);
    if (course.status == "ACTIVE") {
      courseList.add(course);
    }
  });

  return courseList;
}

Future<List<dynamic>> sendAssignmentsRequest(
    String courseId, CustomUser user) async {
  //gets the user's auth headers
  Map<String, String> headers = user.authHeaders;

  //requests the user's courses with an http request
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/courses/$courseId/courseWork?fields=courseWork(id)"),
      headers: headers);

  //converts the response into JSON
  var data = json.decode(response.body);

  //converts the json into a list of jsons
  return data["courseWork"] as List;
}

Future<List<Assignment>> getAssignments(List<dynamic> assignments,
    String courseId, String courseName, CustomUser user) async {
  //gets the user's auth headers
  Map<String, String> headers = user.authHeaders;

  var assignmentList = <Assignment>[];

  for (int index = 0; index < assignments.length; index++) {
    //for each assignment in the list of courseWork, the method will request the full assignment for the given id.
    //with the id, the method then gets all student submissions for that given assignment, so that it can check if all the work has been submitted
    Assignment assignment = await sendAssignmentRequest(
        courseId, courseName, assignments[index]["id"], headers);
    assignmentList.add(assignment);
  }

  return assignmentList;
}

Future<Assignment> sendAssignmentRequest(String courseId, String courseName,
    String assignmentId, Map<String, String> headers) async {
  //sends an http request for the assignment, as well as a second for the student's submissions (if any)

//get the assignment details
//TODO:FIELDS
  http.Response assignmentResponse = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId"),
      headers: headers);

//get the student's submission details
  http.Response submissionResponse = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId/studentSubmissions?fields=studentSubmissions(assignmentSubmission,assignedGrade,late,state,id,shortAnswerSubmission,multipleChoiceSubmission)"),
      headers: headers);

//parse the details
  final assignmentResponseBody = assignmentResponse.body;
  final submissionResponseBody = submissionResponse.body;

  //converts the responses into JSON
  var assignmentData = json.decode(assignmentResponseBody);
  var submissionData = json.decode(submissionResponseBody);

//create a list of the student submissions (there shoudl be one item - the student's submission)
  var submissions = submissionData["studentSubmissions"] as List;

  //converts the two json responses (the assignment details and the submission details) into an assignment object and returns it
  Assignment assignment =
      Assignment.fromJson(courseName, "GC", assignmentData, submissions[0]);

  return assignment;
}

Future<Map<String, dynamic>> isCourseDone(String id, CustomUser user) async {
  Map<String, dynamic> returnMap = {"done": true, "assignments": null};

  try {
    //gets the user's auth headers
    Map<String, String> headers = user.authHeaders;

    //requests the course assignments with an http request
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://classroom.googleapis.com/v1/courses/$id/courseWork?fields=courseWork(dueDate)"),
        headers: headers);

//converts the courseWork details into JSON
    var data = json.decode(response.body);

//creates a list of the course's tasks
    var assignments = data["courseWork"] as List;

    returnMap.update("assignments", (value) => assignments);

//checks the number of tasks in a course. If there are more than 5 tasks, only the first 5 are checked for incompleteness (to speed up the process)
    int length = assignments.length < 5 ? assignments.length : 5;

    for (int index = 0; index < length; index++) {
      //for each assignment in the list of courseWork, the method will request the full assignment for the given id.
      //with the id, the method then gets all student submissions for that given assignment, so that it can check if all the work has been submitted
      if (assignments[index]["dueDate"] != null) {
//get the assignment's details
        http.Response submissionResponse = await http.get(
            Uri.encodeFull(
                "https://classroom.googleapis.com//v1/courses/$id/courseWork/${assignments[index]["id"]}/studentSubmissions?fields=state"),
            headers: headers);

//decode the assignment details
        var submissionData = json.decode(submissionResponse.body);

        var submissions = submissionData["studentSubmissions"] as List;

//check each assignment, and if it has not been submitted or marked, and is not late, then check its due date. If it has a due date, mark the task as needing to be done);
        if (submissions[0]["state"] != "TURNED_IN" &&
            submissions[0]["state"] != "RETURNED") {
          //if the task is not done, return false, and break to save time.
          returnMap.update("done", (value) => false);
          break;
        }
      }
    }
  } catch (error) {
    //if this error is called, it means that the course has no assignments. If this is the case, there are no assignments to be done, so return false.
  }
  return returnMap;
}

Future<List<Assignment>> tasksToDo(CustomUser user, bool reload) async {
//see if the user's incomplete assignments were last checked recently
  bool checked = await checkedRecently(user.firebaseUser, reload);

//if the tasks were checked recently, get the tasks from the Firestore database. Otherwise, fetch the tasks from Classroom.
  if (!checked) {
    //get a list of the user's courses
    List<Course> allCourses = await getCourses(user);
    //first remove the Classroom tasks from Firestore (as they will be out of date)
    removeClassroomTasks(user.firebaseUser);

    //loop through each of the user's courses
    for (Course course in allCourses) {
      try {
        //if the course is not done, get the assignments for that course
        Map<String, dynamic> response = await isCourseDone(course.id, user);
        if (!response["done"]) {
          //create a list of assignments for that course
          List<Assignment> courseAssignments = await getAssignments(
              response["assignments"], course.id, course.name, user);
          //loop through the course's tasks
          int length = courseAssignments.length;
          for (int i = 0; i < length; i++) {
            Assignment assignment = courseAssignments[i];
            //if the tasks is not done, add it to the list of tasks to do, and add it to the Firestore database
            if (assignment.state != "TURNED_IN" &&
                assignment.state != "RETURNED" &&
                assignment.dueDate != null) {
              firestoreToDoAdd(user.firebaseUser, assignment);
            }
          }
        }
      } catch (e) {}
    }
  }
  return await getFirestoreTasks(user.firebaseUser);
}

Future<String> markAsDone(CustomUser user, Assignment assignment) async {
  //get the matching task from the db
  QuerySnapshot assignments = await databaseReference
      .collection("users")
      .doc(user.firebaseUser.uid)
      .collection("toDo")
      .where("id", isEqualTo: assignment.id)
      .where("courseName", isEqualTo: assignment.courseName)
      .where("platform", isEqualTo: assignment.platform)
      .where("title", isEqualTo: assignment.title)
      .where("creationTime", isEqualTo: assignment.creationTime)
      .get();

//delete the assignment
  databaseReference
      .collection("users")
      .doc(user.firebaseUser.uid)
      .collection("toDo")
      .doc(assignments.docs.first.id)
      .delete();

  return "done";
}
