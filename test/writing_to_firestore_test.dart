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
  group("Writing event details in bulk from Firefly", () {
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
  group("Adding custom events", () {
    //resets the firestore instance
    final databaseReference = MockFirestoreInstance();

    test(
        "Create a custom event with no location or teacher that does not already exist on one week",
        () async {
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });

      await addCustomEvent(
          databaseReference,
          user,
          "Event Name",
          null,
          null,
          [true, false, false, false, false, false, false],
          true,
          false,
          "1040",
          "1130");

      print(
          "---Create a custom event with no location or teacher that does not already exist on one week---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a time (a new day) to a custom event with no location or teacher that already exists",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Event Name",
          null,
          null,
          [false, true, false, false, false, false, false],
          true,
          false,
          "1040",
          "1130");

      print(
          "---Add a time (a new day) to a custom event with no location or teacher that already exists---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a time (a new time to an already existing day) to a custom event with no location or teacher that already exists",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Event Name",
          null,
          null,
          [false, true, false, false, false, false, false],
          true,
          false,
          "1200",
          "1300");
      print(
          "---Add a time (a new time to an already existing day) to a custom event with no location or teacher that already exists---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a week to a custom event with no location or teacher that already exists",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Event Name",
          null,
          null,
          [false, true, false, false, false, false, false],
          false,
          true,
          "1200",
          "1300");
      print(
          "---Add a week to a custom event with no location or teacher that already exists---");
      printWrapped(databaseReference.dump());
    });
    test("Create a normal custom event that does not already exist", () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Blue's Lesson",
          "Mr. Blue",
          "Blue Classroom",
          [true, true, false, false, false, false, false],
          false,
          true,
          "1200",
          "1300");
      print("---Create a normal custom event that does not already exist---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Create a normal custom event that does not already exist over multiple days",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Green's Lesson",
          "Miss. Green",
          "Green Classroom",
          [true, true, false, true, false, false, true],
          false,
          true,
          "1200",
          "1300");
      print(
          "---Create a normal custom event that does not already exist over multiple days---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Create a normal custom event that does not already exist over multiple days and weeks",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Grey's Lesson",
          "Prof. Grey",
          "Grey Classroom",
          [true, true, false, true, false, false, true],
          true,
          true,
          "1200",
          "1300");
      print(
          "---Create a normal custom event that does not already exist over multiple days and weeks---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a new event with a different location but same name to an event that already exists",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Grey's Lesson",
          "Prof. Grey",
          "Temporary Classroom",
          [true, true, false, true, false, false, true],
          true,
          true,
          "1100",
          "1200");
      print(
          "---Add a new event with a different location but same name to an event that already exists---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a new event with a different teacher but same name to an event that already exists",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Blue's Lesson",
          "Prof. Grey",
          "Blue's Classroom",
          [true, true, false, true, false, false, true],
          true,
          true,
          "1000",
          "1100");
      print(
          "---Add a new event with a different teacher but same name to an event that already exists---");
      printWrapped(databaseReference.dump());
    });
    test(
        "Add a new event with a teacher but same name to an event that already exists but does not have a teacher or location",
        () async {
      await addCustomEvent(
          databaseReference,
          user,
          "Event Name",
          "Prof. Grey",
          "Blue's Classroom",
          [true, true, false, true, false, false, true],
          true,
          true,
          "1000",
          "1100");
      print(
          "---Add a new event with a teacher but same name to an event that already exists but does not have a teacher or location---");
      printWrapped(databaseReference.dump());
    });
  });
}
