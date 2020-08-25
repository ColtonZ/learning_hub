import 'package:flutter/material.dart';
import 'attachment.dart';
import 'package:url_launcher/url_launcher.dart';

class AttachmentsListView {
  //creates a list view
  static ListView create(BuildContext context, List<Attachment> attachments) {
    return ListView.builder(
      itemCount: (attachments.length * 2),
      //half the items will be dividers, the other will be list tiles
      padding: const EdgeInsets.all(8.0),
      itemBuilder: (context, item) {
        //returns a divider if odd, or attachment details if even (i.e. returns a divider every other one)
        if (item.isOdd) {
          return Divider();
        }
        final index = item ~/ 2;
        //creates a list tile for the attachment
        return _buildCustomListRow(context, attachments[index]);
      },
    );
  }

//builds the list tile for the attachment
  static Widget _buildCustomListRow(
      BuildContext context, Attachment attachment) {
    return ListTile(
        title: Text(attachment.link),
        onTap: () {
          launch(attachment.link);
        });
  }

//defines that when you tap on the list tile, it will push the attachment page for that attachment
/*  static void _pushAttachment(
    String link,
  ) {}*/
}
