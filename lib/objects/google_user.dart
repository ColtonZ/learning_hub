class GoogleUser {
  final String name;

  GoogleUser({this.name});

  factory GoogleUser.fromJson(Map<String, dynamic> json) {
    return GoogleUser(
      name: json["name"]["fullName"],
    );
  }

  void output() {
    print("Name: $name");
  }
}
