class Course {
  final String name;
  final String description;
  final String platform;
  final String id;
  final String status;

  Course({this.platform, this.id, this.name, this.description, this.status});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      platform: "Google Classroom",
      id: json["id"],
      name: json["name"],
      description: json["descriptionHeading"],
      status: json["courseState"],
    );
  }

  /*void output() {
    print(
        "Platform: $platform | ID: $id | Name: $name | Description: $description | Status: $status");
  }*/
}
