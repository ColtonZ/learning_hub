import 'dart:async';

import '../objects/customUser.dart';

import '../backend/firestoreBackend.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

final authReference = FirebaseAuth.instance;
final googleSignIn = GoogleSignIn();

//checks if a user is already signed in. If they are, then the current user is signed out before the next one is signed in.
Future<CustomUser> signIn(bool toSignOut) async {
  //initialzes an instance of the Firestore database and gets the signin state
  await Firebase.initializeApp();

//if the user needs to be signed out first, sign them out
  if (toSignOut) {
    await googleSignIn.signOut();
  }

  //Sign the user in with Google, requesting their data from Google Classroom
  //If the user taps off, an error would be thrown, and the sign in tries again.
  GoogleSignInAccount googleUser;

  //try to sign the user in. If it doesn't work, try again for a maximum of 2 times.
  try {
    googleUser = await GoogleSignIn(scopes: [
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
  } catch (e) {}

//fetches the Google User's auth headers for requests later
  final GoogleSignInAuthentication googleAuthentication =
      await googleUser.authentication;

  final Map<String, dynamic> googleAuthHeaders = await googleUser.authHeaders;

//fetches the Firebase user object, using the credentials above
  final AuthCredential authCredential = GoogleAuthProvider.credential(
      accessToken: googleAuthentication.accessToken,
      idToken: googleAuthentication.idToken);

//gets the user's Firebase credentials and then gets that Firebase user
  final UserCredential firebaseCredentials =
      await authReference.signInWithCredential(authCredential);

  final User firebaseUser = firebaseCredentials.user;

  //https://firebase.flutter.dev/docs/auth/social#google
  //https://firebase.google.com/docs/auth/android/google-signin
  //https://www.youtube.com/watch?v=cHFV6JPp-6A
  //https://medium.com/codechai/flutter-auth-with-google-f3c3aa0d0ccc
  //https://blog.codemagic.io/firebase-authentication-google-sign-in-using-flutter/

//checks that the user has a Firestore document
  checkFirestoreUser(firebaseUser);

  return CustomUser.create(firebaseUser, googleAuthHeaders);
}

//full scopes list: https://developers.google.com/identity/protocols/oauth2/scopes
