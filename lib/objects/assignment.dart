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

  factory Assignment.fromJson(Map<String, dynamic> json) {
    DateTime d;
    try {
      d = DateTime(
          json["dueDate"]["year"],
          json["dueDate"]["month"],
          json["dueDate"]["day"],
          json["dueDate"]["year"],
          json["dueTime"]["hours"],
          json["dueTime"]["minutes"]);
    } catch (error) {
      d = null;
    }
    return Assignment(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      status: json["state"],
      type: json["workType"],
      creationTime: DateTime.parse(json["creationTime"]).toLocal(),
      updateTime: DateTime.parse(json["updateTime"]).toLocal(),
      creatorId: json["creatorUserId"],
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
