import 'dart:async';
import 'dart:convert';

import '../objects/user.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

final GoogleSignIn googleSignIn = GoogleSignIn();

Future<User> signIn() async {
  //signs user in, requesting required scopes from the google account
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
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

//signs the user out if they're signed in, so as to allow for them to be re-signed in
  try {
    _googleSignIn.signOut();
  } catch (error) {}

  //signs the user in
  final GoogleSignInAccount account = await _googleSignIn.signIn();

  final Map<String, String> headers = await account.authHeaders;

  //sends an http request for the user's details, given their ID
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/${account.id}"),
      headers: headers);

  var details = json.decode(response.body);

  return User.create(account, details);
}

//full scopes list: https://developers.google.com/identity/protocols/oauth2/scopes

bool isSignedIn(User user) {
  //checks if a user is signed in with google
  if (user != null && user.googleAccount != null) {
    return true;
  } else {
    return false;
  }
}

Future<Map<String, String>> getHeaders(GoogleSignInAccount account) async {
  //returns a user's auth headers as a map for use later
  final Map<String, String> headers = await account.authHeaders;

  return headers;
}
