import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';
import '../constants/font.dart';

class FloatingAddButton extends StatelessWidget {
  const FloatingAddButton(
      {Key? key,
      required this.title,
      required this.marginBottom,
      required this.width})
      : super(key: key);
  final String title;
  final double width;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: width,
      // padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.only(bottom: marginBottom),
      decoration: const BoxDecoration(
        color: COLOR_GREEN,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(97, 110, 110, 110),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w700,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: COLOR_WHITE,
            ),
          ),
          const SizedBox(
            width: 1,
          ),
          const Icon(
            Icons.add,
            color: COLOR_WHITE,
          ),
        ],
      ),
    );
  }
}
