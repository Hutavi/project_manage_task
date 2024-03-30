import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';

import '../constants/font.dart';

class QuickCreateItem extends StatefulWidget {
  const QuickCreateItem({Key? key, required this.value}) : super(key: key);

  final Map<String, String> value;
  @override
  _QuickCreateItemState createState() => _QuickCreateItemState();
}

class _QuickCreateItemState extends State<QuickCreateItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: COLOR_TEXT_MAIN, borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            widget.value['icon']!,
            width: 28,
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            widget.value['title']!,
            style: GoogleFonts.montserrat(
              color: COLOR_WHITE,
              fontSize: FONT_SIZE_NORMAL,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
