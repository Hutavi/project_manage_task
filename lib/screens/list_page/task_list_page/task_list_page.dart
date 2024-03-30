import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/screens/home_page/task_tab/task_item.dart';
import 'package:management_app/widgets/custom_sort_bar.dart';
import 'package:management_app/widgets/search_bar.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../models/project_task/project_task.dart';
import '../../../routers/route_name.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/floating_add_button.dart';
import '../../task/widgets/filter_dialog_task.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({Key? key}) : super(key: key);

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<ProjectTaskModel> listTask = [];
  String sortValue = '';
  Map<String, List<String>> filterValue = {};

  void fetchData() async {
    try {
      List<Map<String, String>> filterList = [];
      if (filterValue['priority'] != null &&
          filterValue['priority']!.isNotEmpty) {
        Map<String, String> filter = {
          "name": "projecttaskpriority",
          "value": filterValue['priority']![0],
          "operator": "c"
        };
        filterList.add(filter);
      } else if (filterValue['status'] != null &&
          filterValue['status']!.isNotEmpty) {
        Map<String, String> filter = {
          "name": "projecttaskstatus",
          "value": filterValue['status']![0],
          "operator": "c"
        };
        filterList.add(filter);
      } else if (filterValue['time'] != null &&
          filterValue['time']!.isNotEmpty) {
        DateTime? startDate;
        DateTime? endDate;

        if (filterValue['time']![0] == 'Hôm nay') {
          startDate = DateTime.now();
          endDate = startDate;
        } else if (filterValue['time']![0] == 'Tuần này') {
          startDate = DateTime.now()
              .subtract(Duration(days: DateTime.now().weekday - 1));
          endDate = startDate.add(const Duration(days: 6));
        } else if (filterValue['time']![0] == 'Tháng này') {
          startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
          endDate = DateTime(DateTime.now().year, DateTime.now().month + 1, 0);
        } else if (filterValue['time']![0] == 'Chọn khoảng thời gian') {
          startDate = DateTime.parse(filterValue['dateRange']![0]);
          endDate = DateTime.parse(filterValue['dateRange']![1]);
        }
        if (startDate != null && endDate != null) {
          Map<String, String> filter = {
            "name": "end_date_plan",
            "value": "$startDate,$endDate",
            "operator": "bw"
          };
          filterList.add(filter);
        }
      }
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'getProjectTasks',
          sortValue.isEmpty ? '' : 'sort': {
            "order_by": "end_date_plan",
            "sort_order": sortValue,
          },
          'filters': filterList
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('task list page success!');
        final parsed = json.decode(response.data!);
        listTask.clear();
        for (var entry in parsed['entry_list']) {
          ProjectTaskModel taskModel = ProjectTaskModel.fromMap(entry);
          listTask.add(taskModel);
        }
        print(listTask.length);
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

  void fetchSearchData(String value) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'getProjectTasks',
          sortValue.isEmpty ? '' : 'sort': {
            "order_by": "end_date_plan",
            "sort_order": sortValue,
          },
          value.isEmpty ? '' : 'filters': [
            {"name": "projecttaskname", "value": value, "operator": "c"}
          ],
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('search list page success!');
        final parsed = json.decode(response.data!);
        listTask.clear();
        for (var entry in parsed['entry_list']) {
          ProjectTaskModel taskModel = ProjectTaskModel.fromMap(entry);
          listTask.add(taskModel);
        }
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

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
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
                setValue: (value) {
                  filterValue = value;
                  fetchData();
                },
                value: filterValue),
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

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: COLOR_WHITE,
        iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
        title: Text(
          'Danh sách công việc dự án',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: FONT_SIZE_SMALL_TITLE,
            color: COLOR_TEXT_MAIN,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21, left: 15, right: 15, bottom: 0),
        child: Column(
          children: [
            CustomSearchBar(
              onChanged: (String value) {
                fetchSearchData(value);
              },
              placeHolder: 'Tên tác vụ...',
              showFilter: showFilterDialog,
            ),
            const SizedBox(
              height: 24,
            ),
            CustomSortBar(
              labelName: 'Tổng cộng ${listTask.length}',
              filterOptionList: const [
                'Mặc định',
                'Ngày tăng dần',
                'Ngày giảm dần'
              ],
              selectedItem: (String selected) {
                print(selected);
                if (selected == 'Mặc định') {
                  sortValue = '';
                  fetchData();
                } else if (selected == 'Ngày tăng dần') {
                  sortValue = 'ASC';
                  fetchData();
                } else {
                  sortValue = 'DESC';
                  fetchData();
                }
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: ListView.builder(
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
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouterName.createProjectTask);
        },
        child: const FloatingAddButton(
            title: 'Thêm tác vụ', marginBottom: 20, width: 150),
      ),
    );
  }
}
