import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/models/project_task/project_task.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key, required this.data}) : super(key: key);

  final ProjectTaskModel data;
  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Color stateColor = Colors.black;
  String stateText = '';
  String statusText = '';
  String priorityText = '';

  @override
  Widget build(BuildContext context) {
    // int dayLefts = DateFormat("yyyy-MM-dd")
    //     .parse(widget.data.end_date_plan!)
    //     .difference(DateTime.now())
    //     .inDays;
    int dayLefts = 10;

    if (widget.data.projecttaskstatus == 'In Progress') {
      if (dayLefts >= 0) {
        stateColor = COLOR_INPROGRESS;
        stateText = 'Còn ' + dayLefts.abs().toString() + ' ngày';
        statusText = 'Đang xử lí';
      } else {
        stateColor = COLOR_LATE;
        stateText = 'Trễ ' + dayLefts.abs().toString() + ' ngày';
        statusText = 'Trễ hạn';
      }
    } else if (widget.data.projecttaskstatus == 'Completed') {
      stateColor = COLOR_DONE;
      statusText = 'Hoàn thành';
    } else if (widget.data.projecttaskstatus == 'plan') {
      stateColor = COLOR_PLAN;
      stateText = 'Còn ' + dayLefts.abs().toString() + ' ngày';
      statusText = 'Kế hoạch';
    } else if (widget.data.projecttaskstatus == 'late' || dayLefts < 0) {
      stateColor = COLOR_LATE;
      stateText = 'Trễ ' + dayLefts.abs().toString() + ' ngày';
      statusText = 'Trễ hạn';
    } else {
      stateColor = COLOR_BLACK;
      stateText = 'Không xác định';
      statusText = 'Không xác định';
    }

    if (widget.data.projecttaskpriority == 'low') {
      priorityText = 'Thấp';
    } else if (widget.data.projecttaskpriority == 'normal') {
      priorityText = 'Trung bình';
    } else if (widget.data.projecttaskpriority == 'high') {
      priorityText = 'Cao';
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
                  widget.data.projecttaskname!,
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
                  statusText,
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'lib/assets/images/home_page/options_dialog/project_icon.png',
                          width: 16,
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        SizedBox(
                          width: 200,
                          child: Text(
                            widget.data.projectid_label!,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w600,
                              fontSize: FONT_SIZE_EXTRA_SMALL,
                              color: COLOR_TEXT_MAIN,
                            ),
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
                            Image.asset(
                              'lib/assets/images/home_page/calendar_icon.png',
                              width: 14,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              widget.data.end_date_plan!,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontSize: FONT_SIZE_EXTRA_SMALL,
                                color: COLOR_TEXT_MAIN,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        //Sửa
                        Row(
                          children: [
                            Image.asset(
                              'lib/assets/images/home_page/star_icon.png',
                              width: 16,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            SizedBox(
                              width: 70,
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                priorityText.isNotEmpty
                                    ? priorityText
                                    : 'Không xác định',
                                style: GoogleFonts.montserrat(
                                  fontWeight: FontWeight.w600,
                                  fontSize: FONT_SIZE_EXTRA_SMALL,
                                  color: COLOR_TEXT_MAIN,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 18,
                            )
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              if (stateText.isNotEmpty)
                Container(
                  width: 106,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(right: 15),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                  decoration: BoxDecoration(
                    color: COLOR_WHITE,
                    border: Border.all(width: 1, color: COLOR_BLACK),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    stateText,
                    overflow: TextOverflow.ellipsis,
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
