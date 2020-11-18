import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_hub/backend/helperBackend.dart';
import 'dart:core';

Future<int> fireflyEventCount(String id) async {
  await Firebase.initializeApp();
  final databaseReference = FirebaseFirestore.instance;
  //https://stackoverflow.com/questions/54456665/how-to-count-the-number-of-documents-firestore-on-flutter
  QuerySnapshot eventsSnapshot = await databaseReference
      .collection("users")
      .doc(id)
      .collection("events")
      .where("platform", isEqualTo: "Firefly")
      .get();

  List<DocumentSnapshot> events = eventsSnapshot.docs;
  return events.length;
}

Future<String> getUserId(String email) async {
  await Firebase.initializeApp();
  final databaseReference = FirebaseFirestore.instance;
  String id = "";

  QuerySnapshot usersSnapshot = await databaseReference
      .collection("users")
      .where("email", isEqualTo: email)
      .get();

  //https://atul-sharma-94062.medium.com/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27
  if (usersSnapshot.docs.isEmpty) {
    DocumentReference newUser =
        await databaseReference.collection("users").add({"email": email});
    id = newUser.id;
  } else {
    id = usersSnapshot.docs.first.id;
  }

  return id;
}

void addFirestoreEvents(String eventsText, String week, String id) async {
  await Firebase.initializeApp();
  final databaseReference = FirebaseFirestore.instance;

  QuerySnapshot fireflyEvents = await databaseReference
      .collection("users")
      .doc(id)
      .collection("events")
      .where("platform", isEqualTo: "Firefly")
      .get();

  List<DocumentSnapshot> fireflyEventsList = fireflyEvents.docs;

  fireflyEventsList.forEach((event) {
    databaseReference
        .collection("users")
        .doc(id)
        .collection("events")
        .doc(event.id)
        .delete();
  });

  List<String> weeks = DateTime.now().weekday == 1
      ? week == "A"
          ? ["A", "B"]
          : ["B", "A"]
      : week == "A"
          ? ["B", "A"]
          : ["A", "B"];

  List<String> eventsTextList = eventsText.split("; ");

  int day = 0;
  int prevStartTime = 0;

  eventsTextList.forEach((eventString) {
    List<String> eventDetails = eventString.split(", ");
    List<int> timings = [];
    List<String> compoundDetails;
    String classSet;
    String room;

    if (eventDetails[2].contains(" in ")) {
      compoundDetails = eventDetails[2].split(" in ");

      List<String> roomAndSet = compoundDetails[1].split(" (");
      room = roomAndSet[0];

      if (roomAndSet[1].contains("-/")) {
        classSet = roomAndSet[1].substring(0, roomAndSet[1].indexOf("-/"));
      } else {
        classSet = roomAndSet[1].replaceAll(")", "");
      }
    } else {
      compoundDetails = eventDetails[2].split(" (");

      if (compoundDetails[1].contains("-/")) {
        classSet =
            compoundDetails[1].substring(0, compoundDetails[1].indexOf("-/"));
      } else {
        classSet = compoundDetails[1].replaceAll(")", "");
      }
    }

    List<String> timingsStrings = compoundDetails[0].split(" - ");

    timingsStrings.forEach((time) {
      timings.add(int.parse(time.replaceAll(":", "")));
    });

    print(
        "Class: ${eventDetails[0]} | Teacher: ${eventDetails[1]} | Start Time: ${timings[0]} | End Time: ${timings[1]} | Room: $room | Set: $classSet");
  });

  //check if lesson added (same room, teacher, subject), then check if time already there, then check repitions
}
