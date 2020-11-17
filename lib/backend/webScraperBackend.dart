import 'package:web_scraper/web_scraper.dart';

//https://medium.com/flutter/the-power-of-webviews-in-flutter-a56234b57df2
//https://medium.com/flutter-community/inappwebview-the-real-power-of-webviews-in-flutter-c6d52374209d

Future<String> getTimetable() async {
  final webScraper = WebScraper("https://intranet.stpaulsschool.org.uk");
  if (await webScraper.loadWebPage('/dashboard')) {
    // List<Map<String, dynamic>> elements = webScraper.printWrapped(elements);
  }
}
