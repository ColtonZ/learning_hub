import 'package:flutter/material.dart';
import '../objects/custom_navigation_bar.dart';
import '../objects/custom_app_bar.dart';

class TannoyPage extends StatefulWidget {
  @override
  //initialises the tannoy page state
  TannoyPageState createState() => TannoyPageState();
}

class TannoyPageState extends State<TannoyPage> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.create(context, "Tannoy Page"),
      body: Text("Tannoy Page"),
      bottomNavigationBar: CustomNavigationBar.create(context, 3),
    );
  }
}
