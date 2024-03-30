import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/font.dart';
import '../../../../../constants/image_assets.dart';
import '../../../../../widgets/text_custom.dart';

class ReportProgressItem extends StatelessWidget {
  const ReportProgressItem({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(Icons.loop),
        const TextCustom(
          text: "Tiến độ ngày ..",
          color: COLOR_TEXT_MAIN,
          fontSize: FONT_SIZE_NORMAL,
          fontWeight: FontWeight.w600,
        ),
        IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: Image.asset(
              IC_EDIT,
              width: 24,
              height: 24,
            ),
            onPressed: () {})
      ],
    ));
  }
}
