import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';

import '../../../constants/font.dart';

class ReportItem extends StatelessWidget {
  const ReportItem({Key? key, required this.data}) : super(key: key);

  final Map<String, String> data;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
          color: COLOR_CARD_BACKGROUND,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data['name']!,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_BIG,
              color: COLOR_BLACK,
            ),
          ),
          const SizedBox(
            height: 14,
          ),
          Row(
            children: [
              Image.asset(
                'lib/assets/images/home_page/calendar_icon.png',
                width: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                data['date']!,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_TEXT_MAIN,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Image.asset(
                'lib/assets/images/home_page/user_icon.png',
                width: 14,
              ),
              const SizedBox(
                width: 6,
              ),
              Text(
                data['reporter']!,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_TEXT_MAIN,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
