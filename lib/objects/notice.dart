import 'package:equatable/equatable.dart';

//this is a notice class for each tannoy notice
class Notice extends Equatable {
  final String title;
  final String body;

  Notice({this.title, this.body});

  List<Object> get props {
    return [title, body];
  }
}
