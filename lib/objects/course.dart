class Course {
  final String name;
  final String description;
  final String platform;
  final String id;
  final String status;

  Course({this.platform, this.id, this.name, this.description, this.status});

  factory Course.fromJson(Map<String, dynamic> json) {
    //returns the details of the course
    return Course(
      platform: "Google Classroom",
      id: json["id"],
      name: json["name"],
      description: json["descriptionHeading"] == null
          ? "This course has no description"
          : json["descriptionHeading"],
      status: json["courseState"],
    );
  }
}
