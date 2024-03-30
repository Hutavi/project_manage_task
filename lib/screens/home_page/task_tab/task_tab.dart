import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/models/project_task/project_task.dart';
import 'package:management_app/screens/home_page/task_tab/task_item.dart';
import 'package:management_app/screens/home_page/task_tab/task_state_item.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../constants/image_assets.dart';
import '../../../routers/route_name.dart';
import '../../../services/dio_client.dart';

class TaskTab extends StatefulWidget {
  const TaskTab({super.key});
  @override
  State<TaskTab> createState() => _TaskTabState();
}

class _TaskTabState extends State<TaskTab> {
  List<ProjectTaskModel> listTask = [];
  int listLength = 0;
  int doneStateQuantity = 0;
  int progressStateQuantity = 0;
  int planStateQuantity = 0;
  int lateStateQuantity = 0;

  void fetchData(String startDate, String endDate) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php/',
        queryParameters: {
          'action': 'getProjectTasks',
          'sort': {"order_by": "end_date_plan", "sort_order": "ASC"},
          startDate == 'all' ? '' : 'filters': [
            {
              "name": "end_date_plan",
              "value": "$startDate,$endDate",
              "operator": "bw"
            }
          ]
        },
        options: Options(
          method: 'GET',
        ),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('lấy data tab công việc của trang chủ thành công!');

        final parsed = json.decode(response.data!);
        listTask.clear();
        doneStateQuantity = 0;
        progressStateQuantity = 0;
        planStateQuantity = 0;
        lateStateQuantity = 0;
        for (var entry in parsed['entry_list']) {
          ProjectTaskModel taskModel = ProjectTaskModel.fromMap(entry);
          listTask.add(taskModel);
          if (taskModel.projecttaskstatus == 'Completed') {
            doneStateQuantity++;
          } else if (taskModel.projecttaskstatus == 'In Progress') {
            progressStateQuantity++;
          } else if (taskModel.projecttaskstatus == 'plan') {
            planStateQuantity++;
          } else if (taskModel.projecttaskstatus == 'late') {
            lateStateQuantity++;
          }
        }

        listLength = listTask.length;
        listTask = listLength > 5 ? listTask.sublist(0, 5) : listTask;
        setState(() {});
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  String filterIndex = 'Hôm nay';

  String? selectedMenu;
  List<String> filterOptionList = [
    'Hôm nay',
    'Tuần này',
    'Tháng này',
    'Tất cả',
  ];

  void setFilter(String value) {
    filterIndex = value;

    DateTime? startDate;
    DateTime? endDate;

    if (value == 'Hôm nay') {
      startDate = DateTime.now();
      endDate = startDate;
    } else if (value == 'Tuần này') {
      startDate =
          DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1));
      endDate = startDate.add(const Duration(days: 6));
    } else if (value == 'Tháng này') {
      startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
      endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
    } else if (value == 'Tất cả') {
      fetchData('all', 'all');
      return;
    }
    fetchData(DateFormat('yyyy-MM-dd').format(startDate!),
        DateFormat('yyyy-MM-dd').format(endDate!));
  }

  @override
  void initState() {
    // TODO: implement initState

    fetchData(DateFormat('yyyy-MM-dd').format(DateTime.now()),
        DateFormat('yyyy-MM-dd').format(DateTime.now()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, Object>> taskStateList = [
      {
        'text': 'Hoàn thành',
        'quantity': doneStateQuantity,
        'icon': HOME_PAGE_DONE_PATH,
        'color': COLOR_DONE,
      },
      {
        'text': 'Đang xử lí',
        'quantity': progressStateQuantity,
        'icon': HOME_PAGE_INPROGRESS_PATH,
        'color': COLOR_INPROGRESS,
      },
      {
        'text': 'Kế hoạch',
        'quantity': planStateQuantity,
        'icon': HOME_PAGE_WAIT_PATH,
        'color': COLOR_PLAN,
      },
      {
        'text': 'Trễ hạn',
        'quantity': lateStateQuantity,
        'icon': HOME_PAGE_LATE_PATH,
        'color': COLOR_LATE,
      },
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTaskHeader(),
          const SizedBox(height: 18),
          taskStateGrid(taskStateList),
          const SizedBox(height: 18),
          buildImportantTaskHeader(),
          const SizedBox(height: 18),
          Expanded(
            child: taskItemBuilder(),
          ),
        ],
      ),
    );
  }

  Widget taskStateGrid(List<Map<String, Object>> taskStateList) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return GridView.builder(
          shrinkWrap:
              true, // Giúp Gridview mở rộng để chứa tất cả các widget con của nó
          physics: const NeverScrollableScrollPhysics(),
          itemCount: taskStateList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 1,
              crossAxisSpacing: 10,
              mainAxisSpacing: 20),
          itemBuilder: (context, index) {
            return TaskStateItem(
              value: taskStateList[index],
            );
          },
        );
      },
    );
  }

  Widget taskItemBuilder() {
    return ListView.builder(
      itemCount: listTask.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, AppRouterName.detailTask,
                arguments: listTask[index].projecttaskid);
          },
          child: TaskItem(
            data: listTask[index],
          ),
        );
      },
    );
  }

  Widget buildTaskHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tổng quan',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: FONT_SIZE_BIG,
            color: COLOR_TEXT_MAIN,
          ),
        ),
        PopupMenuButton<String>(
          child: Row(
            children: [
              Image.asset(
                'lib/assets/images/home_page/filter_icon.png',
                width: 20,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                filterIndex,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
              )
            ],
          ),
          onSelected: (value) {
            setFilter(value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            ...filterOptionList.map(
              (e) => PopupMenuItem<String>(
                value: e,
                child: TextCustom(
                  text: e,
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  Widget buildImportantTaskHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Tất cả công việc (${listTask.length}${listLength > 5 ? '+' : ''})',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: FONT_SIZE_BIG,
            color: COLOR_TEXT_MAIN,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/listTaskProject");
          },
          child: Text(
            'Xem tất cả',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: COLOR_TEXT_MAIN,
            ),
          ),
        ),
      ],
    );
  }
}
