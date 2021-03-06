import 'package:equatable/equatable.dart';

class Course extends Equatable implements Comparable<Course> {
  final String name;
  final String description;
  final String platform;
  final String id;
  final String status;
  final String url;

  Course(
      {this.platform,
      this.id,
      this.name,
      this.description,
      this.status,
      this.url});

  factory Course.fromJson(Map<String, dynamic> json) {
    //returns the details of the course
    return Course(
      platform: "Google Classroom",
      id: json["id"],
      name: json["name"],
      //if the course has no description, set the course's description to be: "This course has no description" for future use
      description: json["descriptionHeading"] == null
          ? "This course has no description"
          : json["descriptionHeading"],
      status: json["courseState"],
      url: json["alternateLink"],
    );
  }

//defines how to compare courses to each other (for sorting a list of courses)
  int compareTo(Course other) {
    return name.compareTo(other.name);
  }

  List<Object> get props {
    return [name, description, platform, id, status, url];
  }
}
