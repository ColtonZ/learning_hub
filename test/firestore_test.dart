import "package:cloud_firestore/cloud_firestore.dart";
import "package:cloud_firestore_mocks/cloud_firestore_mocks.dart";
import "package:learning_hub/backend/firestoreBackend.dart";
import "mock_classes.dart";
import "package:test/test.dart";
import 'package:learning_hub/objects/event.dart';

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
  });
  group("Deal with tasks", () {});
}
