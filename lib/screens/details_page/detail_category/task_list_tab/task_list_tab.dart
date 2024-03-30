import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/models/category/category_project_model.dart';
import 'package:management_app/models/project_task/project_task.dart';
import 'package:management_app/screens/details_page/detail_project/task_item.dart';
import 'package:management_app/screens/task/widgets/filter_dialog_task.dart';
import 'package:management_app/widgets/search_bar.dart';

import '../../../../data/data.dart';
import '../../../../routers/route_name.dart';
import '../../../../services/dio_client.dart';

class TaskListTab extends StatefulWidget {
  const TaskListTab({super.key, required this.id});

  final String id;

  @override
  State<TaskListTab> createState() => _TaskListTabState();
}

class _TaskListTabState extends State<TaskListTab> {
  List<ProjectTaskModel> projectTaskList = [];
  void fetchData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'relatedListProjectCategory',
          'parent_record': widget.id,
          'relation_id': '331',
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success ccccccccc!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        List<dynamic> entryList = parsed['entry_list'];
        for (var entry in entryList) {
          Map<String, dynamic> convertedMap = entry;
          ProjectTaskModel projectTaskModel =
              ProjectTaskModel.fromMap(convertedMap);
          projectTaskList.add(projectTaskModel);
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

  void showFilterDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
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

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 0),
        child: Column(
          children: [
            CustomSearchBar(
                showFilter: showFilterDialog,
                placeHolder: "Tên tác vụ...",
                onChanged: (value) {
                  print(value);
                }),
            const SizedBox(
              height: 20,
            ),
            Expanded(child: taskItemBuilder())
          ],
        ),
      ),
    );
  }

  Widget taskItemBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: projectTaskList.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRouterName.detailTask,
                    arguments: projectTaskList[index].crmid);
              },
              child: TaskItem(
                data: projectTaskList[index],
              ),
            ),
            const SizedBox(
              height: 10,
            )
          ],
        );
      },
    );
  }
}
