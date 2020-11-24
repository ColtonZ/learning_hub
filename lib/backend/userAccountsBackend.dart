import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../objects/customUser.dart';

Future<String> getGoogleUserName(String userId, CustomUser user) async {
  //sends an http request for the user, given their ID

  Map<String, String> headers = user.authHeaders;

  http.Response response = await http.get(
      Uri.encodeFull(
          "https://classroom.googleapis.com/v1/userProfiles/$userId"),
      headers: headers);

  var data = json.decode(response.body);
  //converts the json into a user and returns the user

  return data["name"]["fullName"];
}
