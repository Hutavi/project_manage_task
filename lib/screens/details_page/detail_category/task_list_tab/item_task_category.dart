import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';

import '../../../../constants/font.dart';
import '../../../../widgets/text_custom.dart';

class ItemTaskCategory extends StatefulWidget {
  const ItemTaskCategory({super.key, required this.data});
  final Map<String, String> data;
  @override
  State<ItemTaskCategory> createState() => _ItemTaskCategoryState();
}

class _ItemTaskCategoryState extends State<ItemTaskCategory> {
  Color? stateColor;
  String textState = '';

  @override
  Widget build(BuildContext context) {
    if (widget.data['state'] == 'Đang tiến hành') {
      stateColor = COLOR_INPROGRESS;
      textState = 'Còn ${widget.data['day-lefts']!} ngày';
    } else if (widget.data['state'] == 'Hoàn thành') {
      stateColor = COLOR_DONE;
      textState = 'Còn ${widget.data['day-lefts']!} ngày';
    } else if (widget.data['state'] == 'Kế hoạch') {
      stateColor = COLOR_PLAN;
      textState = 'Còn ${widget.data['day-lefts']!} ngày';
    } else if (widget.data['state'] == 'Trễ hạn') {
      stateColor = COLOR_LATE;
      textState = 'Trễ ${widget.data['day-lefts']!} ngày';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 15, bottom: 10),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        color: COLOR_CARD_BACKGROUND,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  // widget.data['task-name']!,
                  '1',
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: FONT_SIZE_BIG,
                    color: COLOR_BLACK,
                  ),
                ),
              ),
              Container(
                width: 120,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: stateColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Text(
                  // widget.data['state']!,
                  '2',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: FONT_SIZE_NORMAL,
                    color: COLOR_WHITE,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        // widget.data['category']!,
                        '1',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: FONT_SIZE_EXTRA_SMALL,
                          color: COLOR_TEXT_MAIN,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              const TextCustom(
                                  text: "Ngày bắt đầu: ",
                                  color: COLOR_TEXT_MAIN,
                                  fontSize: FONT_SIZE_EXTRA_SMALL,
                                  fontWeight: FontWeight.w600),
                              Text(
                                // widget.data['start-day']!,
                                '3',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FONT_SIZE_EXTRA_SMALL,
                                  color: COLOR_TEXT_MAIN,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Row(
                            children: [
                              const TextCustom(
                                  text: "Ngày kết thúc: ",
                                  color: COLOR_TEXT_MAIN,
                                  fontSize: FONT_SIZE_EXTRA_SMALL,
                                  fontWeight: FontWeight.w600),
                              Text(
                                // widget.data['due-day']!,
                                '5',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FONT_SIZE_EXTRA_SMALL,
                                  color: COLOR_TEXT_MAIN,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
                padding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                child: Text(
                  textState,
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: FONT_SIZE_NORMAL,
                    color: COLOR_BLACK,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
