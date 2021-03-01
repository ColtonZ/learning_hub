import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_firestore_mocks/cloud_firestore_mocks.dart";
import 'package:learning_hub/backend/courseWorkBackend.dart';
import "package:learning_hub/backend/firestoreBackend.dart";
import 'package:learning_hub/backend/helperBackend.dart';
import 'package:learning_hub/objects/addPersonalTask.dart';
import 'package:learning_hub/objects/assignment.dart';
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
  group("Managing custom events", () {
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
  group("Managing personal tasks", () {
    //resets the firestore instance
    final databaseReference = MockFirestoreInstance();

    //create an assignment with no subject or description
    Assignment reduced = Assignment.createCustom(
        "Test Assignment 1", "", "", DateTime.now().add(Duration(days: 2)));

    //create a normal custom assignment
    Assignment normal = Assignment.createCustom(
        "Test Assignment 2",
        "Assignment Subject",
        "Assignment Description",
        DateTime.now().add(Duration(days: 2)));
    test("Add a personal task with no subject or description", () async {
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });

      //we know the Assignment.createCustom method works from earlier, so can use it here
      await firestoreToDoAdd(databaseReference, user, reduced);

      print("---Add a personal task with no subject or description---");
      printWrapped(databaseReference.dump());
    });
    test("Add a personal task with subject & description", () async {
      //we know the Assignment.createCustom method works from earlier, so can use it here
      await firestoreToDoAdd(databaseReference, user, normal);

      print("---Add a personal task with subject & description---");
      printWrapped(databaseReference.dump());
    });
    test("Mark a personal task with no subject or description as done",
        () async {
      await markAsDone(databaseReference, user, reduced);

      print(
          "---Mark a personal task with no subject or description as done---");
      printWrapped(databaseReference.dump());
    });
    test("Mark a normal personal task as done", () async {
      await markAsDone(databaseReference, user, normal);
      print("---Mark a normal personal task as done---");
      printWrapped(databaseReference.dump());
    });
  });
  group("Managing a user's tannoy data", () {
    test("Add a tannoy to a user with no tannoy data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });

      //read tannoy data to add from a file
      String tannoyText =
          await File("test/testing_files/full_tannoy.txt").readAsString();

      print("--Add a tannoy to a user with no tannoy data--");
      await addTannoy(databaseReference, user, tannoyText);
      printWrapped(databaseReference.dump());
    });
    test("Add a tannoy to a user with previous tannoy data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //add tannoy data from the previous day
      await addTannoy(databaseReference, user,
          "The previous day's tannoy and all its data");

      //output the previous day's details to ensure they are deleted correctly
      print("---Previous day---");
      printWrapped(databaseReference.dump());

      //read tannoy data to add from a file
      String tannoyText =
          await File("test/testing_files/full_tannoy.txt").readAsString();

      print("--Add a tannoy to a user with no tannoy data--");
      await addTannoy(databaseReference, user, tannoyText);

      print("--Add a tannoy to a user with previous tannoy data--");
      await addTannoy(databaseReference, user, tannoyText);
      printWrapped(databaseReference.dump());
    });
    test("Clear a user's tannoy data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //add tannoy data from the previous day
      await addTannoy(databaseReference, user,
          "The previous day's tannoy and all its data");

      //output the previous day's details to ensure they are deleted correctly
      print("---Previous day---");
      printWrapped(databaseReference.dump());

      await clearTannoy(databaseReference, user);
      print("---Deleted data---");
      printWrapped(databaseReference.dump());
    });
  });
  group("Managing a user's data", () {
    test("Delete a user's event data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds other data typical of a normal user (tannoy, tasks and events)
      //this uses methods tested earlier, as we know they work
      String eventsText =
          await File("test/testing_files/2weeks_nulls.txt").readAsString();
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 1", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 2", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 3", "description", "subject", DateTime.now()));
      String tannoyText =
          await File("test/testing_files/full_tannoy.txt").readAsString();
      await addTannoy(databaseReference, user, tannoyText);

      print("--Data before deletion---");
      printWrapped(databaseReference.dump());

      await deleteData(databaseReference, user, 0);
      print("--Delete a user's event data---");
      printWrapped(databaseReference.dump());
    });
    test("Delete a user's task data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds other data typical of a normal user (tannoy, tasks and events)
      //this uses methods tested earlier, as we know they work
      String eventsText =
          await File("test/testing_files/2weeks_nulls.txt").readAsString();
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 1", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 2", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 3", "description", "subject", DateTime.now()));
      String tannoyText =
          await File("test/testing_files/full_tannoy.txt").readAsString();
      await addTannoy(databaseReference, user, tannoyText);

      print("--Data before deletion---");
      printWrapped(databaseReference.dump());

      await deleteData(databaseReference, user, 1);
      print("--Delete a user's task data---");
      printWrapped(databaseReference.dump());
    });
    test("Delete all a user's data", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds other data typical of a normal user (tannoy, tasks and events)
      //this uses methods tested earlier, as we know they work
      String eventsText =
          await File("test/testing_files/2weeks_nulls.txt").readAsString();
      await addFirestoreEvents(databaseReference, user, eventsText, "A");
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 1", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 2", "description", "subject", DateTime.now()));
      await firestoreToDoAdd(
          databaseReference,
          user,
          Assignment.createCustom(
              "Assignment 3", "description", "subject", DateTime.now()));
      String tannoyText =
          await File("test/testing_files/full_tannoy.txt").readAsString();
      await addTannoy(databaseReference, user, tannoyText);

      print("--Data before deletion---");
      printWrapped(databaseReference.dump());

      await deleteData(databaseReference, user, 2);
      print("--Delete all a user's data---");
      printWrapped(databaseReference.dump());
    });
  });
  group("Manage the current week", () {
    test("Update the week when this week is week A", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });

      await updateFirestoreWeek(databaseReference, user, "A");
      print("---Update the week when this week is week A---");
      printWrapped(databaseReference.dump());
    });
    test("Update the week when this week is week B", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });

      await updateFirestoreWeek(databaseReference, user, "B");
      print("---Update the week when this week is week B---");
      printWrapped(databaseReference.dump());
    });
  });
}
