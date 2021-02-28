import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_firestore_mocks/cloud_firestore_mocks.dart";
import "package:learning_hub/backend/firestoreBackend.dart";
import 'package:learning_hub/objects/notice.dart';
import 'mock_classes.dart';
import "package:test/test.dart";
import 'package:learning_hub/objects/event.dart';
import 'package:learning_hub/objects/assignment.dart';
import 'package:learning_hub/objects/attachment.dart';
import 'package:learning_hub/constants.dart';

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
  group("Get current week", () {
    test("Current week is week A & after LastChecked", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 14)),
          "A");
    });
    test("Current week is week B & after LastChecked", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 21)),
          "B");
    });
    test("Current week is week A & before LastChecked", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 1, 28)),
          "A");
    });
    test("Current week is week B & before LastChecked", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 5)),
          "B");
    });
  });
  group("Check when tannoy was last checked", () {
    test("No tannoy notices in the database", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(await tannoyRecentlyChecked(databaseReference, user), false);
    });
    test("An old tannoy notice in the database", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("tannoy")
          .add({
        "notices": "All the notice details",
        "modified":
            Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))
      });
      expect(await tannoyRecentlyChecked(databaseReference, user), false);
    });
    test("Today's tannoy notice in the database", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("tannoy")
          .add({
        "notices": "All the notice details",
        "modified": Timestamp.fromDate(DateTime.now())
      });
      expect(await tannoyRecentlyChecked(databaseReference, user), true);
    });
  });
  group("Get single events", () {
    test("Get a standard Firefly event", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: "SPS Room 122",
              name: "Latin",
              platform: "Firefly",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a Firefly event without a location", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly without a location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": null,
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: null,
              name: "Latin",
              platform: "Firefly",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a Firefly event without a teacher", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly without a teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": null,
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: "SPS Room 122",
              name: "Latin",
              platform: "Firefly",
              teacher: null,
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a Firefly event without a location or a teacher", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly without a location or teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": null,
        "name": "Latin",
        "platform": "Firefly",
        "teacher": null,
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: null,
              name: "Latin",
              platform: "Firefly",
              teacher: null,
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a Firefly event only occuring on one week", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly only occuring on one week
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, B", "1, 1115, 1155, B"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: "SPS Room 122",
              name: "Latin",
              platform: "Firefly",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "B"],
                ["1", "1115", "1155", "B"]
              ]));
    });
    test("Get a Firefly event occuring sometimes on one week, sometimes on two",
        () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly, occuring differently throughout weeks
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, B", "2, 1235, 1310, A"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: "ULA.1",
              location: "SPS Room 122",
              name: "Latin",
              platform: "Firefly",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "B"],
                ["2", "1235", "1310", "A"]
              ]));
    });
    test("Get a standard LH event", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "LH",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: "SPS Room 122",
              name: "Latin",
              platform: "LH",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a LH event without a location", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH without a location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": null,
        "name": "Latin",
        "platform": "LH",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: null,
              name: "Latin",
              platform: "LH",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a LH event without a teacher", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH without a teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "LH",
        "teacher": null,
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: "SPS Room 122",
              name: "Latin",
              platform: "LH",
              teacher: null,
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a LH event without a location or a teacher", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH without a location or teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": null,
        "name": "Latin",
        "platform": "LH",
        "teacher": null,
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: null,
              name: "Latin",
              platform: "LH",
              teacher: null,
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "AB"]
              ]));
    });
    test("Get a LH event only occuring on one week", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH only occuring on one week
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "LH",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, B", "1, 1115, 1155, B"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: "SPS Room 122",
              name: "Latin",
              platform: "LH",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "B"],
                ["1", "1115", "1155", "B"]
              ]));
    });
    test("Get a LH event occuring sometimes on one week, sometimes on two",
        () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from LH, occuring differently throughout weeks
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": null,
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "LH",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, B", "2, 1235, 1310, A"]
      });
      expect(
          await getEvent(databaseReference, user, "1"),
          Event(
              id: "1",
              classSet: null,
              location: "SPS Room 122",
              name: "Latin",
              platform: "LH",
              teacher: "Katy Waterfield",
              times: [
                ["0", "1415", "1455", "AB"],
                ["1", "1115", "1155", "B"],
                ["2", "1235", "1310", "A"]
              ]));
    });
  });
  group("Get groups of events", () {
    test("Get a mixed group of Firefly events from Firestore", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      //adds a Firefly event without a location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("2")
          .set({
        "classSet": "U8TH",
        "location": null,
        "name": "U8th Registration",
        "platform": "Firefly",
        "teacher": "Suzanne Squire",
        "times": ["3, 1415, 1455, AB"]
      });
      //adds a Firefly event only on a week A
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("3")
          .set({
        "classSet": "UPH.5",
        "location": "SPS Chemistry Lab 1",
        "name": "Physics",
        "platform": "Firefly",
        "teacher": "Ryan Buckingham",
        "times": ["1, 1040, 1115, A", "1, 1115, 1155, A"]
      });
      //adds a Firefly event with mixed occurence on weeks A & B
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("4")
          .set({
        "classSet": "UCH.2",
        "location": "SPS Chemistry Lab 5",
        "name": "Chemistry",
        "platform": "Firefly",
        "teacher": "Richard Jones",
        "times": ["0, 1155, 1235, A", "2, 1155, 1235, AB"]
      });
      List<Event> targetList = [
        Event(
            id: "1",
            classSet: "ULA.1",
            location: "SPS Room 122",
            name: "Latin",
            platform: "Firefly",
            teacher: "Katy Waterfield",
            times: [
              ["0", "1415", "1455", "AB"],
              ["1", "1115", "1155", "AB"]
            ]),
        Event(
            id: "2",
            classSet: "U8TH",
            location: null,
            name: "U8th Registration",
            platform: "Firefly",
            teacher: "Suzanne Squire",
            times: [
              ["3", "1415", "1455", "AB"]
            ]),
        Event(
            id: "3",
            classSet: "UPH.5",
            location: "SPS Chemistry Lab 1",
            name: "Physics",
            platform: "Firefly",
            teacher: "Ryan Buckingham",
            times: [
              ["1", "1040", "1115", "A"],
              ["1", "1115", "1155", "A"]
            ]),
        Event(
            id: "4",
            classSet: "UCH.2",
            location: "SPS Chemistry Lab 5",
            name: "Chemistry",
            platform: "Firefly",
            teacher: "Richard Jones",
            times: [
              ["0", "1155", "1235", "A"],
              ["2", "1155", "1235", "AB"]
            ])
      ];
      expect(targetList, await getEventsList(databaseReference, user));
    });
    test("Get a mixed group of LH events from Firestore", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a LH event without a teacher or location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("5")
          .set({
        "classSet": null,
        "location": null,
        "name": "Coding Projects Society",
        "platform": "LH",
        "teacher": null,
        "times": ["0, 1240, 1340, AB"]
      });
      //adds a LH event without a teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("6")
          .set({
        "classSet": null,
        "location": "SPS Room 225",
        "name": "Maths University Preparation",
        "platform": "LH",
        "teacher": null,
        "times": ["3, 1400, 1500, AB"]
      });
      //adds a LH event with all details possible
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("7")
          .set({
        "classSet": null,
        "location": "SPS Room 217",
        "name": "Discrete Mathematics",
        "platform": "LH",
        "teacher": "Christopher Harrison",
        "times": ["1, 1535, 1615, B", "0, 1535, 1615, A"]
      });
      List<Event> targetList = [
        Event(
            id: "5",
            classSet: null,
            location: null,
            name: "Coding Projects Society",
            platform: "LH",
            teacher: null,
            times: [
              ["0", "1240", "1340", "AB"]
            ]),
        Event(
            id: "6",
            classSet: null,
            location: "SPS Room 225",
            name: "Maths University Preparation",
            platform: "LH",
            teacher: null,
            times: [
              ["3", "1400", "1500", "AB"]
            ]),
        Event(
            id: "7",
            classSet: null,
            location: "SPS Room 217",
            name: "Discrete Mathematics",
            platform: "LH",
            teacher: "Christopher Harrison",
            times: [
              ["1", "1535", "1615", "B"],
              ["0", "1535", "1615", "A"]
            ])
      ];
      expect(targetList, await getEventsList(databaseReference, user));
    });
    test("Get a mixed group of events from Firestore", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a standard event from Firefly
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("1")
          .set({
        "classSet": "ULA.1",
        "location": "SPS Room 122",
        "name": "Latin",
        "platform": "Firefly",
        "teacher": "Katy Waterfield",
        "times": ["0, 1415, 1455, AB", "1, 1115, 1155, AB"]
      });
      //adds a Firefly event without a location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("2")
          .set({
        "classSet": "U8TH",
        "location": null,
        "name": "U8th Registration",
        "platform": "Firefly",
        "teacher": "Suzanne Squire",
        "times": ["3, 1415, 1455, AB"]
      });
      //adds a Firefly event only on a week A
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("3")
          .set({
        "classSet": "UPH.5",
        "location": "SPS Chemistry Lab 1",
        "name": "Physics",
        "platform": "Firefly",
        "teacher": "Ryan Buckingham",
        "times": ["1, 1040, 1115, A", "1, 1115, 1155, A"]
      });
      //adds a Firefly event with mixed occurence on weeks A & B
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("4")
          .set({
        "classSet": "UCH.2",
        "location": "SPS Chemistry Lab 5",
        "name": "Chemistry",
        "platform": "Firefly",
        "teacher": "Richard Jones",
        "times": ["0, 1155, 1235, A", "2, 1155, 1235, AB"]
      });
      //adds a LH event without a teacher or location
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("5")
          .set({
        "classSet": null,
        "location": null,
        "name": "Coding Projects Society",
        "platform": "LH",
        "teacher": null,
        "times": ["0, 1240, 1340, AB"]
      });
      //adds a LH event without a teacher
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("6")
          .set({
        "classSet": null,
        "location": "SPS Room 225",
        "name": "Maths University Preparation",
        "platform": "LH",
        "teacher": null,
        "times": ["3, 1400, 1500, AB"]
      });
      //adds a LH event with all details possible
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("events")
          .doc("7")
          .set({
        "classSet": null,
        "location": "SPS Room 217",
        "name": "Discrete Mathematics",
        "platform": "LH",
        "teacher": "Christopher Harrison",
        "times": ["1, 1535, 1615, B", "0, 1535, 1615, A"]
      });
      List<Event> targetList = [
        Event(
            id: "1",
            classSet: "ULA.1",
            location: "SPS Room 122",
            name: "Latin",
            platform: "Firefly",
            teacher: "Katy Waterfield",
            times: [
              ["0", "1415", "1455", "AB"],
              ["1", "1115", "1155", "AB"]
            ]),
        Event(
            id: "2",
            classSet: "U8TH",
            location: null,
            name: "U8th Registration",
            platform: "Firefly",
            teacher: "Suzanne Squire",
            times: [
              ["3", "1415", "1455", "AB"]
            ]),
        Event(
            id: "3",
            classSet: "UPH.5",
            location: "SPS Chemistry Lab 1",
            name: "Physics",
            platform: "Firefly",
            teacher: "Ryan Buckingham",
            times: [
              ["1", "1040", "1115", "A"],
              ["1", "1115", "1155", "A"]
            ]),
        Event(
            id: "4",
            classSet: "UCH.2",
            location: "SPS Chemistry Lab 5",
            name: "Chemistry",
            platform: "Firefly",
            teacher: "Richard Jones",
            times: [
              ["0", "1155", "1235", "A"],
              ["2", "1155", "1235", "AB"]
            ]),
        Event(
            id: "5",
            classSet: null,
            location: null,
            name: "Coding Projects Society",
            platform: "LH",
            teacher: null,
            times: [
              ["0", "1240", "1340", "AB"]
            ]),
        Event(
            id: "6",
            classSet: null,
            location: "SPS Room 225",
            name: "Maths University Preparation",
            platform: "LH",
            teacher: null,
            times: [
              ["3", "1400", "1500", "AB"]
            ]),
        Event(
            id: "7",
            classSet: null,
            location: "SPS Room 217",
            name: "Discrete Mathematics",
            platform: "LH",
            teacher: "Christopher Harrison",
            times: [
              ["1", "1535", "1615", "B"],
              ["0", "1535", "1615", "A"]
            ])
      ];
      expect(targetList, await getEventsList(databaseReference, user));
    });
    test("Edge case when user has no events", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(await getEventsList(databaseReference, user), new List<Event>());
    });
  });
  group("Get user-made tasks", () {
    test("Read tasks from the database with only one task", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("toDo")
          .doc("1")
          .set({
        "courseName": "Personal Task • Maths",
        "creationTime": Timestamp(1612523345, 0),
        "description": "Do maths homework",
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Personal Assignment",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      });

      List<Assignment> targetAssignments = [
        Assignment(
            title: "Personal Assignment",
            creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
            type: "PERSONAL",
            courseName: "Personal Task • Maths",
            description: "Do maths homework",
            attachments: new List<Attachment>(),
            submissionAttachments: new List<Attachment>(),
            platform: "LH")
      ];

      expect(
          await getFirestoreTasks(databaseReference, user), targetAssignments);
    });
    test("Read tasks from the database with multiple tasks", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("toDo")
          .doc("1")
          .set({
        "courseName": "Personal Task • Maths",
        "creationTime": Timestamp(1612523345, 0),
        "description": "Do maths homework",
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Personal Assignment",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("toDo")
          .doc("2")
          .set({
        "courseName": "Personal Task",
        "creationTime": Timestamp(1612523345, 0),
        "description": null,
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Personal Assignment",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      });
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("toDo")
          .doc("3")
          .set({
        "courseName": "Personal Task",
        "creationTime": Timestamp(1612523345, 0),
        "description": "Finish Writing Email",
        "dueDate": Timestamp(1612609723, 0),
        "platform": "LH",
        "title": "Difficult Task",
        "type": "PERSONAL",
        "updateTime": Timestamp(1612523345, 0),
      });

      List<Assignment> targetAssignments = [
        Assignment(
            title: "Personal Assignment",
            creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
            type: "PERSONAL",
            courseName: "Personal Task • Maths",
            description: "Do maths homework",
            attachments: new List<Attachment>(),
            submissionAttachments: new List<Attachment>(),
            platform: "LH"),
        Assignment(
            title: "Personal Assignment",
            creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
            type: "PERSONAL",
            courseName: "Personal Task",
            description: null,
            attachments: new List<Attachment>(),
            submissionAttachments: new List<Attachment>(),
            platform: "LH"),
        Assignment(
            title: "Difficult Task",
            creationTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            updateTime: new DateTime(2021, 2, 5, 11, 9, 5, 0),
            dueDate: new DateTime(2021, 2, 6, 11, 8, 43, 0),
            type: "PERSONAL",
            courseName: "Personal Task",
            description: "Finish Writing Email",
            attachments: new List<Attachment>(),
            submissionAttachments: new List<Attachment>(),
            platform: "LH")
      ];

      expect(
          await getFirestoreTasks(databaseReference, user), targetAssignments);
    });
    test("Edge case when user has no tasks", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(await getFirestoreTasks(databaseReference, user),
          new List<Assignment>());
    });
  });
  group("Get tannoy notices", () {
    test("Get a normal day's notice, when the date is today", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a few notices to the database
      //note the weird format - this is how they come back having been scraped from the Hub
      //the date is set to today, so as to validate the notice
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("tannoy")
          .add({
        "notices":
            "${days[DateTime.now().weekday - 1]} 8th February[object HTMLDivElement]:-:Title of the first notice[object HTMLElement]:-:Description of the first notice:-:Title of the second notice[object HTMLElement]:-:Description of the second noticeundefined:-:Title of the third notice[object HTMLElement]:-:Description of the third notice",
        "modified": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      List<Notice> targetNotices = [
        Notice(
            title: "Title of the first notice",
            body: "Description of the first notice"),
        Notice(
            title: "Title of the second notice",
            body: "Description of the second notice"),
        Notice(
            title: "Title of the third notice",
            body: "Description of the third notice"),
      ];
      expect(await getNotices(databaseReference, user), targetNotices);
    });
    test(
        "Get a normal day's notice, when the notices are old (from a previous day)",
        () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      //adds a few notices to the database
      //note the weird format - this is how they come back having been scraped from the Hub
      //the date is set to the day before today, so as to invalidate the notice
      await databaseReference
          .collection("users")
          .doc("1")
          .collection("tannoy")
          .add({
        "notices":
            "${DateTime.now().weekday == 1 ? "Sunday" : days[DateTime.now().weekday - 2]} 8th February[object HTMLDivElement]:-:Title of the first notice[object HTMLElement]:-:Description of the first notice:-:Title of the second notice[object HTMLElement]:-:Description of the second noticeundefined:-:Title of the third notice[object HTMLElement]:-:Description of the third notice",
        "modified": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(await getNotices(databaseReference, user), null);
    });
    test("Edge case when the user has no notices", () async {
      //resets the firestore instance
      final databaseReference = MockFirestoreInstance();
      //sets up a basic firestore user
      await databaseReference.collection("users").doc("1").set({
        "email": "testemail@email.com",
        "lastChecked": null,
        "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
      });
      expect(await getNotices(databaseReference, user), null);
    });
  });
}
