import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../objects/user.dart';

Future<User> getGoogleUser(userId, User user) async {
  //sends an http request for the user, given their ID

  Map<String, String> headers = user.authHeaders;

  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/$userId"),
      headers: headers);

  var data = json.decode(response.body);
  //converts the json into a user and returns the user

  return User.create(null, null, data, null);
}
