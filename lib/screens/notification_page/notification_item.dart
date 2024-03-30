import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/models/notification/notification_item_model.dart';
import 'package:management_app/widgets/text_custom.dart';

class NotificationItem extends StatelessWidget {
  const NotificationItem({
    Key? key,
    required this.data,
  }) : super(key: key);

  final NotificationItemModel data;

  List<TextSpan> _parseText(String message) {
    final List<TextSpan> spans = [];
    final regex = RegExp(r'(<strong>|<i>)(.*?)(<\/strong>|<\/i>)');

    final matches = regex.allMatches(message);
    int currentPosition = 0;

    for (var match in matches) {
      if (match.start > currentPosition) {
        spans.add(
            TextSpan(text: message.substring(currentPosition, match.start)));
      }

      final tag = match.group(1);
      final content = match.group(2);
      final closingTag = match.group(3);

      if (tag == '<strong>') {
        spans.add(TextSpan(
            text: content, style: TextStyle(fontWeight: FontWeight.bold)));
      } else if (tag == '<i>') {
        spans.add(TextSpan(
            text: content, style: TextStyle(fontStyle: FontStyle.italic)));
      }

      currentPosition = match.end;
    }

    if (currentPosition < message.length) {
      spans.add(TextSpan(text: message.substring(currentPosition)));
    }

    return spans;
  }

  @override
  Widget build(BuildContext context) {
    // print(bool.fromEnvironment(data['seen'].toString()));
    Icon iconType = const Icon(
      Icons.groups,
      color: COLOR_TEXT_MAIN,
    );
    // if (data['type'].toString() == 'comment') {
    //   iconType = const Icon(Icons.mode_comment, color: COLOR_TEXT_MAIN);
    // } else if (data['type'].toString() == 'file') {
    //   iconType = const Icon(Icons.upload_file_rounded, color: COLOR_TEXT_MAIN);
    // }
    return Container(
      padding: const EdgeInsets.only(left: 10, bottom: 10, top: 18),
      height: 90,
      decoration: const BoxDecoration(
        border: Border(
          bottom:
              BorderSide(width: 1, color: Color.fromARGB(255, 223, 223, 223)),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: COLOR_WHITE,
              border: Border.all(
                width: 1,
                color: COLOR_GRAY,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: iconType,
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            // Thay đổi này
            child: Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //message
                  Expanded(
                    flex: 3,
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                      text: TextSpan(
                        style: GoogleFonts.montserrat(
                          color: COLOR_BLACK,
                          fontSize: FONT_SIZE_NORMAL,
                          fontWeight: FontWeight.w500,
                        ),
                        children: _parseText(data.message!),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Thông báo",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: FONT_SIZE_NORMAL,
                        color: COLOR_TEXT_MAIN,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
