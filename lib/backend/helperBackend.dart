void printWrapped(String text) {
  //prints out text if over 800 characters long by splitting into 800 character chunks (this is the default limit for the terminal)
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}
