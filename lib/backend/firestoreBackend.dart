import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void addUserDetails() async {
//https://medium.com/@atul.sharma_94062/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27
}

Future<int> eventCount(String userId) async {
  await Firebase.initializeApp();
  final databaseReference = FirebaseFirestore.instance;
  //https://stackoverflow.com/questions/54456665/how-to-count-the-number-of-documents-firestore-on-flutter
  QuerySnapshot eventsSnapshot = await databaseReference
      .collection("users")
      .doc(userId)
      .collection("events")
      .get();

  List<DocumentSnapshot> events = eventsSnapshot.docs;
  print(events.length);
  return events.length;
}
