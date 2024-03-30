import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../widgets/menu_setting.dart';
import '../../../widgets/text_custom.dart';
import '../../create_page/create_personal_task/add_personal_task_page.dart';

import '../detail_task/detail_task_page.dart';
import '../detail_task/widget/checklist/checklist_page.dart';

class DetailTodolistPage extends StatefulWidget {
  final data;
  const DetailTodolistPage({super.key, this.data});

  @override
  State<DetailTodolistPage> createState() => _DetailTodolistPageState();
}

class _DetailTodolistPageState extends State<DetailTodolistPage> {
  @override
  Widget build(BuildContext context) {
    double progress = double.parse(widget.data['progress'].toString());
    Color progressColor = COLOR_DONE;
    if (progress <= 33)
      progressColor = COLOR_LATE;
    else if (progress <= 66) progressColor = COLOR_INPROGRESS;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: COLOR_WHITE,
        iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
        actions: <Widget>[
          MenuSetting(
            onItemSelected: (value) {
              if (value == "Chỉnh sửa") {
                print(widget.data);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddPersonalTaskPage(data: widget.data),
                  ),
                );
              } else if (value == "Xoá") {
                print("Xoá ở đây");
                Navigator.pop(context);
              }
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
        title: Text(
          "Chi tiết công việc cá nhân",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: FONT_SIZE_SMALL_TITLE,
            color: COLOR_TEXT_MAIN,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                  text: 'Tên công việc',
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_BIG,
                  fontWeight: FontWeight.w600,
                ),
                TextCustom(
                  text: widget.data['task-name'] ?? 'Tiêu đề công việc',
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_BIG,
                  fontWeight: FontWeight.w600,
                ),
              ],
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Ngày bắt đầu",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5),
                      TextCustom(
                        text: widget.data['beginPlanDate'] ?? '27/06/2023',
                        color: COLOR_BLACK,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Ngày kết thúc",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5),
                      TextCustom(
                        text: widget.data['finishPlanDate'] ?? '28/07/2023',
                        color: COLOR_BLACK,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Trạng thái",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: widget.data['status'] == 'Đang tiến hành'
                                ? COLOR_GREEN
                                : COLOR_INPROGRESS,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextCustom(
                          text: widget.data['status'] ?? 'Đang tiến hành',
                          color: COLOR_BLACK,
                          fontSize: FONT_SIZE_NORMAL,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Độ ưu tiên ",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      SizedBox(height: 5),
                      TextCustom(
                        text: widget.data['priority'] ?? 'Độ ưu tiên',
                        color: COLOR_BLACK,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Tiến độ",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          TextCustom(
                            text: '${progress.toInt()}%',
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
                ),
              ],
            ),
            const SizedBox(height: 25),
            const TextCustom(
              text: "Mô tả",
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_NORMAL,
              fontWeight: FontWeight.w700,
            ),
            const SizedBox(height: 10),
            ExpandableText(
                text: widget.data['description'] ??
                    'Loremn ipsum dolor sit amet, consectetur adipiscing elit. Nulla eget libero nec quam sodales rutrum. Sed eget nisl nec nisl aliquam ultrici  es. Nulla non ghsksnvkehdsjdsjknfdsgklgoghewơpẹkbrẹogopgẻpwđékdsỏgogogôrgnrỏpgjgkgơ]rp'),
            const SizedBox(height: 10),
            // Expanded(child: CheckList())
          ],
        ),
      ),
    );
  }
}
