//this is a question class for if a question is part of an assignment
class Question {
  final String type;
  final List<String> options;

  Question({this.type, this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> o = [];
    String choices = json["choices"].toString();
    //converts the json of the possible question choices to a list
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
}
