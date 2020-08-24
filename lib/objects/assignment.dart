//import 'assignment_material.dart';
//import 'backend.dart';

class Assignment {
  final String title;
  final String description;
  final String id;
  final String status;
  final String type;
  final List<String> links;
  final String creationTime;
  final String updateTime;
  final String creatorId;
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
      this.updateTime});

  factory Assignment.fromJson(Map<String, dynamic> json) {
    return Assignment(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      status: json["state"],
      type: json["workType"],
      creationTime: json["creationTime"],
      updateTime: json["updateTime"],
      creatorId: json["creatorUserId"],
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
