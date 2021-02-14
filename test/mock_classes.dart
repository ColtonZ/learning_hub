import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MockDocumentReference extends Mock implements DocumentReference {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockQuery extends Mock implements Query {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> mockData;
  final String id;
  MockDocumentSnapshot({this.mockData, this.id});

  Map<String, Object> data() {
    return this.mockData;
  }
}

class MockUser extends Mock implements User {
  final MockAuth auth;
  final String uid;
  MockUser({this.uid, this.auth});
}

class MockAuth extends Mock implements FirebaseAuth {
  final MockApp app;
  MockAuth({this.app});
}

class MockApp extends Mock implements FirebaseApp {
  final MockOptions options;
  MockApp({this.options});
}

class MockOptions extends Mock implements FirebaseOptions {
  final String apiKey;
  final String appId;
  final String databaseURL;
  final String messagingSenderId;
  final String projectId;
  final String storageBucket;
  MockOptions(
      {this.apiKey,
      this.appId,
      this.databaseURL,
      this.messagingSenderId,
      this.projectId,
      this.storageBucket});
}
