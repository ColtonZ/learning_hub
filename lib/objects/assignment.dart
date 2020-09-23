import 'dart:core';
import 'attachment.dart';
import 'question.dart';

class Assignment {
  //each assignment can have a lot of properties!
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
  final String points;
  final String state;
  final bool isLate;
  final int grade;
  final String answer;

  Assignment({
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

  factory Assignment.fromJson(Map<String, dynamic> assignmentJson,
      Map<String, dynamic> submissionJson) {
    DateTime d;
    List<Attachment> a = [];
    List<Attachment> s = [];
    String p;
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
        if (!att.title.startsWith("[Template]")) {
          a.add(att);
        }
      });
    } catch (error) {
      a = [];
    }

//attempts to create a list of attachments which have been submitted by a student. If this fails, it means that the student has not submitted anything, and so the attachments list is empty.
    try {
      var sList = submissionJson["assignmentSubmission"]["attachments"] as List;
      sList.forEach((attachment) {
        s.add(Attachment.fromJson(attachment));
      });
    } catch (error) {
      s = [];
    }

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
        id: assignmentJson["id"],
        title: assignmentJson["title"],
        description: assignmentJson["description"],
        status: assignmentJson["state"],
        type: assignmentJson["workType"],
        creationTime: DateTime.parse(assignmentJson["creationTime"]).toLocal(),
        updateTime: DateTime.parse(assignmentJson["updateTime"]).toLocal(),
        creatorId: assignmentJson["creatorUserId"],
        dueDate: d,
        attachments: a,
        submissionAttachments: s,
        question: q,
        points: p,
        state: submissionJson["state"],
        isLate: l,
        grade: g,
        answer: assignmentJson["workType"] == "SHORT_ANSWER_QUESTION"
            ? submissionJson["shortAnswerSubmission"]["answer"]
            : assignmentJson["workType"] == "MULTIPLE_CHOICE_QUESTION"
                ? submissionJson["multipleChoiceSubmission"]["answer"]
                : null,
      );
    } else {
      return Assignment(
        id: assignmentJson["id"],
        title: assignmentJson["title"],
        description: assignmentJson["description"],
        status: assignmentJson["state"],
        type: assignmentJson["workType"],
        creationTime: DateTime.parse(assignmentJson["creationTime"]).toLocal(),
        updateTime: DateTime.parse(assignmentJson["updateTime"]).toLocal(),
        creatorId: assignmentJson["creatorUserId"],
        dueDate: d,
        attachments: a,
        question: q,
      );
    }
  }
}
