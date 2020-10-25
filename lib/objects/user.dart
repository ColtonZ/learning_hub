//this is a class for a Google user account
class User {
  final String name;

  User({this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      //the only thing returned currently is the user's name
      name: json["name"]["fullName"],
    );
  }
}
