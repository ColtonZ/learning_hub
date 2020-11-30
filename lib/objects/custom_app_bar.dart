import 'package:flutter/material.dart';

import '../theming.dart';

class CustomAppBar {
  //creates a new app bar with the given title to provide consistency
  static AppBar create(BuildContext context, String title) {
    return new AppBar(
      title: Text(title, style: pageTitleStyle),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
