//this is a class for each event
class Event {
  //this just says which variables are needed for each event object
  final String subject;
  final String room;
  final String teacher;
  final String time;

  //constructor
  Event({this.subject, this.room, this.teacher, this.time});

  //creates a event object, given a line from a text file
  factory Event.fromString(String string) {
    var details = string.split(', ');
    return Event(
      //return the event's subject, room, teacher and time, having taken in the event details as a comma separated list
      subject: details[0],
      room: details[1],
      teacher: details[2],
      time: details[3],
    );
  }
}
