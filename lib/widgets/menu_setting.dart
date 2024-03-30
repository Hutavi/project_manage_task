import 'package:flutter/material.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../constants/color.dart';
import '../constants/font.dart';
import '../constants/image_assets.dart';

class MenuSetting extends StatelessWidget {
  final Function(String) onItemSelected;

  const MenuSetting({
    Key? key,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      child: Row(
        children: [
          Image.asset(
            IC_EDIT,
            width: 20,
          ),
          const SizedBox(
            width: 5,
          ),
        ],
      ),
      onSelected: (value) {
        onItemSelected(value);
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "Chỉnh sửa",
          child: const TextCustom(
            text: 'Chỉnh sửa',
            color: COLOR_BLACK,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            fontWeight: FontWeight.w600,
          ),
        ),
        PopupMenuItem<String>(
          value: "Xoá",
          child: const TextCustom(
            text: 'Xoá',
            color: COLOR_BLACK,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
