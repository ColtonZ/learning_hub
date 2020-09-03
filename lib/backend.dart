import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import 'objects/course.dart';
import 'objects/assignment.dart';
import 'objects/google_user.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<GoogleSignInAccount> signIn() async {
  //signs user in, requesting required scopes from the google account
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
      "https://www.googleapis.com/auth/classroom.announcements",
      "https://www.googleapis.com/auth/classroom.courses",
      "https://www.googleapis.com/auth/classroom.coursework.me",
      "https://www.googleapis.com/auth/classroom.coursework.students",
      "https://www.googleapis.com/auth/classroom.profile.emails",
      "https://www.googleapis.com/auth/classroom.profile.photos",
      "https://www.googleapis.com/auth/classroom.push-notifications",
      "https://www.googleapis.com/auth/classroom.rosters",
      "https://www.googleapis.com/auth/classroom.student-submissions.me.readonly",
      "https://www.googleapis.com/auth/classroom.student-submissions.students.readonly",
      "https://www.googleapis.com/auth/classroom.topics",
    ],
  );

  try {
    _googleSignIn.signOut();
  } catch (error) {}

  //signs the user in
  final GoogleSignInAccount account = await _googleSignIn.signIn();

  return account;
}

//full scopes list: https://developers.google.com/identity/protocols/oauth2/scopes

bool isSignedIn(GoogleSignInAccount account) {
  //checks if a user is signed in with google
  if (account != null) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, String>> getHeaders(GoogleSignInAccount account) async {
  //maps a user's auth headers to a map for use later
  final Map<String, String> headers = await account.authHeaders;

  return headers;
}

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
    String id, GoogleSignInAccount account) async {
  Map<String, String> headers;

  //gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//returns a list of the assignments for a given course
  final List<Assignment> assignments =
      await sendAssignmentsRequest(id, headers);

  return assignments;
}

Future<List<Assignment>> sendAssignmentsRequest(
    String id, Map<String, String> headers) async {
  //sends an http request for the courses assignments given a course id
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$id/courseWork"),
      headers: headers);
  final responseBody = response.body;

  //converts the response into a list of assignments
  return parseAssignments(responseBody);
}

List<Assignment> parseAssignments(String responseBody) {
  var data = json.decode(responseBody);
  //converts the json into a list of jsons
  var assignments = data["courseWork"] as List;
  var assignmentList = <Assignment>[];

  assignments.forEach((details) {
    //converts each json into an assignment and adds it to the assignment list
    //the null is required, as we do not care about user submissions at this point
    Assignment assignment = Assignment.fromJson(details, null);
    assignmentList.add(assignment);
  });

  return assignmentList;
}

Future<Assignment> getAssignment(
    String courseId, String assignmentId, GoogleSignInAccount account) async {
  Map<String, String> headers;

  //gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//returns the specific assignment requested
  final Assignment assignment =
      await sendAssignmentRequest(courseId, assignmentId, headers);

  return assignment;
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

Future<GoogleUser> getGoogleUser(
    String userId, GoogleSignInAccount account) async {
  Map<String, String> headers;

  //gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//returns the user profile of the given user
  final GoogleUser user = await sendGoogleUserRequest(userId, headers);

  return user;
}

Future<GoogleUser> sendGoogleUserRequest(
    userId, Map<String, String> headers) async {
  //sends an http request for the user, given their ID
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/$userId"),
      headers: headers);

  final responseBody = response.body;

  //converts the response into a user profile
  return parseGoogleUser(responseBody);
}

GoogleUser parseGoogleUser(String responseBody) {
  var data = json.decode(responseBody);
  //converts the json into a user and returns the user

  GoogleUser user = GoogleUser.fromJson(data);

  return user;
}

void printWrapped(String text) {
  //prints out text if over 800 characters long by splitting into 800 character chunks (this is the default limit for the terminal)
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
