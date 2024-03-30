import 'package:flutter/material.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../widgets/text_custom.dart';

void showCancelDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext _context) {
      return AlertDialog(
        title: const TextCustom(
          text: 'Có chắc chắn muốn huỷ?',
          fontSize: FONT_SIZE_NORMAL_TITLE,
          fontWeight: FontWeight.w600,
          color: COLOR_BLACK,
        ),
        content: const TextCustom(
          text:
              'Khi huỷ mọi dữ liệu chưa được lưu sẽ bị mất. Bạn có chắc chắn muốn huỷ?',
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w500,
          color: COLOR_TEXT_MAIN,
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const TextCustom(
              text: 'Không',
              fontSize: FONT_SIZE_SMALL_TITLE,
              fontWeight: FontWeight.w600,
              color: COLOR_LATE,
            ),
            onPressed: () {
              Navigator.of(_context).pop();
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const TextCustom(
              text: 'Có',
              fontSize: FONT_SIZE_SMALL_TITLE,
              fontWeight: FontWeight.w600,
              color: COLOR_DONE,
            ),
            onPressed: () {
              // Navigator.of(context).pop();
              Navigator.of(_context).pop();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
