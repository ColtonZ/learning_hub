import 'package:firebase_auth/firebase_auth.dart';

//this is a class for a Google user account
class CustomUser {
  final User firebaseUser;
  final Map<String, dynamic> authHeaders;

  CustomUser({
    this.firebaseUser,
    this.authHeaders,
  });

  //when a user is created, it takes in the GoogleAccount for that user, as well as any authorization headers for making HTTP requests, as well as json representing the user's details.
  //finally, the user's Firestore id (i.e. the id of their firestore document within the users collection) is retrieved, so that it can be used to access their events etc. later  on.
  factory CustomUser.create(
    User firebaseUser,
    Map<String, dynamic> headers,
  ) {
    return CustomUser(
      firebaseUser: firebaseUser,
      authHeaders: headers,
    );
  }
}
