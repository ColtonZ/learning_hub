//this is a question class for if a question is part of an assignment
class Question {
  final String type;
  final List<String> options;

  Question({this.type, this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> o = [];
    String choices = json["choices"].toString();
    //converts the json of the possible question choices to a list, by removing the first and last characters ("[" and "]") and splitting at each comma followed by a space
    List<String> choicesList =
        choices.substring(1, choices.length - 1).split(', ');

//creates a list of possible choices to select from the question
    choicesList.forEach((choice) {
      o.add(choice.toString());
    });
    return Question(
      type: "Multiple Choice",
      options: o,
    );
  }

  factory Question.fromList(List<String> list) {
    return Question(
      type: "Multiple Choice",
      options: list,
    );
  }
}
