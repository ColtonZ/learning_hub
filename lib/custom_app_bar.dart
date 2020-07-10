import 'package:flutter/material.dart';

class CustomAppBar {
  //creates a new app bar with the given title to provide consistency
  static AppBar create(BuildContext context, String title) {
    return new AppBar(
      title: Text(title),
    );
  }
}
