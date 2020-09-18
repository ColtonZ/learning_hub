import 'dart:async';
import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

import '../objects/google_user.dart';
import 'authBackend.dart';

Future<GoogleUser> getGoogleUser(
    String userId, GoogleSignInAccount account) async {
  Map<String, String> headers;

  //gets the user's auth headers
  if (isSignedIn(account)) {
    headers = await getHeaders(account);
  } else {
    headers = await getHeaders(await signIn());
  }

//returns the user profile of the given user
  final GoogleUser user = await sendGoogleUserRequest(userId, headers);

  return user;
}

Future<GoogleUser> sendGoogleUserRequest(
    userId, Map<String, String> headers) async {
  //sends an http request for the user, given their ID
  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/$userId"),
      headers: headers);

  final responseBody = response.body;

  //converts the response into a user profile
  return parseGoogleUser(responseBody);
}

GoogleUser parseGoogleUser(String responseBody) {
  var data = json.decode(responseBody);
  //converts the json into a user and returns the user

  GoogleUser user = GoogleUser.fromJson(data);

  return user;
}
