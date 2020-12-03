import 'package:flutter/material.dart';

import '../theming.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool reload;

  //https://stackoverflow.com/questions/52678469/the-appbardesign-cant-be-assigned-to-the-parameter-type-preferredsizewidget

  @override
  Size get preferredSize => const Size.fromHeight(56);

  CustomAppBar({this.title, this.reload});

  @override
  CustomAppBarState createState() => CustomAppBarState();
}

//details the looks of the page
class CustomAppBarState extends State<CustomAppBar> {
  AppBar build(BuildContext context) {
    String title = widget.title;
    return new AppBar(
      title: Text(title, style: pageTitleStyle),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
