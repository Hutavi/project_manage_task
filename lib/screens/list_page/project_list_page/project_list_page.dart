import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/data/data.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../models/project/project_model.dart';
import '../../../routers/route_name.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/custom_sort_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/search_bar.dart';
import '../../task/widgets/filter_dialog_task.dart';
import 'package:management_app/screens/home_page/project_tab/project_item.dart';

class ProjectListPage extends StatefulWidget {
  const ProjectListPage({Key? key}) : super(key: key);

  @override
  State<ProjectListPage> createState() => _ProjectListPageState();
}

class _ProjectListPageState extends State<ProjectListPage> {
  List<ProjectModel> listProject = [];
  String sortField = 'createdtime';
  String sortValue = 'DESC';
  Map<String, List<String>> filterValue = {};

  void fetchData() async {
    try {
      List<Map<String, String>> filterList = [];
      if (filterValue['priority'] != null &&
          filterValue['priority']!.isNotEmpty) {
        Map<String, String> filter = {
          "name": "projectpriority",
          "value": filterValue['priority']![0],
          "operator": "c"
        };
        filterList.add(filter);
      } else if (filterValue['status'] != null &&
          filterValue['status']!.isNotEmpty) {
        Map<String, String> filter = {
          "name": "projectstatus",
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
            "name": "targetenddate",
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
          'action': 'getProjects',
          'sort': {
            "order_by": sortField,
            "sort_order": sortValue,
          },
          'filters': filterList
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success!');
        listProject.clear();

        final parsed = json.decode(response.data!);
        for (var entry in parsed['entry_list']) {
          listProject.add(ProjectModel.fromMap(entry));
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

  void fetchSearchData(String value) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'getProjects',
          'sort': {
            "order_by": sortField,
            "sort_order": sortValue,
          },
          value.isEmpty ? '' : 'filters': [
            {"name": "projectname", "value": value, "operator": "c"}
          ],
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('search list page success!');
        final parsed = json.decode(response.data!);
        listProject.clear();
        for (var entry in parsed['entry_list']) {
          ProjectModel taskModel = ProjectModel.fromMap(entry);
          listProject.add(taskModel);
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
            setValue: (value) {
              print(value);
              filterValue = value;
              fetchData();
            },
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: COLOR_WHITE,
        iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
        title: Text(
          'Danh sách dự án',
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
                showFilter: showFilterDialog,
                placeHolder: 'Tên dự án...',
                onChanged: (String value) {
                  fetchSearchData(value);
                }),
            const SizedBox(
              height: 24,
            ),
            CustomSortBar(
              labelName: "Tất cả dự án (${listProject.length})",
              filterOptionList: const [
                'Mới nhất',
                'Cũ nhất',
                'Tiến độ giảm dần',
                'Tiến độ tăng dần',
              ],
              selectedItem: (item) {
                print(item);
                if (item == 'Mới nhất') {
                  sortField = 'createdtime';
                  sortValue = 'DESC';
                  fetchData();
                } else if (item == 'Cũ nhất') {
                  sortField = 'createdtime';
                  sortValue = 'ASC';
                  fetchData();
                } else if (item == 'Tiến độ giảm dần') {
                  sortField = 'progress';
                  sortValue = 'DESC';
                  fetchData();
                } else if (item == 'Tiến độ tăng dần') {
                  sortField = 'progress';
                  sortValue = 'ASC';
                  fetchData();
                }
              },
            ),
            const SizedBox(
              height: 18,
            ),
            if (listProject.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: listProject.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "/detailproject",
                            arguments: listProject[index].id!);
                      },
                      child: ProjectItem(
                        data: listProject[index],
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
          Navigator.pushNamed(context, AppRouterName.createProject);
        },
        child: const FloatingAddButton(
            title: 'Thêm dự án', marginBottom: 20, width: 150),
      ),
    );
  }
}
