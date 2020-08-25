class Question {
  final String type;
  final List<String> options;

  Question({this.type, this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> o = [];
    String choices = json["choices"].toString();
    List<String> choicesList =
        choices.substring(1, choices.length - 1).split(', ');

    choicesList.forEach((choice) {
      o.add(choice.toString());
    });
    return Question(
      type: "Multiple Choice",
      options: o,
    );
  }
  void output() {
    int n = 1;
    options.forEach((element) {
      print("Option $n: $element");
      n++;
    });
  }
}
