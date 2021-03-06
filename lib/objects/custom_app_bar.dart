import 'package:flutter/material.dart';

import '../theming.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final bool reload;

  //https://stackoverflow.com/questions/52678469/the-appbardesign-cant-be-assigned-to-the-parameter-type-preferredsizewidget

  @override
  //this ensures that the size of the app bat is normal - and not disproportionate to the rest of the page
  Size get preferredSize => const Size.fromHeight(56);

  CustomAppBar({this.title, this.reload});

  @override
  CustomAppBarState createState() => CustomAppBarState();
}

//details the looks of the appbar
class CustomAppBarState extends State<CustomAppBar> {
  AppBar build(BuildContext context) {
    String title = widget.title;
    bool reload = widget.reload;
    return new AppBar(
      actions: [
        reload
            ? Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                child: IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/");
                  },
                ),
              )
            : Container(),
      ],
      title: Text(title, style: pageTitleStyle),
      backgroundColor: Theme.of(context).accentColor,
    );
  }
}
