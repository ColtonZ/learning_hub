//this is a class for a Google user account
class GoogleUser {
  final String name;

  GoogleUser({this.name});

  factory GoogleUser.fromJson(Map<String, dynamic> json) {
    return GoogleUser(
      //the only thing returned currently is the user's name
      name: json["name"]["fullName"],
    );
  }
}
