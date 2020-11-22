import 'dart:async';
import 'dart:convert';

import '../objects/customUser.dart';

import '../backend/firestoreBackend.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';

final GoogleSignIn googleSignIn = GoogleSignIn();

//checks if a user is already signed in. If they are, then the current user is signed out before the next one is signed in.
Future<CustomUser> signIn() async {
  if (await googleSignIn.isSignedIn()) {
    googleSignIn.signOut();
  }

  // Sign the user in with Google, requesting their data from Google Classroom
  final GoogleSignInAccount googleUser = await GoogleSignIn(scopes: [
    "profile",
    "email",
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
  ]).signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Sign the user into Firebase, passing in the tokens from the Google sign in method
  final GoogleAuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

//fetches the Google User's auth headers for requests later
  final Map<String, String> googleAuthHeaders = await googleUser.authHeaders;

  //https://firebase.flutter.dev/docs/auth/social#google
  //https://firebase.google.com/docs/auth/android/google-signin
  //https://www.youtube.com/watch?v=cHFV6JPp-6A
  //https://medium.com/codechai/flutter-auth-with-google-f3c3aa0d0ccc

  //sends an http request for the user's details, given their ID
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/${googleUser.id}"),
      headers: googleAuthHeaders);

  var details = json.decode(response.body);

  checkFirestoreUser(credential, googleUser.email);

  return CustomUser.create(googleUser, googleAuthHeaders, details, credential);
}

//full scopes list: https://developers.google.com/identity/protocols/oauth2/scopes

bool isSignedIn(CustomUser user) {
  //checks if a user is signed in with google
  if (user != null && user.googleAccount != null) {
    return true;
  } else {
    return false;
  }
}
