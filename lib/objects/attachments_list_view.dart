import 'package:flutter/material.dart';
import 'attachment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:learning_hub/theming.dart';

class AttachmentsListView {
  //creates a list view
  static ListView create(
      BuildContext context, String description, List<Attachment> attachments) {
    return ListView.builder(
      itemCount: (attachments.length * 2 + 1),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or attachment details if even (i.e. returns a divider every other one)
        if (item == 0) {
          return _buildFirstTile(context, description, attachments.isNotEmpty);
        } else if (item.isEven) {
          return Divider();
        }
        final index = (item - 1) ~/ 2;
        //creates a list tile for the attachment
        return _buildCustomListRow(context, attachments[index]);
      },
    );
  }

//builds the list tile for the attachment
  static Widget _buildFirstTile(
      BuildContext context, String description, bool attachments) {
    return ListTile(
      title: Column(
        children: [
          Text(
            description,
            style: paragraph1Style,
          ),
          Container(
            height: MediaQuery.of(context).size.height / 52,
          ),
          attachments == true
              ? Row(children: [
                  Expanded(
                      child: Text(
                    "Attachments:",
                    style: subtitleStyle,
                  ))
                ])
              : Text(""),
        ],
      ),
    );
  }

//builds the list tile for the attachment
  static Widget _buildCustomListRow(
      BuildContext context, Attachment attachment) {
    return ListTile(
        title: Row(
          children: <Widget>[
            Container(
              child: FittedBox(
                fit: BoxFit.contain,
                child: attachment.type == "file"
                    ? Icon(Icons.insert_drive_file)
                    : attachment.type == "link"
                        ? Icon(Icons.link)
                        : attachment.type == "YouTube video"
                            ? Icon(Icons.play_circle_outline)
                            : attachment.type == "form"
                                ? Icon(Icons.format_list_bulleted)
                                : Icon(Icons.attach_file),
              ),
              width: MediaQuery.of(context).size.width / 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width / 50,
            ),
            Expanded(
                child: Text(
              attachment.title != null
                  ? attachment.title
                  : "This ${attachment.type} has no title",
              style: header3Style,
            ))
          ],
        ),
        onTap: () {
          launch(attachment.link);
        });
  }
}
