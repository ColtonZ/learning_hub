import 'package:google_sign_in/google_sign_in.dart';

//this is a class for a Google user account
class User {
  final GoogleSignInAccount googleAccount;
  final String name;
  final String googleId;
  final String googleEmail;
  final String googlePhotoUrl;

  User(
      {this.googleAccount,
      this.name,
      this.googleId,
      this.googleEmail,
      this.googlePhotoUrl});

  factory User.create(GoogleSignInAccount account, Map<String, dynamic> json) {
    return User(
        //the only thing returned currently is the user's name
        googleAccount: account,
        name: account.displayName,
        googleEmail: account.email,
        googleId: account.id,
        googlePhotoUrl: account.photoUrl);
  }
}