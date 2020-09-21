import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../objects/course.dart';
import '../objects/assignment.dart';
import 'authBackend.dart';
import 'helperBackend.dart';

Future<List<Course>> getCourses(GoogleSignInAccount account) async {
  Map<String, String> headers;

//gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//requests a list of the user's courses
  final List<Course> courses = await sendCourseRequest(headers);

  return courses;
}

Future<List<Course>> sendCourseRequest(Map<String, String> headers) async {
  //requests the user's courses with an http request
  http.Response response = await http.get(
      Uri.encodeFull("https://classroom.googleapis.com/v1/courses"),
      headers: headers);

  final responseBody = response.body;

//converts the json response to a list of courses
  return parseCourses(responseBody);
}

List<Course> parseCourses(String responseBody) {
  var data = json.decode(responseBody);
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

Future<List<Assignment>> getAssignments(
    String courseId, GoogleSignInAccount account) async {
  Map<String, String> headers;

  //gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//returns a list of the assignments for a given course
  final List<Assignment> assignments =
      await sendAssignmentsRequest(courseId, headers);

  return assignments;
}

Future<List<Assignment>> sendAssignmentsRequest(
    String courseId, Map<String, String> headers) async {
  //sends an http request for the courses assignments given a course id
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$courseId/courseWork"),
      headers: headers);
  final responseBody = response.body;

  //converts the response into a list of assignments

  var data = json.decode(responseBody);
  //converts the json into a list of jsons
  var assignments = data["courseWork"] as List;
  var assignmentList = <Assignment>[];

  for (int index = 0; index < assignments.length; index++) {
    //converts each json into an assignment and adds it to the assignment list
    //the null is required, as we do not care about user submissions at this point
    Assignment assignment = await sendAssignmentRequest(
        courseId, assignments[index]["id"], headers);
    assignmentList.add(assignment);
  }

  return assignmentList;
}

Future<Assignment> sendAssignmentRequest(
    String courseId, String assignmentId, Map<String, String> headers) async {
  //sends an http request for the assignment, as well as a second for the student's submissions (if any)
  http.Response assignmentResponse = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId"),
      headers: headers);

  http.Response submissionResponse = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$courseId/courseWork/$assignmentId/studentSubmissions"),
      headers: headers);

  final assignmentResponseBody = assignmentResponse.body;
  final submissionResponseBody = submissionResponse.body;

//prints out the responses for testing purposes
  printWrapped(assignmentResponseBody);
  printWrapped(submissionResponseBody);

  //converts the response into an assignment and an attached submission
  return parseAssignment(assignmentResponseBody, submissionResponseBody);
}

Assignment parseAssignment(
    String assignmentResponseBody, String submissionResponseBody) {
  var assignmentData = json.decode(assignmentResponseBody);
  var submissionData = json.decode(submissionResponseBody);

  var submissions = submissionData["studentSubmissions"] as List;

  //converts the two json responses (the assignment details and the submission details) into an assignment object and returns it
  Assignment assignment = Assignment.fromJson(assignmentData, submissions[0]);

  return assignment;
}

Future<bool> isCourseDone(String id, GoogleSignInAccount account) async {
  try {
    List<Assignment> assignments = await getAssignments(id, account);

    bool toDo = false;
//loops through each assignment, getting the student submission for each
    for (int j = 0; j < assignments.length; j++) {
      //check each assignment, and if it has not been submitted or marked, has a due date and is not late, then mark the task as needing to be done);
      if (assignments[j].state != "TURNED_IN" &&
          assignments[j].state != "RETURNED" &&
          assignments[j].dueDate != null &&
          assignments[j].isLate != true) {
        toDo = true;
        break;
      }
    }
    return toDo;
  } on NoSuchMethodError {
    return false;
  }

  //if the course has no assignments, return false (as there are no assignments to be done!)
}
