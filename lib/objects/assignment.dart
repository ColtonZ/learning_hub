import 'package:cloud_firestore/cloud_firestore.dart';

import 'dart:core';
import 'package:equatable/equatable.dart';

import 'attachment.dart';
import 'question.dart';

class Assignment extends Equatable {
  //each assignment can have a lot of properties!
  final String url;
  final String platform;
  final String courseId;
  final String courseName;
  final String submissionId;
  final String title;
  final String description;
  final String id;
  final String status;
  final String type;
  final DateTime creationTime;
  final DateTime updateTime;
  final String creatorId;
  final DateTime dueDate;
  final List<Attachment> attachments;
  final List<Attachment> submissionAttachments;
  final Question question;
  final int points;
  final String state;
  final bool isLate;
  final int grade;
  final String answer;

  Assignment({
    this.url,
    this.platform,
    this.courseId,
    this.courseName,
    this.submissionId,
    this.id,
    this.title,
    this.description,
    this.type,
    this.status,
    this.creationTime,
    this.creatorId,
    this.updateTime,
    this.dueDate,
    this.attachments,
    this.submissionAttachments,
    this.question,
    this.points,
    this.state,
    this.isLate,
    this.grade,
    this.answer,
  });

//convert the JSON of an assignment into an assignment object
  factory Assignment.fromJson(
      String courseName,
      String platform,
      Map<String, dynamic> assignmentJson,
      Map<String, dynamic> submissionJson) {
    DateTime d;
    List<Attachment> a = [];
    List<Attachment> s = [];
    int p;
    Question q;
    bool l;
    int g;
    //checks if the assignment has a due date. If it does, convert it into a DateTime object, otherwise return it as null
    //some tasks only have a due day and not a time set. If this is the case, the time is returned as midnight.
    try {
      d = DateTime(
          assignmentJson["dueDate"]["year"],
          assignmentJson["dueDate"]["month"],
          assignmentJson["dueDate"]["day"],
          assignmentJson["dueTime"]["hours"] == null
              ? 00
              : assignmentJson["dueTime"]["hours"],
          assignmentJson["dueTime"]["minutes"] == null
              ? 00
              : assignmentJson["dueTime"]["minutes"]);
    } catch (error) {
      d = null;
    }

//checks if the assignment has a max grade. If not, return null
    try {
      p = assignmentJson["maxPoints"];
    } catch (error) {
      p = null;
    }

//creates a list of attachments for each task. If an error is thrown, this means that the task has no attachment, and so an empty list is returned.
    try {
      var aList = assignmentJson["materials"] as List;
      aList.forEach((attachment) {
        //this converts each attachment JSON into an actual attachment object
        Attachment att = Attachment.fromJson(attachment);
        //this removes all attachments which start with [Template] as these are files made by Google for each task
        if (att.title == null || !att.title.startsWith("[Template]")) {
          a.add(att);
        }
      });
    } catch (error) {}

//attempts to create a list of attachments which have been submitted by a student. If this fails, it means that the student has not submitted anything, and so the attachments list is empty.
    try {
      var sList = submissionJson["assignmentSubmission"]["attachments"] as List;
      sList.forEach((attachment) {
        s.add(Attachment.fromJson(attachment));
      });
    } catch (error) {}

//if the assignment is a multiple choice question, add a Question object, otherwise return a null object (an error is thrown if the assignment is not a multiple choice question, which is caught)
    try {
      q = Question.fromJson(assignmentJson["multipleChoiceQuestion"]);
    } catch (error) {
      q = null;
    }

//if the assignment has a grade assigned, return the grade, otherwise return the grade as null
    try {
      g = submissionJson["assignedGrade"];
    } catch (error) {
      g = null;
    }

//if the assignment is late, return that it's late (i.e. return true, as the submissionJson["late"] will be true if late), otherwise return null
    try {
      l = submissionJson["late"];
    } catch (error) {
      l = null;
    }

    //return the assignment using the previously given parameters
    //if the assignment has student submissions, return that, otherwise return just the assignment (and thus an assignment with fewer properties)
    if (submissionJson != null) {
      return Assignment(
        url: assignmentJson["alternateLink"],
        platform: platform,
        courseName: courseName,
        courseId: assignmentJson["courseId"],
        id: assignmentJson["id"],
        title: assignmentJson["title"],
        description: assignmentJson["description"],
        status: assignmentJson["state"],
        type: assignmentJson["workType"],
        //converts the creation time and update time of the assignment to the user's local time
        creationTime: DateTime.parse(assignmentJson["creationTime"]).toLocal(),
        updateTime: DateTime.parse(assignmentJson["updateTime"]).toLocal(),
        creatorId: assignmentJson["creatorUserId"],
        dueDate: d,
        attachments: a,
        submissionAttachments: s,
        question: q,
        points: p,
        state: submissionJson["state"],
        submissionId: submissionJson["id"],
        isLate: l,
        grade: g,
        //if the assignment is a short answer or multiple choice question, the answer is the answer that the student gave to the question. Otherwise, the answer is null, as the assignment is not a question.
        answer: assignmentJson["workType"] == "SHORT_ANSWER_QUESTION"
            ? submissionJson["shortAnswerSubmission"]["answer"]
            : assignmentJson["workType"] == "MULTIPLE_CHOICE_QUESTION"
                ? submissionJson["multipleChoiceSubmission"]["answer"]
                : null,
      );
    } else {
      return Assignment(
        url: assignmentJson["alternateLink"],
        platform: platform,
        courseName: courseName,
        courseId: assignmentJson["courseId"],
        id: assignmentJson["id"],
        title: assignmentJson["title"],
        description: assignmentJson["description"],
        status: assignmentJson["state"],
        type: assignmentJson["workType"],
        //converts the creation time and update time of the assignment to the user's local time
        creationTime: DateTime.parse(assignmentJson["creationTime"]).toLocal(),
        updateTime: DateTime.parse(assignmentJson["updateTime"]).toLocal(),
        creatorId: assignmentJson["creatorUserId"],
        dueDate: d,
        attachments: a,
        question: q,
      );
    }
  }

//convert a Firestore doc into an assignment object
  factory Assignment.fromFirestore(DocumentSnapshot document) {
    List<Attachment> a = [];
    List<Attachment> s = [];
    Question q;

    Map<String, dynamic> documentMap = document.data();

//creates a list of attachments for each task. If an error is thrown, this means that the task has no attachment, and so an empty list is returned.
    try {
      a = [];
      (documentMap["attachments"] as List).forEach((attachment) {
        //this converts each attachment string into an actual attachment object
        Attachment att = Attachment.fromList(attachment.toString().split(", "));
        //this removes all attachments which start with [Template] as these are files made by Google for each task
        if (att.title == null || !att.title.startsWith("[Template]")) {
          a.add(att);
        }
      });
    } catch (error) {}

//attempts to create a list of attachments which have been submitted by a student. If this fails, it means that the student has not submitted anything, and so the attachments list is empty.
    try {
      s = [];
      (documentMap["submissionAttachments"] as List).forEach((attachment) {
        //this converts each attachment string into an actual attachment object
        Attachment att = Attachment.fromList(attachment.toString().split(", "));
        //this removes all attachments which start with [Template] as these are files made by Google for each task
        if (att.title == null || !att.title.startsWith("[Template]")) {
          s.add(att);
        }
      });
    } catch (error) {}

//if the assignment is a multiple choice question, add a Question object, otherwise return a null object (an error is thrown if the assignment is not a multiple choice question, which is caught)
    try {
      q = documentMap["question"].toString() != "null"
          ? Question.fromList(documentMap["question"].toString().split(":-:"))
          : null;
    } catch (error) {
      q = null;
    }

    return Assignment(
      url: documentMap["url"],
      platform: documentMap["platform"],
      courseName: documentMap["courseName"],
      courseId: documentMap["courseId"],
      id: documentMap["id"],
      title: documentMap["title"],
      description: documentMap["description"],
      status: documentMap["state"],
      type: documentMap["type"],
      //converts the creation time and update time of the assignment to the user's local time
      creationTime: documentMap["creationTime"] == null
          ? null
          : documentMap["creationTime"].toDate(),
      updateTime: documentMap["updateTime"] == null
          ? null
          : documentMap["updateTime"].toDate(),
      creatorId: documentMap["creatorId"],
      dueDate: documentMap["dueDate"].toDate(),
      attachments: a,
      submissionAttachments: s,
      question: q,
      points: documentMap["maxPoints"],
      state: documentMap["state"],
      isLate: documentMap["late"],
      grade: documentMap["assignedGrade"],
      submissionId: documentMap["submissionId"],
      //if the assignment is a short answer or multiple choice question, the answer is the answer that the student gave to the question. Otherwise, the answer is null, as the assignment is not a question.
      answer: documentMap["answer"],
    );
  }

  factory Assignment.createCustom(
      String title, String description, String subject, DateTime dueDate) {
    //allows for a user to create a custom assignment. If this happens, the assignment must be from Learning Hub.
    return Assignment(
        platform: "LH",
        title: title,
        description: description == "" ? null : description,
        courseName:
            subject == "" ? "Personal Task" : "Personal Task • $subject",
        dueDate: dueDate,
        creationTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        updateTime: DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day),
        type: "PERSONAL");
  }
  List<Object> get props {
    return [
      url,
      platform,
      courseId,
      courseName,
      submissionId,
      title,
      description,
      id,
      status,
      type,
      creationTime,
      updateTime,
      creatorId,
      dueDate,
      attachments,
      submissionAttachments,
      question,
      points,
      state,
      isLate,
      grade,
      answer
    ];
  }
}
