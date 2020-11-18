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

Future<String> addFirestoreEvents(
    String eventsText, String week, String id) async {
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

  for (String eventString in eventsTextList) {
    List<String> eventDetails = eventString.split(", ");
    List<int> timings = [];
    List<String> compoundDetails;
    String classSet;
    String location;

    if (eventDetails[2].contains(" in ")) {
      compoundDetails = eventDetails[2].split(" in ");

      List<String> locationAndSet = compoundDetails[1].split(" (");
      location = locationAndSet[0];

      if (locationAndSet[1].contains("-/")) {
        classSet =
            locationAndSet[1].substring(0, locationAndSet[1].indexOf("-/"));
      } else {
        classSet = locationAndSet[1].replaceAll(")", "");
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

    if (timings[0] < prevStartTime) {
      day++;
    }
    prevStartTime = timings[0];
    int eventDay = day % 5;
    String eventWeek = weeks[day ~/ 5];

    //print("Class: ${eventDetails[0]} | Teacher: ${eventDetails[1]} | Start Time: ${timings[0]} | End Time: ${timings[1]} | location: $location | Set: $classSet | Day: $eventDay | Week: $eventWeek");

    QuerySnapshot matchingEvent = await databaseReference
        .collection("users")
        .doc(id)
        .collection("events")
        .where("name", isEqualTo: eventDetails[0])
        .where("platform", isEqualTo: "Firefly")
        .where("classSet", isEqualTo: classSet)
        .where("location", isEqualTo: location)
        .where("teacher", isEqualTo: eventDetails[1])
        .get();

    if (matchingEvent.docs.isNotEmpty) {
      DocumentSnapshot firestoreEvent = matchingEvent.docs.first;
      String docId = firestoreEvent.id;
      List<dynamic> times = firestoreEvent.get("times");
      bool exists = false;

      var docToUpdate = databaseReference
          .collection("users")
          .doc(id)
          .collection("events")
          .doc(docId);

      for (int i = 0; i < times.length; i++) {
        if (times[i].startsWith(
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}")) {
          exists = true;
          if ((times[i].split(", ")[3] == "B" && eventWeek == "A") ||
              (times[i].split(", ")[3] == "A" && eventWeek == "B")) {
            String toAdd =
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, AB";

            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayRemove([
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, ${times[i].split(", ")[3]}"
              ])
            });

            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayUnion([toAdd])
            });
          }
        }
      }
      if (!exists) {
        await docToUpdate.update(<String, dynamic>{
          "times": FieldValue.arrayUnion([
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
          ])
        });
      }
    } else {
      await databaseReference
          .collection("users")
          .doc(id)
          .collection("events")
          .add({
        "classSet": classSet,
        "location": location,
        "name": eventDetails[0],
        "platform": "Firefly",
        "teacher": eventDetails[1],
        "times": [
          "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
        ]
      });
    }

    return "done";

    //check if lesson added (same location, teacher, subject), then check if time already there, then check repitions
  }
}
