import 'package:google_sign_in/google_sign_in.dart';

//this is a class for a Google user account
class User {
  final GoogleSignInAccount googleAccount;
  final Map<String, String> authHeaders;
  final String name;
  final String googleId;
  final String email;
  final String googlePhotoUrl;
  final String firestoreId;

  User(
      {this.googleAccount,
      this.authHeaders,
      this.name,
      this.googleId,
      this.email,
      this.googlePhotoUrl,
      this.firestoreId});

  //when a user is created, it takes in the GoogleAccount for that user, as well as any authorization headers for making HTTP requests, as well as json representing the user's details.
  //finally, the user's Firestore id (i.e. the id of their firestore document within the users collection) is retrieved, so that it can be used to access their events etc. later  on.
  factory User.create(GoogleSignInAccount account, Map<String, dynamic> headers,
      Map<String, dynamic> json, String firestoreId) {
    return User(
        googleAccount: account,
        authHeaders: headers,
        name: account.displayName,
        email: account.email,
        googleId: account.id,
        googlePhotoUrl: account.photoUrl,
        firestoreId: firestoreId);
  }
}
