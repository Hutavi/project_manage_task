import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/models/project_task/project_task.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

class TaskItem extends StatelessWidget {
  const TaskItem({Key? key, required this.data}) : super(key: key);
  final ProjectTaskModel data;

  @override
  Widget build(BuildContext context) {
    Color stateColor = Colors.black;
    String stateText = '';
    String statusText = '';
    String priorityText = '';
    int dayLefts = DateFormat("yyyy-MM-dd")
        .parse(data.end_date_plan!)
        .difference(DateTime.now())
        .inDays;

    if (data.projecttaskstatus == 'In Progress') {
      stateColor = COLOR_INPROGRESS;
      stateText = 'Còn ${dayLefts.abs().toString()} ngày';
      statusText = 'Đang xử lí';
    } else if (data.projecttaskstatus == 'Completed') {
      stateColor = COLOR_DONE;
      statusText = 'Hoàn thành';
    } else if (data.projecttaskstatus == 'plan') {
      stateColor = COLOR_PLAN;
      stateText = 'Còn ${dayLefts.abs().toString()} ngày';
      statusText = 'Kế hoạch';
    } else if (data.projecttaskstatus == 'late') {
      stateColor = COLOR_LATE;
      stateText = 'Trễ ${dayLefts.abs().toString()} ngày';
      statusText = 'Trễ hạn';
    }

    if (data.projecttaskpriority == 'low') {
      priorityText = 'Thấp';
    } else if (data.projecttaskpriority == 'normal') {
      priorityText = 'Trung bình';
    } else if (data.projecttaskpriority == 'high') {
      priorityText = 'Cao';
    }

    return Container(
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
                  data.projecttaskname!,
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
                  statusText.isNotEmpty ? statusText : 'Không xác định',
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
            height: 12,
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
                      Image.asset(
                        'lib/assets/images/home_page/options_dialog/category_icon.png',
                        width: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        data.categoryname!,
                        // data.category_name!.isNotEmpty
                        //     ? data.category_name!
                        //     : 'Không xác định',
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
                    children: [
                      Image.asset(
                        'lib/assets/images/home_page/calendar_icon.png',
                        width: 14,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        data.end_date_plan!.isNotEmpty
                            ? data.end_date_plan!
                            : 'Không xác định',
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
                    children: [
                      Image.asset(
                        'lib/assets/images/home_page/user_icon.png',
                        width: 14,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        data.main_owner_name!.isNotEmpty
                            ? data.main_owner_name!
                            : 'Không xác định',
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
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'lib/assets/images/home_page/star_icon.png',
                        width: 16,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        priorityText.isNotEmpty
                            ? priorityText
                            : 'Không xác định',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: FONT_SIZE_EXTRA_SMALL,
                          color: COLOR_TEXT_MAIN,
                        ),
                      ),
                      const SizedBox(
                        width: 14,
                      ),
                    ],
                  ),
                  // const Spacer(),
                  const SizedBox(
                    height: 12,
                  ),
                  if (stateText.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                        color: COLOR_WHITE,
                        border: Border.all(width: 1, color: COLOR_BLACK),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(8),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 10),
                      child: Text(
                        stateText,
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
        ],
      ),
    );
  }
}
