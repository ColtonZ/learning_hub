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
