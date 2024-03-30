import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../constants/image_assets.dart';
import '../../../models/project/project_model.dart';
import '../../../services/dio_client.dart';
import '../../task/widgets/filter_dialog_task.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/screens/home_page/task_tab/task_state_item.dart';
import 'package:management_app/widgets/text_custom.dart';
import 'package:management_app/screens/home_page/project_tab/project_item.dart';

class ProjectTab extends StatefulWidget {
  const ProjectTab({super.key});

  @override
  State<ProjectTab> createState() => _ProjectTabState();
}

class _ProjectTabState extends State<ProjectTab> {
  List<ProjectModel> listProject = [];
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
          'action': 'getProjects',
          'sort': {"order_by": "targetenddate", "sort_order": "ASC"},
          startDate == 'all' ? '' : 'filters': [
            {
              "name": "targetenddate",
              "value": "$startDate,$endDate",
              "operator": "bw"
            }
          ]
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        print('lấy data tab dự án của trang chủ thành công!');
        // Xử lý dữ liệu nhận được từ response.data
        // print('Success!');
        final parsed = json.decode(response.data!);
        listProject.clear();
        doneStateQuantity = 0;
        progressStateQuantity = 0;
        planStateQuantity = 0;
        lateStateQuantity = 0;
        for (var entry in parsed['entry_list']) {
          ProjectModel projectModel = ProjectModel.fromMap(entry);
          listProject.add(projectModel);
          if (projectModel.projectstatus == 'Completed') {
            doneStateQuantity++;
          } else if (projectModel.projectstatus == 'In Progress') {
            progressStateQuantity++;
          } else if (projectModel.projectstatus == 'plan') {
            planStateQuantity++;
          } else if (projectModel.projectstatus == 'late') {
            lateStateQuantity++;
          }
        }
        listLength = listProject.length;
        listProject = listLength > 5 ? listProject.sublist(0, 5) : listProject;
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
    fetchData('all', 'all');
    super.initState();
  }

  String filterIndex = 'Tất cả';

  String? selectedMenu;
  List<String> filterOptionList = [
    'Tất cả',
    'Tháng này',
    'Tuần này',
    'Hôm nay',
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
      itemCount: listProject.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/detailproject",
                arguments: listProject[index].projectid);
          },
          child: ProjectItem(
            data: listProject[index],
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
          'Tất cả dự án (${listProject.length}${listLength > 5 ? '+' : ''})',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: FONT_SIZE_BIG,
            color: COLOR_TEXT_MAIN,
          ),
        ),
        InkWell(
          onTap: () {
            Navigator.pushNamed(context, "/listProject");
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
