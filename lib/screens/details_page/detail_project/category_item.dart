import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/models/category/category_project_model.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../widgets/text_custom.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({Key? key, required this.data, required this.projectName})
      : super(key: key);

  final CategoryProjectModel data;
  final String projectName;

  @override
  Widget build(BuildContext context) {
    double progress =
        data.progress != 'NAN' ? double.parse(data.progress!.toString()) : 0;

    Color progressColor = COLOR_DONE;
    if (progress <= 33)
      progressColor = COLOR_LATE;
    else if (progress <= 66) progressColor = COLOR_INPROGRESS;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: COLOR_CARD_BACKGROUND,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.name!,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/home_page/options_dialog/project_icon.png',
                    width: 14,
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  SizedBox(
                    width: 100,
                    child: Text(
                      projectName.isNotEmpty ? projectName : 'Không xác định',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w600,
                        fontSize: FONT_SIZE_NORMAL,
                        color: COLOR_TEXT_MAIN,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Image.asset('lib/assets/images/home_page/user_icon.png',
                      width: 14),
                  const SizedBox(
                    width: 6,
                  ),
                  Text(
                    data.main_owner_name!.isNotEmpty
                        ? data.main_owner_name!
                        : 'Không xác định',
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
                    '${data.total_completed_tasks!.isNotEmpty ? data.total_completed_tasks : 0}/${data.total_tasks!.isNotEmpty ? data.total_tasks : 0}',
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_NORMAL,
                      color: COLOR_TEXT_MAIN,
                    ),
                  ),
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

                  // center: Text(data['progress'].toString()),
                  barRadius: const Radius.circular(20),
                  // linearStrokeCap: CircularStrokeCap.round,
                  progressColor: progressColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
