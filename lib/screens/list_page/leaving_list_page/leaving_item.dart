import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/models/leaving/leving_model_list.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../widgets/text_custom.dart';

class LeavingItem extends StatelessWidget {
  const LeavingItem({super.key, required this.data});
  final LeavingModelList data;
  @override
  Widget build(BuildContext context) {
    print(data);
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: const BoxDecoration(
          color: COLOR_CARD_BACKGROUND,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(children: [
        Row(
          children: [
            const Icon(Icons.person),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "[ ${data.cpleaving_type!} ] ${data.name!}",
                    style: GoogleFonts.montserrat(
                      fontSize: FONT_SIZE_NORMAL,
                      color: COLOR_BLACK,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(children: [
          const Icon(Icons.schedule),
          const SizedBox(width: 10),
          TextCustom(
            color: COLOR_TEXT_MAIN,
            fontSize: FONT_SIZE_NORMAL,
            fontWeight: FontWeight.w600,
            text: data.createdtime!,
          ),
        ]),
        const SizedBox(height: 5),
        Row(children: [
          const Icon(Icons.help_outline),
          const SizedBox(width: 10),
          TextCustom(
            color: data.cpleaving_status! == 'Wait approved'
                ? COLOR_LATE
                : COLOR_GREEN,
            fontSize: FONT_SIZE_NORMAL,
            fontWeight: FontWeight.w600,
            text: data.cpleaving_status!,
          ),
        ]),
      ]),
    );
  }
}
