import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'objects/course.dart';
import 'objects/assignment.dart';

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
  //signs the user in
  final GoogleSignInAccount account = await _googleSignIn.signIn();

  return account;
}

//full scopes list: https://developers.google.com/identity/protocols/oauth2/scopes

bool isSignedIn(GoogleSignInAccount account) {
  if (account != null) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, String>> getHeaders(GoogleSignInAccount account) async {
  final Map<String, String> headers = await account.authHeaders;

  return headers;
}

Future<List<List<String>>> getCourses(GoogleSignInAccount account) async {
  Map<String, String> headers;

  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

  final List<Course> courses = await sendCourseRequest(headers);

  List<String> title;
  List<String> subtitle;
  List<List<String>> combined;

  courses.forEach((element) {
    title.add(element.name);
    subtitle.add(element.description);
  });

  combined.add(title);
  combined.add(subtitle);
  return combined;
}

Future<List<Course>> sendCourseRequest(Map<String, String> headers) async {
  http.Response response = await http.get(
      Uri.encodeFull("https://classroom.googleapis.com/v1/courses"),
      headers: headers);

  final responseBody = response.body;

  return compute(parseCourses, responseBody);
}

List<Course> parseCourses(String responseBody) {
  print(responseBody);
  var data = json.decode(responseBody);
  var courses = data["courses"] as List;
  var courseList = <Course>[];

  courses.forEach((details) {
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
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }
  final List<Assignment> assignments = await sendAssignmentRequest(id, headers);
  return assignments;
}

Future<List<Assignment>> sendAssignmentRequest(
    String id, Map<String, String> headers) async {
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com//v1/courses/$id/courseWork"),
      headers: headers);

  final responseBody = response.body;
  printWrapped(responseBody);
  return compute(parseAssignments, responseBody);
}

List<Assignment> parseAssignments(String responseBody) {
  var data = json.decode(responseBody);
  var assignments = data["courseWork"] as List;
  var assignmentList = <Assignment>[];

  assignments.forEach((details) {
    Assignment assignment = Assignment.fromJson(details);
    assignmentList.add(assignment);
    assignment.output();
  });

  return assignmentList;
}

Future<GoogleSignInAccount> signOut() async {
  googleSignIn.signOut();
  return null;
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
