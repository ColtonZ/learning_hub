import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_firestore_mocks/cloud_firestore_mocks.dart";
import "package:learning_hub/backend/firestoreBackend.dart";
import 'package:learning_hub/backend/helperBackend.dart';
import 'mock_classes.dart';
import "package:test/test.dart";
import 'dart:io';

/*
//resets the firestore instance
  final databaseReference = MockFirestoreInstance();
  //sets up a basic firestore user
  await databaseReference.collection("users").doc("1").set({
    "email": "testemail@email.com",
    "lastChecked": null,
    "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
  });
*/

void main() async {
  final MockUser user = MockUser(uid: "1");

//for ease of testing, I tested writing the event details manually, as it was quicker to do the comparisons by hand
  group("Writing event details", () {
    test("Add basic Firefly events over 1 week (w/o nulls)", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      String eventsText =
          await File("test/testing_files/1week.txt").readAsString();

      print("--1 week--");
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      printWrapped(databaseReference.dump());
    });
    test("Add basic Firefly events over 2 weeks (w/o nulls)", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      String eventsText =
          await File("test/testing_files/2weeks.txt").readAsString();

      print("--2 weeks--");
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      printWrapped(databaseReference.dump());
    });
    test("Add Firefly events over 1 week with null locations", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      String eventsText =
          await File("test/testing_files/1week_nulls.txt").readAsString();

      print("--1 week_nulls--");
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      printWrapped(databaseReference.dump());
    });
    test("Add Firefly events over 2 weeks with null locations", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      String eventsText =
          await File("test/testing_files/2weeks_nulls.txt").readAsString();

      print("--2 week_nulls--");
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      printWrapped(databaseReference.dump());
    });
  });
}
