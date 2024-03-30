import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/models/personal_task/personal_task.dart';
import 'package:management_app/screens/details_page/detail_todolist/detail_todolist_page.dart';
import 'package:management_app/services/dio_client.dart';
import 'package:management_app/widgets/custom_sort_bar.dart';
import 'package:management_app/widgets/search_bar.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../widgets/filter_dialog_task.dart';

class PersonalTab extends StatefulWidget {
  const PersonalTab({
    super.key,
  });

  @override
  State<PersonalTab> createState() => _PersonalTabState();
}

class _PersonalTabState extends State<PersonalTab> {
  List<PersonalTaskModel> personalTaskList = [];
  String sortOrder = "DESC";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request("/apis/CloudworkApi.php/",
          queryParameters: {
            "action": "getActivities",
            "offset": "0",
            "max_rows": "10",
            "filters": [
              {"name": "activitytype", "value": "Task", "operator": "c"}
            ],
            "sort": {"order_by": "due_date", "sort_order": sortOrder}
          },
          options: Options(method: "GET"));

      if (response.statusCode == 200) {
        final parsed = json.decode(response.data!);
        if (parsed['success'] == "1") {
          personalTaskList.clear();
          for (var entry in parsed['entry_list']) {
            PersonalTaskModel personalTaskModel =
                PersonalTaskModel.fromMap(entry);
            personalTaskList.add(personalTaskModel);
            // print(personalTaskModel.taskstatus);
            // print(personalTaskModel.taskpriority);
          }
          setState(() {});
        }
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    void showFilterDialog() {
      showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel:
            MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black45,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (BuildContext buildContext, Animation animation,
            Animation secondaryAnimation) {
          return SafeArea(
            child: FilterDialogTask(
              setValue: (value) {},
              value: {},
            ),
          );
        },
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
      );
    }

    print("test");
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: const BoxDecoration(
          color: COLOR_WHITE,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          CustomSearchBar(
            showFilter: showFilterDialog,
            placeHolder: 'Tên tác vụ...',
            onChanged: (String value) {
              print(value);
            },
          ),
          const SizedBox(
            height: 20,
          ),
          CustomSortBar(
            labelName: 'Tất cả tác vụ',
            filterOptionList: ['Ngày giảm dần', 'Ngày tăng dần'],
            selectedItem: (String value) {
              if (value == 'Ngày tăng dần') {
                sortOrder = "ASC";
              } else {
                sortOrder = "DESC";
              }
              fetchData();
            },
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: ListView.builder(
            itemCount: personalTaskList.length,
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DetailTodolistPage(
                                  data: personalTaskList[index],
                                )));
                  },
                  child: TaskItem(data: personalTaskList[index]));
            },
          )),
        ],
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({Key? key, required this.data}) : super(key: key);

  final PersonalTaskModel data;
  @override
  _TaskItemState createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  Color? stateColor;
  String stateText = '';
  String state = '';
  String priority = '';

  @override
  Widget build(BuildContext context) {
    // print(widget.data);

    String? dateStartStr = widget.data.date_start;
    String? dueDateStr = widget.data.due_date;

    DateTime dateStart = DateFormat("yyyy-MM-dd").parse(dateStartStr!);
    DateTime dueDate = DateFormat("yyyy-MM-dd").parse(dueDateStr!);

    Duration difference = dueDate.difference(dateStart);
    int daysRemaining = difference.inDays;

    if (widget.data.eventstatus == 'In Progress') {
      stateColor = COLOR_INPROGRESS;
      stateText = 'Còn $daysRemaining ngày';
      state = 'Đang xử lí';
    } else if (widget.data.eventstatus == 'Completed') {
      stateColor = COLOR_DONE;
      stateText = 'Còn $daysRemaining ngày';
      state = 'Hoàn thành';
    } else if (widget.data.eventstatus == 'Planned') {
      stateColor = COLOR_PLAN;
      stateText = 'Còn $daysRemaining ngày';
      state = 'Kế hoạch';
    } else if (widget.data.eventstatus == 'Late') {
      stateColor = COLOR_LATE;
      stateText = 'Trễ $daysRemaining ngày';
      state = 'Trễ hạn';
    }

    if (widget.data.taskpriority == 'High') {
      priority = 'Cao';
    } else if (widget.data.taskpriority == 'Low') {
      priority = 'Thấp';
    } else if (widget.data.taskpriority == 'Normal') {
      priority = 'Bình thường';
    } else {
      priority = 'Không xác định';
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
                  widget.data.subject!,
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
                  state,
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
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                              widget.data.due_date!,
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
                                priority,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
              Expanded(
                flex: 1,
                child: Container(
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
                    stateText,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w600,
                      fontSize: FONT_SIZE_NORMAL,
                      color: COLOR_BLACK,
                    ),
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
