import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskStateItem extends StatelessWidget {
  const TaskStateItem({super.key, required this.value});

  final Map<String, Object> value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 13,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
        color: value['color'] as Color,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value['text'] as String,
                style: GoogleFonts.montserrat(
                    color: COLOR_WHITE,
                    fontWeight: FontWeight.w700,
                    fontSize: FONT_SIZE_SMALL_TITLE),
              ),
              Text(
                (value['quantity'] as int).toString(),
                style: GoogleFonts.montserrat(
                    color: COLOR_WHITE,
                    fontWeight: FontWeight.w700,
                    fontSize: 32),
              )
            ],
          ),
          Image.asset(
            value['icon'] as String,
            width: 36,
          ),
        ],
      ),
    );
  }
}
