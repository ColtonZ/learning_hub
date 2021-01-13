//this is a question class for if a question is part of an assignment

class Question {
  final String type;
  final List<String> options;

  Question({this.type, this.options});

  factory Question.fromJson(Map<String, dynamic> json) {
    List<String> o = [];
    var choicesList = json["choices"] as List;

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
