import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:learning_hub/backend/helperBackend.dart';

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

  printWrapped(eventsText);

  List<String> eventsTextList = eventsText.split("; ");

  //check if lesson added (same room, teacher, subject), then check if time already there, then check repitions
}
