import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../objects/course.dart';
import '../objects/assignment.dart';
import '../objects/user.dart';

Future<List<Course>> getCourses(User user) async {
  //gets the user's auth headers - if they aren't signed in, they are signed in before trying to fetch headers
  Map<String, String> headers = user.authHeaders;

  //requests the user's courses with an http request
  http.Response response = await http.get(
      Uri.encodeFull("https://classroom.googleapis.com/v1/courses"),
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

Future<List<Assignment>> getAssignments(String courseId, User user) async {
  //gets the user's auth headers - if they aren't signed in, they are signed in before trying to fetch headers
  Map<String, String> headers = user.authHeaders;

  //requests the user's courses with an http request
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/courses/$courseId/courseWork"),
      headers: headers);

  //converts the response into JSON
  var data = json.decode(response.body);

  //converts the json into a list of jsons
  var assignments = data["courseWork"] as List;
  var assignmentList = <Assignment>[];

  for (int index = 0; index < assignments.length; index++) {
    //for each assignment in the list of courseWork, the method will request the full assignment for the given id.
    //with the id, the method then gets all student submissions for that given assignment, so that it can check if all the work has been submitted
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
  //printWrapped(assignmentResponseBody);
  //printWrapped(submissionResponseBody);

  //converts the responses into JSON
  var assignmentData = json.decode(assignmentResponseBody);
  var submissionData = json.decode(submissionResponseBody);

  var submissions = submissionData["studentSubmissions"] as List;

  //converts the two json responses (the assignment details and the submission details) into an assignment object and returns it
  Assignment assignment = Assignment.fromJson(assignmentData, submissions[0]);

  return assignment;
}

Future<bool> isCourseDone(String id, User user) async {
  bool toDo = false;

  //TODO: Make this faster so it doesn't load the entire course first!
  try {
    //gets the user's auth headers - if they aren't signed in, they are signed in before trying to fetch headers
    Map<String, String> headers = user.authHeaders;

    //requests the course assignments with an http request
    http.Response response = await http.get(
        Uri.encodeFull(
            "https://classroom.googleapis.com/v1/courses/$id/courseWork"),
        headers: headers);

    var data = json.decode(response.body);

    var assignments = data["courseWork"] as List;

    for (int index = 0; index < assignments.length; index++) {
      //for each assignment in the list of courseWork, the method will request the full assignment for the given id.
      //with the id, the method then gets all student submissions for that given assignment, so that it can check if all the work has been submitted

      http.Response submissionResponse = await http.get(
          Uri.encodeFull(
              "https://classroom.googleapis.com//v1/courses/$id/courseWork/${assignments[index]["id"]}/studentSubmissions"),
          headers: headers);

      var submissionData = json.decode(submissionResponse.body);

      var submissions = submissionData["studentSubmissions"] as List;

      http.Response assignmentResponse = await http.get(
          Uri.encodeFull(
              "https://classroom.googleapis.com//v1/courses/$id/courseWork/${assignments[index]["id"]}"),
          headers: headers);

      var assignmentData = json.decode(assignmentResponse.body);

      //check each assignment, and if it has not been submitted or marked, has a due date and is not late, then mark the task as needing to be done);
      if (submissions[0]["state"] != "TURNED_IN" &&
          submissions[0]["state"] != "RETURNED" &&
          assignmentData["dueDate"] != null &&
          submissions[0]["late"] != "true") {
        toDo = true;
        break;
      }
    }
  } catch (error) {
    //if this error is called, it means that the course has no assignments. If this is the case, there are no assignments to be done, so return false.
  }
  return toDo;
}
