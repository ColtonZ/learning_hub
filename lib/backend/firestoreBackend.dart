import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:core';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:learning_hub/objects/event.dart';
import 'package:learning_hub/objects/assignment.dart';
import '../objects/notice.dart';

//initialzes an instance of the Firestore database
final databaseReference = FirebaseFirestore.instance;

//counts the number of events in the database added automatically from Firefly
Future<List<Event>> getEventsList(User firebaseUser) async {
  //https://stackoverflow.com/questions/54456665/how-to-count-the-number-of-documents-firestore-on-flutter
  //gets all events from the database which were added automatically from the pupil dashboard

//try to get a list of the user's events
  try {
    QuerySnapshot eventsSnapshot = await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .get();

//get the document for each event
    List<DocumentSnapshot> events = eventsSnapshot.docs;

    List<Event> eventsList = new List<Event>();

//foreach event in the list of events, add it to the events list
    events.forEach((event) {
      Event current = new Event.fromFirestore(event);
      eventsList.add(current);
    });

    return eventsList;
  } catch (e) {
    return null;
  }
}

//given a user id, this checks that the user has a Firestore collection. If not, one is created for them.
void checkFirestoreUser(User firebaseUser) async {
//tries to get a user whose GoogleAuthId is equal to that of the signed-in user.
  QuerySnapshot usersSnapshot = await databaseReference
      .collection("users")
      .where(FieldPath.documentId, isEqualTo: firebaseUser.uid)
      .get();

//https://firebase.google.com/docs/firestore/security/rules-query
//https://firebase.google.com/docs/firestore/query-data/queries
  //https://stackoverflow.com/questions/47876754/query-firestore-database-for-document-id
  //https://atul-sharma-94062.medium.com/how-to-use-cloud-firestore-with-flutter-e6f9e8821b27

  //if no user with the signed-in account is found, a new Firestore document is created with the user's email & id.
  if (usersSnapshot.size == 0) {
    //adds the user to the database
    await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .set({"email": firebaseUser.email, "lastChecked": null, "weekA": null});
  }
}

//adds Firefly events to a user's Firestore database, given the user's ID, and a correctly formatted string of the events.
//the current week (A or B) is also passed, as the order of the events string is dependent on the current week.
Future<String> addFirestoreEvents(
    User firebaseUser, String eventsText, String week) async {
/*
First, existing events (added from Firefly) must be deleted, so as to stop duplicates.
Next, the new events are added, with any repetitions accounted for, and with only one event document for each class (provided they have the same teacher and room as well)
This is to try and limit the amount of duplicate data, as well as to make querying more efficient
*/

//fetch all existing Firestore events added from Firefly
  QuerySnapshot fireflyEvents = await databaseReference
      .collection("users")
      .doc(firebaseUser.uid)
      .collection("events")
      .where("platform", isEqualTo: "Firefly")
      .get();

//create a list of these events
  List<DocumentSnapshot> fireflyEventsList = fireflyEvents.docs;

//loop through the list, deleting each event
  fireflyEventsList.forEach((event) {
    databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .doc(event.id)
        .delete();
  });

//if today is Monday, then the week shown from the web scraping will be the same as the current week. On any other day, the week fetched will be next week.
//the following two weeks are then ordered in a list, with the current week and then next week. This is because the events are scraped in the order of all events happening this week, and then all happening next week.
  List<String> weeks = DateTime.now().weekday == 1
      ? week == "A"
          ? ["A", "B"]
          : ["B", "A"]
      : week == "A"
          ? ["B", "A"]
          : ["A", "B"];

  updateFirestoreWeek(firebaseUser, weeks[0]);

//each event is in the format: "<class>, <teacher>, <start time> - <end time> in <room> (<set>)" (where the <> indicate a parameter)
//first the string is split into a list of events (each being seperated by a semicolon and a space), and then each event is split into individual details accordingly.
  List<String> eventsTextList = eventsText.split("; ");

//sets the first day of the week to be Monday (day 0), and the previous start time to be zero. These are important later on.
  int day = 0;
  int prevStartTime = 0;

  //loops through each event
  for (String eventString in eventsTextList) {
    //first, get the event into three main chunks: the class, the teacher, and then the other details
    List<String> eventDetails = eventString.split(", ");

    //set the list of start time & end time to be an empty list
    List<int> timings = [];

    //initialize other variables for later
    List<String> compoundDetails;
    String classSet;
    String location;

    //check if the other event details contains the word "in". If it does, it means that a location has been given for the event. Otherwise, it means that the event has no location assigned.
    if (eventDetails[2].contains(" in ")) {
      //if the event does have a location:

      //split the last chunk of event details into two parts - the timings of the event (split by " - ") and the location and set of the class
      compoundDetails = eventDetails[2].split(" in ");

      //split the last chunk of the new section at the open bracket. Since the set starts with an open bracket, this will split the set of the class and the location of the class into two items in the array.
      List<String> locationAndSet = compoundDetails[1].split(" (");
      location = locationAndSet[0];

      //this checks if the set for the class is valid. If it is not, it will contain "-/", in which case everything after that can be discarded from the set name.
      //otherwise, only the closing bracket neeeds to be removed to get the set of the class.
      if (locationAndSet[1].contains("-/")) {
        classSet =
            locationAndSet[1].substring(0, locationAndSet[1].indexOf("-/"));
      } else {
        classSet = locationAndSet[1].replaceAll(")", "");
      }
    }
    //this deals with the case where no room is given for the event. In this case, the process of getting the set is much shorter, as the room does not need to be removed, and so the timings and set are just split by " ("
    else {
      //split the timings of the event (seperated by " - ") and the set into an array of length 2
      compoundDetails = eventDetails[2].split(" (");

      //this checks if the set for the class is valid. If it is not, it will contain "-/", in which case everything after that can be discarded from the set name.
      //otherwise, only the closing bracket neeeds to be removed to get the set of the class.
      if (compoundDetails[1].contains("-/")) {
        classSet =
            compoundDetails[1].substring(0, compoundDetails[1].indexOf("-/"));
      } else {
        classSet = compoundDetails[1].replaceAll(")", "");
      }
    }

    //splits the start and end times of the event into a list of two items
    List<String> timingsStrings = compoundDetails[0].split(" - ");

    //converts each time (given in 24 hour format) into an integer. This makes it easier to compare the start and end times of a given event, which is useful later on.
    timingsStrings.forEach((time) {
      timings.add(int.parse(time.replaceAll(":", "")));
    });

    //if the given start time of an event is before the start of the previous event, then that means it must occur the next day. As such, the day is incremented by one.
    if (timings[0] < prevStartTime) {
      day++;
    }

    //the previous start time is then set to the start time of the current event
    prevStartTime = timings[0];

    //mods the event day by 5, so that, if the day is greater than 5, we still get the correct weekday (between 0 and 4 for Monday to Friday)
    int eventDay = day % 5;

    //performs absolute division of the event day by 5, so that, if the day is greater than 5, we know it must occur in the second week (as each user has at least one Firefly event each day, and no Firefly events on weekends).
    String eventWeek = weeks[day ~/ 5];

    //this tries to get all events in the user's events collection where the class, teacher, set, location are the same (and the event was added by Firefly)
    QuerySnapshot matchingEvent = await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .where("name", isEqualTo: eventDetails[0])
        .where("platform", isEqualTo: "Firefly")
        .where("classSet", isEqualTo: classSet)
        .where("location", isEqualTo: location)
        .where("teacher", isEqualTo: eventDetails[1])
        .get();

    //if a matching event exists, then the current event's details are simply added to the event just found in the database (to stop too much duplicate data)
    //otherwise, a new event is added according to the given details
    if (matchingEvent.docs.isNotEmpty) {
      //if there is a matching event:

      //fetch the details of the event, including its ID
      DocumentSnapshot firestoreEvent = matchingEvent.docs.first;
      String docId = firestoreEvent.id;

      //fetch the times of the event already in the database, so that they can be modified accordingly
      List<dynamic> times = firestoreEvent.get("times");

      bool exists = false;

      //set the document for the event in the database to the event with the afformentioned ID
      var docToUpdate = databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .doc(docId);

      //loop through each of the times of the event already in the database (each time is a string, in the format: "<day>, <start time>, <end time>, <weeks>")
      //i.e. if an event occurs every Monday on week A from 9am to 9:35am, it would be saved as: "0, 0900, 0935, A"
      //this is so that we can work out if an event only happens every other week (e.g. just on week A or B), or if it happens every week (on both weeks A & B)
      for (int i = 0; i < times.length; i++) {
        //checks if the current time we've fetched from the array of times is the same as the timings for the event we want to add (excluding when it repeats)
        if (times[i].startsWith(
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}")) {
          //if a matching time exists for the given event:

          //state that we have already added the event's timings
          exists = true;

          //check whe the event repeats. If it repeats on a week that differs from the week of the event we are currently adding (i.e. to stop duplicate timings), then enter the if statement
          if ((times[i].split(", ")[3] == "B" && eventWeek == "A") ||
              (times[i].split(", ")[3] == "A" && eventWeek == "B")) {
            //this formats the event in a string according to the layout defined earlier. For the repeats, it is set to weeks A&B, as we found that these weeks were different at the top of the if statement.
            String toAdd =
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, AB";

            //updates the timings field of the event we are editing. First the value in the timings array that matches is removed.
            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayRemove([
                "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, ${times[i].split(", ")[3]}"
              ])
            });

            //then the value in the array representing the repeats is re-added, according to the new timings.
            await docToUpdate.update(<String, dynamic>{
              "times": FieldValue.arrayUnion([toAdd])
            });
          }
        }
      }

      //if, having checked every time that the event occurs, there are none matching the time of the current event (exists is false), a new time is added to the event in the database.
      //this, by definition, would only repeat on the current week (although as we continue to loop through the web scraped events, repeats may be added as above)
      if (!exists) {
        //adds a new time to the event's timings field according to the format above
        await docToUpdate.update(<String, dynamic>{
          "times": FieldValue.arrayUnion([
            "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
          ])
        });
      }
    }

    //if no matching event exists:
    else {
      //add a new event document to the events collection for the user, with the event details. (Defined above)
      await databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .add({
        "classSet": classSet,
        "location": location,
        "name": eventDetails[0],
        "platform": "Firefly",
        "teacher": eventDetails[1],
        //the times are set as an array of length 1, in the format used in the above "if" statement, so as to allow for more times to be added in the future
        "times": [
          "$eventDay, ${timings[0].toString().padLeft(4, '0')}, ${timings[1].toString().padLeft(4, '0')}, $eventWeek"
        ]
      });
    }
  }

  //once all events have been added, something needs to be returned, so that we can wait to build the page until all events have been added (so all events are displayed to the user)
  return "done";
}

Future<String> getCurrentWeek(User firebaseUser, DateTime date) async {
  //get the user's doc
  DocumentSnapshot userDoc =
      await databaseReference.collection("users").doc(firebaseUser.uid).get();

//convert the last time it was week A to a date
  DateTime weekA = userDoc.data()["weekA"].toDate();

  print((-weekA.difference(date).inDays) ~/ 7 % 2);

//if that happened an even number of weeks ago, it must be week A, otherwise it'll be week B
  return (-weekA.difference(date).inDays) ~/ 7 % 2 == 0 ? "A" : "B";
}

Future<List<Assignment>> getFirestoreTasks(User firebaseUser) async {
  //gets all assignments from the Firestore db
  try {
    QuerySnapshot tasksSnapshot = await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("toDo")
        .get();

    //create a list of the assignment docs
    List<DocumentSnapshot> assignments = tasksSnapshot.docs;

    List<Assignment> assignmentsList = new List<Assignment>();

//for each assignment in the list, convert it into an Assignment object, and add it to the list
    assignments.forEach((assignment) {
      Assignment current = new Assignment.fromFirestore(assignment);
      assignmentsList.add(current);
    });
    return assignmentsList;
  } catch (e) {
    //if an error is thrown, there are no assignments, so return null
    return null;
  }
}

Future<String> firestoreToDoAdd(
    User firebaseUser, Assignment assignment) async {
  List<String> attachmentStrings = new List<String>();
  try {
    assignment.attachments.forEach((attachment) {
      //foreach of the task's attachments, convert its details into a string so that it can be uploaded to Firestore
      attachmentStrings.add(
          "${attachment.id}, ${attachment.title}, ${attachment.link}, ${attachment.thumbnail}, ${attachment.type}");
    });
  } catch (e) {}
  List<String> submissionStrings = new List<String>();
  try {
    assignment.submissionAttachments.forEach((attachment) {
      //foreach of the student's attachments, convert its details into a string so that it can be uploaded to Firestore
      submissionStrings.add(
          "${attachment.id}, ${attachment.title}, ${attachment.link}, ${attachment.thumbnail}, ${attachment.type}");
    });
  } catch (e) {}

  String question = "";
  if (assignment.type == "MULTIPLE_CHOICE_QUESTION") {
    //check if the task has a question. If it does, convert the options for the question into a string. This string is seperated by :-: as it is unlikely that will occur in one of the options.
    assignment.question.options.forEach((option) {
      question += ":-:$option";
    });
    //remove the first :-: of the string (i.e. the separator before the first option)
    question = question.substring(3);
  } else {
    question = question == "" ? null : question;
  }

//add the assignment's details to the Firestore database
  await databaseReference
      .collection("users")
      .doc(firebaseUser.uid)
      .collection("toDo")
      .add({
    "url": assignment.url,
    "platform": assignment.platform,
    "courseId": assignment.courseId,
    "courseName": assignment.courseName,
    "title": assignment.title,
    "description": assignment.description,
    "id": assignment.id,
    "submissionId": assignment.submissionId,
    "status": assignment.status,
    "type": assignment.type,
    "creationTime": assignment.creationTime,
    "updateTime": assignment.updateTime,
    "creatorId": assignment.creatorId,
    "dueDate": assignment.dueDate,
    "attachments": attachmentStrings,
    "submissionAttachments": submissionStrings,
    "question": question,
    "points": assignment.points,
    "state": assignment.state,
    "isLate": assignment.isLate,
    "grade": assignment.grade,
    "answer": assignment.answer,
  });
  return "done";
}

void removeClassroomTasks(User user) async {
  //fetch all existing Firestore events added from Firefly
  QuerySnapshot tasks = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("toDo")
      .where("platform", isEqualTo: "GC")
      .get();

//create a list of these events
  List<DocumentSnapshot> tasksList = tasks.docs;

//loop through the list, deleting each event
  tasksList.forEach((event) {
    databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("toDo")
        .doc(event.id)
        .delete();
  });
}

Future<String> addCustomEvent(
    User firebaseUser,
    String name,
    String teacher,
    String location,
    List<bool> days,
    bool weekA,
    bool weekB,
    String start,
    String end) async {
  List<int> weekDays = new List<int>();

//if the location or teacher are blank, set their values to null
  location = location == "" ? null : location;
  teacher = teacher == "" ? null : teacher;

//get the days that the event occurs, and add it to the list of days
  for (int i = 0; i < 7; i++) {
    if (days[i]) {
      weekDays.add(i);
    }
  }

  for (int day in weekDays) {
    //this tries to get all events in the user's events collection where the class, teacher, set, location are the same (and the event was added by Firefly)
    QuerySnapshot matchingEvent = await databaseReference
        .collection("users")
        .doc(firebaseUser.uid)
        .collection("events")
        .where("name", isEqualTo: name)
        .where("platform", isEqualTo: "LH")
        .where("location", isEqualTo: location)
        .where("teacher", isEqualTo: teacher)
        .get();

    //if a matching event exists, then the current event's details are simply added to the event just found in the database (to stop too much duplicate data)
    //otherwise, a new event is added according to the given details
    if (matchingEvent.docs.isNotEmpty) {
      bool exists;

      //fetch the details of the event, including its ID
      DocumentSnapshot firestoreEvent = matchingEvent.docs.first;
      String docId = firestoreEvent.id;

      //fetch the times of the event already in the database, so that they can be modified accordingly
      List<dynamic> times = firestoreEvent.get("times");

      //set the document for the event in the database to the event with the afformentioned ID
      var docToUpdate = databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .doc(docId);

      //loop through each of the times of the event already in the database (each time is a string, in the format: "<day>, <start time>, <end time>, <weeks>")
      //i.e. if an event occurs every Monday on week A from 9am to 9:35am, it would be saved as: "0, 0900, 0935, A"
      //this is so that we can work out if an event only happens every other week (e.g. just on week A or B), or if it happens every week (on both weeks A & B)

      exists = false;
      for (int i = 0; i < times.length; i++) {
        //checks if the current time we've fetched from the array of times is the same as the timings for the event we want to add (excluding when it repeats)
        if (times[i].startsWith("$day, $start, $end")) {
          //if a matching time exists for the given event:

          //state that we have already added the event's timings
          exists = true;

          //check whe the event repeats. If it repeats on a week that differs from the week of the event we are currently adding (i.e. to stop duplicate timings), then enter the if statement

          //updates the timings field of the event we are editing. First the value in the timings array that matches is removed.
          await docToUpdate.update(<String, dynamic>{
            "times": FieldValue.arrayRemove(
                ["$day, $start, $end, ${times[i].split(", ")[3]}"])
          });

          String weeksToAdd;

//if the event occurs on both weeks, set the end of the times to be AB, otherwise set it to A or B respectively
          if ((weekA && (weekB || times[i].split(", ")[3] == "B")) ||
              (weekB && (weekA || times[i].split(", ")[3] == "A"))) {
            weeksToAdd = "AB";
          } else if (weekA) {
            weeksToAdd = "A";
          } else {
            weeksToAdd = "B";
          }

          //then the value in the array representing the repeats is re-added, according to the new timings.
          await docToUpdate.update(<String, dynamic>{
            "times": FieldValue.arrayUnion(["$day, $start, $end, $weeksToAdd"])
          });
        }
      }

      //if, having checked every time that the event occurs, there are none matching the time of the current event (exists is false), a new time is added to the event in the database.
      //this, by definition, would only repeat on the current week (although as we continue to loop through the web scraped events, repeats may be added as above)
      if (!exists) {
        //adds a new time to the event's timings field according to the format above
        await docToUpdate.update(<String, dynamic>{
          "times": FieldValue.arrayUnion(
              ["$day, $start, $end, ${weekA ? weekB ? "AB" : "A" : "B"}"])
        });
      }
    }
    //if no matching event exists:
    else {
      //add a new event document to the events collection for the user, with the event details. (Defined above)
      await databaseReference
          .collection("users")
          .doc(firebaseUser.uid)
          .collection("events")
          .add({
        "classSet": null,
        "location": location,
        "name": name,
        "platform": "LH",
        "teacher": teacher,
        //the times are set as an array of length 1, in the format used in the above "if" statement, so as to allow for more times to be added in the future
        "times": ["$day, $start, $end, ${weekA ? weekB ? "AB" : "A" : "B"}"]
      });
    }
  }
  return "done";
}

Future<Event> getEvent(User user, String id) async {
  //get an event object from its Firestore id
  DocumentSnapshot eventSnapshot = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("events")
      .doc(id)
      .get();

  return Event.fromFirestore(eventSnapshot);
}

Future<String> deleteEvent(User user, String id) async {
  //delete an event with the matching id
  databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("events")
      .doc(id)
      .delete();

  return "done";
}

Future<String> deleteData(User user, int type) async {
  //delete a user's data. If the type is 0, delete their event data. If it is 1, delete their tasks data, and if it is 2 delete all their data.
//if the type is 2, we have to delete events and tasks data as well so those two sections run too
  if (type == 0 || type == 2) {
    //set the last recorded weekA to null (as we have now got no events to fetch)
    databaseReference.collection("users").doc(user.uid).update({"weekA": null});

//create a list of the events in the user's events collection
    QuerySnapshot toDelete = await databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("events")
        .get();

    List<DocumentSnapshot> events = toDelete.docs.toList();

//loop through the list of events, deleting each one.
    for (DocumentSnapshot event in events) {
      databaseReference
          .collection("users")
          .doc(user.uid)
          .collection("events")
          .doc(event.id)
          .delete();
    }
  }
  if (type == 1 || type == 2) {
    //set the last updated time to now, as we don't want the tasks to be automatically refreshed (thus undoing the delete)
    databaseReference.collection("users").doc(user.uid).update({
      "lastChecked": DateTime.utc(DateTime.now().year, DateTime.now().month,
          DateTime.now().day, DateTime.now().hour, DateTime.now().minute)
    });

//get a list of the user's tasks in the Firestore db
    QuerySnapshot toDelete = await databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("toDo")
        .get();

    List<DocumentSnapshot> tasks = toDelete.docs.toList();

//loop through each task, deleting it.
    for (DocumentSnapshot task in tasks) {
      databaseReference
          .collection("users")
          .doc(user.uid)
          .collection("toDo")
          .doc(task.id)
          .delete();
    }
  }
  if (type == 2) {
    //delete the user's tannoy data
    //get a list of the user's tannoy notices in the Firestore db
    QuerySnapshot toDelete = await databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("tannoy")
        .get();

    List<DocumentSnapshot> tannoy = toDelete.docs.toList();

    //delete the tannoy data.
    databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("tannoy")
        .doc(tannoy[0].id)
        .delete();

    //delete the user's doc
    databaseReference.collection("users").doc(user.uid).delete();
  }
  return "done";
}

Future<bool> addTannoy(User user, String tannoyText) async {
  QuerySnapshot currentDoc = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("tannoy")
      .get();
  if (currentDoc.size == 1) {
    databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("tannoy")
        .doc(currentDoc.docs.first.id)
        .set({
      "modified": DateTime.now(),
      "notices": tannoyText
          .substring(0, tannoyText.length - 3)
          .replaceAll("\t", "")
          .replaceAll("    ", "")
    });
  } else {
    databaseReference
        .collection("users")
        .doc(user.uid)
        .collection("tannoy")
        .add({
      "modified": DateTime.now(),
      "notices": tannoyText
          .substring(0, tannoyText.length - 3)
          .replaceAll("\t", "")
          .replaceAll("    ", "")
    });
  }
  if (tannoyText == "") {
    return false;
  } else {
    return true;
  }
}

Future<bool> removeCurrentTannoy(User user) async {
  QuerySnapshot tannoyDocs = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("tannoy")
      .get();

  databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("tannoy")
      .doc(tannoyDocs.docs.first.id)
      .delete();

  return true;
}

Future<bool> tannoyRecentlyChecked(User user) async {
  QuerySnapshot tannoyDocs = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("tannoy")
      .get();

  if (tannoyDocs.size == 0) {
    return false;
  }

  DocumentSnapshot currentTannoy = tannoyDocs.docs.first;

  DateTime lastChecked = currentTannoy["modified"].toDate();

  if (lastChecked.isBefore(DateTime.utc(
      DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
    return false;
  } else {
    return true;
  }
}

Future<List<Notice>> getNotices(User user) async {
  List<Notice> notices = new List<Notice>();

  QuerySnapshot tannoyDocs = await databaseReference
      .collection("users")
      .doc(user.uid)
      .collection("tannoy")
      .get();

  if (tannoyDocs.size == 0) {
    return notices;
  }

  DocumentSnapshot currentTannoy = tannoyDocs.docs.first;

  List<String> rawDetails = currentTannoy["notices"].toString().split(":-:");

  for (int i = 0; i < rawDetails.length; i += 3) {
    notices.add(new Notice(
        title: rawDetails[i],
        author: rawDetails[i + 1],
        body: rawDetails[i + 2]));
  }
  return notices;
}

Future<bool> updateFirestoreWeek(User user, String week) async {
  //update the last weekA in the Firestore db. I.e., if this week is a week A, add the date of this Monday to the database, otherwise add the date of the monday prior.
  databaseReference.collection("users").doc(user.uid).update({
    "weekA": week == "A"
        ? DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: DateTime.now().weekday - 1))
        : DateTime.utc(
                DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .subtract(Duration(days: DateTime.now().weekday + 6))
  });
  return true;
}
