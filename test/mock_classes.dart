import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class MockDocumentReference extends Mock implements DocumentReference {}

class MockFirestore extends Mock implements FirebaseFirestore {}

class MockCollectionReference extends Mock implements CollectionReference {}

class MockQuerySnapshot extends Mock implements QuerySnapshot {}

class MockDocumentSnapshot extends Mock implements DocumentSnapshot {
  final Map<String, dynamic> mockData;
  final String id;
  MockDocumentSnapshot({this.mockData, this.id});

  Map<String, Object> data() {
    return this.mockData;
  }
}

class MockQuery extends Mock implements Query {}

void main() async {}
