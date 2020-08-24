//import 'assignment_material.dart';
//import 'backend.dart';
import 'dart:core';

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
  //final String materials;

  Assignment(
      {this.id,
      this.title,
      this.description,
      this.links,
      //this.materials,
      this.type,
      this.status,
      this.creationTime,
      this.creatorId,
      this.updateTime,
      this.dueDate});

  factory Assignment.fromJson(Map<String, dynamic> assignmentJson,
      Map<String, dynamic> submissionJson) {
    DateTime d;
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
      //materials: json["materials"],
    );
  }

  void output() {
    print(
        "ID: $id | Title: $title | Description: $description | Status: $status");
    //materials.forEach((material) {
    //material.output();
    //});
  }
}
