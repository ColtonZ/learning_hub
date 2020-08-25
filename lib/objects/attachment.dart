import 'dart:core';

class Attachment {
  final String title;
  final String link;
  final String id;
  final String thumbnail;

  Attachment({this.id, this.title, this.link, this.thumbnail});

  factory Attachment.fromJson(Map<String, dynamic> json) {
    if (json["driveFile"] != null) {
      return Attachment(
        id: json["driveFile"]["driveFile"]["id"],
        title: json["driveFile"]["driveFile"]["title"],
        link: json["driveFile"]["driveFile"]["alternateLink"],
        thumbnail: json["driveFile"]["driveFile"]["thumbnailUrl"],
      );
    } else if (json["link"] != null) {
      return Attachment(
        title: json["link"]["title"],
        link: json["link"]["url"],
        thumbnail: json["link"]["thumbnailUrl"],
      );
    } else if (json["youtubeVideo"] != null) {
      return Attachment(
        id: json["youtubeVideo"]["id"],
        title: json["youtubeVideo"]["title"],
        link: json["youtubeVideo"]["alternateLink"],
        thumbnail: json["youtubeVideo"]["thumbnailUrl"],
      );
    } else if (json["form"] != null) {
      //return the assignment using the previously given parameters
      return Attachment(
        link: json["form"]["formUrl"],
      );
    } else {
      return Attachment();
    }
  }

  void output() {
    print("ID: $id | Title: $title | Link: $link | Thumbnail: $thumbnail");
  }
}
