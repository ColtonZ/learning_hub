import 'package:flutter/material.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';

class SettingsPage extends StatefulWidget {
  @override
  //initialises the settings page state
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create(context, "Settings Page"),
      body: Text("Settings Page"),
      bottomNavigationBar: CustomNavigationBar.create(context, 4),
    );
  }
}
