import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:learning_hub/backend/firestoreBackend.dart';
import 'mock_classes.dart';
import 'package:test/test.dart';

void main() async {
  final databaseReference = MockFirestoreInstance();
  await databaseReference.collection('users').doc("1").set({
    'email': 'testemail@email.com',
    "lastChecked": null,
    "weekA": Timestamp.fromDate(DateTime(2021, 2, 8))
  });
  final MockUser user = MockUser(uid: "1");
  group("Get current week", () {
    test("Current week is week A & after LastChecked", () async {
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 14)),
          "A");
    });
    test("Current week is week B & after LastChecked", () async {
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 21)),
          "B");
    });
    test("Current week is week A & before LastChecked", () async {
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 1, 28)),
          "A");
    });
    test("Current week is week B & before LastChecked", () async {
      expect(
          await getCurrentWeek(databaseReference, user, DateTime(2021, 2, 5)),
          "B");
    });
  });
  group("Check when tannoy was last checked", () {
    test("No tannoy notices in the database", () async {
      expect(await tannoyRecentlyChecked(databaseReference, user), false);
    });
    test("An old tannoy notice in the database", () async {
      await databaseReference
          .collection('users')
          .doc("1")
          .collection("tannoy")
          .add({
        'notices': 'All the notice details',
        "modified":
            Timestamp.fromDate(DateTime.now().subtract(Duration(days: 1)))
      });
      expect(await tannoyRecentlyChecked(databaseReference, user), false);
    });
    test("Today's tannoy notice in the database", () async {
      await databaseReference
          .collection('users')
          .doc("1")
          .collection("tannoy")
          .add({
        'notices': 'All the notice details',
        "modified": Timestamp.fromDate(DateTime.now())
      });
      expect(await tannoyRecentlyChecked(databaseReference, user), true);
    });
  });
}
