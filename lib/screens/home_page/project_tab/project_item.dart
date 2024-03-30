import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../models/project/project_model.dart';
import '../../../widgets/text_custom.dart';

class ProjectItem extends StatelessWidget {
  const ProjectItem({super.key, required this.data});
  final ProjectModel data;
  @override
  Widget build(BuildContext context) {
    double progress =
        data.progress != 'NAN' ? double.parse(data.progress!.toString()) : 0;
    Color? stateColor = Colors.amber;
    String? stateName = 'Hoàn thành';
    if (data.projectstatus == 'Completed') {
      stateColor = COLOR_DONE;
      stateName = 'Hoàn thành';
    } else if (data.projectstatus == 'In Progress') {
      stateColor = COLOR_INPROGRESS;
      stateName = 'Đang tiến hành';
    } else if (data.projectstatus == 'plan') {
      stateColor = COLOR_PLAN;
      stateName = 'Kế hoạch';
    } else if (data.projectstatus == 'late') {
      stateColor = COLOR_LATE;
      stateName = 'Trễ hạn';
    }

    int completedCount = 0;
    int totalCount = 0;

    for (var item in data.statistic!) {
      Map<String, String> mapData = Map<String, String>.from(item);

      int count = int.parse(mapData['count']!);
      totalCount += count;

      if (mapData['status'] == 'Completed') {
        completedCount += count;
      }
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.only(left: 15),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: COLOR_CARD_BACKGROUND),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  data.projectname!.isNotEmpty
                      ? data.projectname!
                      : 'Không xác định',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
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
                  stateName,
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
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/home_page/calendar_icon.png',
                    width: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data.targetenddate!.isNotEmpty
                        ? data.targetenddate!
                        : 'Không xác định',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_EXTRA_SMALL,
                      color: COLOR_TEXT_MAIN,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/home_page/members_icon.png',
                    width: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    data.assigned_owners!.length.toString(),
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_EXTRA_SMALL,
                      color: COLOR_TEXT_MAIN,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/home_page/project_task_list_icon.png',
                    width: 13,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$completedCount/$totalCount',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_EXTRA_SMALL,
                      color: COLOR_TEXT_MAIN,
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              TextCustom(
                text: '${progress.round().toInt()}%',
                color: COLOR_BLACK,
                fontSize: FONT_SIZE_NORMAL,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                child: LinearPercentIndicator(
                  animation: true,
                  lineHeight: 10,
                  animationDuration: 800,
                  percent: (progress / 100),
                  // center: Text(progress.toString()),
                  barRadius: const Radius.circular(20),
                  progressColor: stateColor,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
