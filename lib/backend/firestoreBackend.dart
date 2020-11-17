import 'package:cloud_firestore/cloud_firestore.dart';

void addUserDetails() async {
//https://medium.com/@atul.sharma_94062/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27
}

Future<int> eventCount(String userId) async {
  final databaseReference = Firestore.instance;
  //https://stackoverflow.com/questions/54456665/how-to-count-the-number-of-documents-firestore-on-flutter
  QuerySnapshot eventsSnapshot = await databaseReference
      .collection("users")
      .document(userId)
      .collection("events")
      .getDocuments();

  List<DocumentSnapshot> events = eventsSnapshot.documents;

  return events.length;
}
