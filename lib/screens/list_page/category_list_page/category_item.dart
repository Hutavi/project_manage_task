import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key, required this.data}) : super(key: key);

  final Map<String, String> data;
  @override
  Widget build(BuildContext context) {
    String progress = data['progress']!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: COLOR_CARD_BACKGROUND,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
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
                  height: 12,
                ),
                Row(
                  children: [
                    Image.asset(
                      'lib/assets/images/home_page/options_dialog/project_icon.png',
                      width: 14,
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Text(
                      data['project']!,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: FONT_SIZE_NORMAL,
                        color: COLOR_TEXT_MAIN,
                      ),
                    )
                  ],
                )
              ],
            ),
            Container(
              margin: const EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: COLOR_WHITE,
                border: Border.all(width: 1, color: COLOR_BLACK),
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              child: Text(
                'Tiến độ: $progress%',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_BLACK,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset('lib/assets/images/home_page/user_icon.png',
                      width: 14),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    data['owner']!,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_NORMAL,
                      color: COLOR_TEXT_MAIN,
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset(
                      'lib/assets/images/home_page/project_task_list_icon.png',
                      width: 14),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    data['task-done']!,
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
        )
      ]),
    );
  }
}
