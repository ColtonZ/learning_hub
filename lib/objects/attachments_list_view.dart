import 'package:flutter/material.dart';
import 'attachment.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:learning_hub/theming.dart';

class AttachmentsListView {
  //creates a list view
  static ListView create(
      BuildContext context, String description, List<Attachment> attachments) {
    return ListView.builder(
      itemCount: (attachments.length * 2 + 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or attachment details if even (i.e. returns a divider every other one)
        //however, the first and last tiles are different (see below)
        if (item == 0) {
          return _buildFirstTile(context, description, attachments.isNotEmpty);
        }
        if (item == attachments.length * 2 + 1) {
          return _buildLastTile(context);
        } else if (item.isOdd) {
          return Divider();
        }
        final index = (item - 2) ~/ 2;
        //creates a list tile for the attachment
        return _buildCustomListRow(context, attachments[index]);
      },
    );
  }

//builds the first list tiles as the description of the task and then a header of the attachments section
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
          //returns a header for attachments if there are any - no header otherwise
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

//builds the last tile as just a blank container - to provide padding for the slide up panel
  static Widget _buildLastTile(BuildContext context) {
    return ListTile(
      title: Container(
        height: MediaQuery.of(context).size.height / 10,
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
                //checks the type of attachment, and gives it an icon accordingly
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
                //returns the attachment title
                child: Text(
              attachment.title != null
                  ? attachment.title
                  : "This ${attachment.type} has no title",
              style: header3Style,
            ))
          ],
        ),
        //opens a link to the attachment when you click on it
        onTap: () {
          launch(attachment.link);
        });
  }
}
