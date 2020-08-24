//import 'assignment_material.dart';
//import 'backend.dart';

class GoogleUser {
  final String name;

  GoogleUser({this.name});

  factory GoogleUser.fromJson(Map<String, dynamic> json) {
    return GoogleUser(
      name: json["name"]["fullName"],
      //materials: json["materials"],
    );
  }

  void output() {
    print("Name: $name");
    //materials.forEach((material) {
    //material.output();
    //});
  }
}
