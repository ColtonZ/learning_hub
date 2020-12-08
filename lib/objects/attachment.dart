import 'dart:core';

class Attachment {
  final String title;
  final String link;
  final String id;
  final String thumbnail;
  final String type;

  Attachment({this.id, this.title, this.link, this.thumbnail, this.type});

//checks the type of attachment. Dependent on the type, it returns different things, but will always return a title and link (unless there is an error)
  factory Attachment.fromJson(Map<String, dynamic> json) {
    if (json["driveFile"] != null) {
      //for student submissions, they do not have the second "driveFile", so account for the fact of the different JSONs
      if (json["driveFile"]["driveFile"] != null) {
        return Attachment(
          id: json["driveFile"]["driveFile"]["id"],
          title: json["driveFile"]["driveFile"]["title"],
          link: json["driveFile"]["driveFile"]["alternateLink"],
          thumbnail: json["driveFile"]["driveFile"]["thumbnailUrl"],
          type: "file",
        );
      } else {
        return Attachment(
          id: json["driveFile"]["id"],
          title: json["driveFile"]["title"],
          link: json["driveFile"]["alternateLink"],
          thumbnail: json["driveFile"]["thumbnailUrl"],
          type: "file",
        );
      }
      //if the attachment is a link, return the attachment in a link format
    } else if (json["link"] != null) {
      return Attachment(
        title: json["link"]["title"],
        link: json["link"]["url"],
        thumbnail: json["link"]["thumbnailUrl"],
        type: "link",
      );
      //if the attachment is a YouTube video, return the attachment in a YouTube video format
    } else if (json["youtubeVideo"] != null) {
      return Attachment(
        id: json["youtubeVideo"]["id"],
        title: json["youtubeVideo"]["title"],
        link: json["youtubeVideo"]["alternateLink"],
        thumbnail: json["youtubeVideo"]["thumbnailUrl"],
        type: "YouTube",
      );
      //if the attachment is a form, return the attachment in a form format
    } else if (json["form"] != null) {
      return Attachment(
        title: json["form"]["title"],
        link: json["form"]["formUrl"],
        thumbnail: json["form"]["thumbnailUrl"],
        type: "form",
      );
      //if the attachment is none of the above, just return the type as "other"
    } else {
      return Attachment(
        type: "other",
      );
    }
  }
  factory Attachment.fromList(List<String> list) {
    //builds an attachment from a list of the attachment's properties
    return Attachment(
      id: list[0] == "null" ? null : list[0],
      title: list[1] == "null" ? null : list[1],
      link: list[2] == "null" ? null : list[2],
      thumbnail: list[3] == "null" ? null : list[3],
      type: list[4] == "null" ? null : list[4],
    );
  }
}
