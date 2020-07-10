import 'dart:async';

import 'package:google_sign_in/google_sign_in.dart';

Future<GoogleSignInAccount> signIn() async {
  //signs user in, requesting required scopes from the google account
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'profile',
      'email',
      "https://www.googleapis.com/auth/classroom.courses",
      "https://www.googleapis.com/auth/classroom.courses.readonly",
      "https://www.googleapis.com/auth/classroom.courses",
      "https://www.googleapis.com/auth/classroom.announcements",
      "https://www.googleapis.com/auth/classroom.coursework.me.readonly"
    ],
  );
  //signs the user in
  final GoogleSignInAccount account = await _googleSignIn.signIn();

  return account;
}
