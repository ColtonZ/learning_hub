import 'package:cloud_firestore/cloud_firestore.dart';

void addUserDetails() async {
  final databaseReference = Firestore.instance;

  DocumentReference ref = await databaseReference.collection("users").add({
    'title': 'Flutter in Action',
    'description': 'Complete Programming Guide to learn Flutter'
  });
  print(ref.documentID);
//https://medium.com/@atul.sharma_94062/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27
}
