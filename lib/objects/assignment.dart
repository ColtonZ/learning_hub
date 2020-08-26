import 'dart:core';
import 'attachment.dart';
import 'question.dart';

class Assignment {
  final String title;
  final String description;
  final String id;
  final String status;
  final String type;
  final List<String> links;
  final DateTime creationTime;
  final DateTime updateTime;
  final String creatorId;
  final DateTime dueDate;
  final List<Attachment> attachments;
  final Question question;

  Assignment(
      {this.id,
      this.title,
      this.description,
      this.links,
      this.type,
      this.status,
      this.creationTime,
      this.creatorId,
      this.updateTime,
      this.dueDate,
      this.attachments,
      this.question});

  factory Assignment.fromJson(Map<String, dynamic> assignmentJson,
      Map<String, dynamic> submissionJson) {
    DateTime d;
    List<Attachment> a = [];
    Question q;
    //checks if the assignment has a due date. If it does, convert it into a DateTime object, otherwise return it as null
    try {
      d = DateTime(
          assignmentJson["dueDate"]["year"],
          assignmentJson["dueDate"]["month"],
          assignmentJson["dueDate"]["day"],
          assignmentJson["dueTime"]["hours"],
          assignmentJson["dueTime"]["minutes"]);
    } catch (error) {
      d = null;
    }

    try {
      var aList = assignmentJson["materials"] as List;
      aList.forEach((attachment) {
        a.add(Attachment.fromJson(attachment));
      });
    } catch (error) {
      a = [];
    }

    try {
      q = Question.fromJson(assignmentJson["multipleChoiceQuestion"]);
    } catch (error) {
      q = null;
    }

    //return the assignment using the previously given parameters
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

  void output() {
    print(
        "ID: $id | Title: $title | Description: $description | Status: $status");
  }
}
