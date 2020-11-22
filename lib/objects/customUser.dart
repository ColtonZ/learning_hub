import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

//this is a class for a Google user account
class CustomUser {
  final GoogleSignInAccount googleAccount;
  final Map<String, String> authHeaders;
  final String name;
  final String googleId;
  final String email;
  final String googlePhotoUrl;
  final GoogleAuthCredential credential;

  CustomUser(
      {this.googleAccount,
      this.authHeaders,
      this.name,
      this.googleId,
      this.email,
      this.googlePhotoUrl,
      this.credential});

  //when a user is created, it takes in the GoogleAccount for that user, as well as any authorization headers for making HTTP requests, as well as json representing the user's details.
  //finally, the user's Firestore id (i.e. the id of their firestore document within the users collection) is retrieved, so that it can be used to access their events etc. later  on.
  factory CustomUser.create(
      GoogleSignInAccount account,
      Map<String, dynamic> headers,
      Map<String, dynamic> json,
      GoogleAuthCredential credential) {
    return CustomUser(
        googleAccount: account,
        authHeaders: headers,
        name: account.displayName,
        email: account.email,
        googleId: account.id,
        googlePhotoUrl: account.photoUrl,
        credential: credential);
  }
}
