import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/models/category/category_project_model.dart';
import 'package:management_app/models/project_task/project_task.dart';

import 'package:management_app/screens/create_page/create_project/create_project.dart';
import 'package:management_app/screens/details_page/detail_project/category_item.dart';
import 'package:management_app/screens/details_page/detail_project/member_item.dart';
import 'package:management_app/screens/details_page/detail_project/state_chart.dart';
import 'package:management_app/screens/details_page/detail_project/task_item.dart';
import 'package:management_app/widgets/custom_sort_bar.dart';
import 'package:management_app/widgets/text_custom.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../../../data/data.dart';
import '../../../models/project/project_model.dart';
import '../../../routers/route_name.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/menu_setting.dart';
import '../../../widgets/search_bar.dart';
import '../../task/widgets/filter_dialog_task.dart';
import '../detail_task/detail_task_page.dart';

class DetailProjectPage extends StatefulWidget {
  const DetailProjectPage({super.key, required this.data});

  final dynamic data;

  @override
  State<DetailProjectPage> createState() => _DetailProjectPageState();
}

class _DetailProjectPageState extends State<DetailProjectPage> {
  ProjectModel? projectModel;
  Color? stateColor = Colors.amber;
  String? stateName = 'Hoàn thành';
  int dayLefts = 0;
  Color? dayLeftsColor = Colors.amber;
  double completedCount = 0;
  double inProgressCount = 0;
  double planCount = 0;
  double lateCount = 0;
  double totalCount = 0;

  double progress = 0;

  void fetchData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php/',
        queryParameters: {
          'action': 'getProjectById',
          'record': widget.data.toString()
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('success 1!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        projectModel = ProjectModel.fromMap(parsed['data']);
        setState(() {
          progress = projectModel!.progress != 'NAN'
              ? double.parse(projectModel!.progress!.toString())
              : 0;

          if (projectModel!.projectstatus == 'Completed') {
            stateColor = COLOR_DONE;
            stateName = 'Hoàn thành';
          } else if (projectModel!.projectstatus == 'In Progress') {
            stateColor = COLOR_INPROGRESS;
            stateName = 'Đang tiến hành';
          } else if (projectModel!.projectstatus == 'plan') {
            stateColor = COLOR_PLAN;
            stateName = 'Kế hoạch';
          } else if (projectModel!.projectstatus == 'late') {
            stateColor = COLOR_LATE;
            stateName = 'Trễ hạn';
          }
          DateTime endDate = DateTime.parse(
              projectModel!.targetenddate!); // Chuyển chuỗi thành DateTime
          DateTime currentDate = DateTime.now(); // Ngày hiện tại
          Duration difference = endDate.difference(currentDate);
          dayLefts = difference.inDays > 0 ? difference.inDays : 0;
          if (dayLefts < 10)
            dayLeftsColor = COLOR_LATE;
          else if (dayLefts < 20)
            dayLeftsColor = COLOR_INPROGRESS;
          else
            dayLeftsColor = COLOR_DONE;

          for (var item in projectModel!.statistic!) {
            Map<String, String> mapData = Map<String, String>.from(item);

            int count = int.parse(mapData['count']!);
            totalCount += count;

            if (mapData['status'] == 'Completed') {
              completedCount += count;
            } else if (mapData['status'] == 'In Progress') {
              inProgressCount += count;
            } else if (mapData['status'] == 'plan') {
              planCount += count;
            } else if (mapData['status'] == 'late') {
              lateCount += count;
            }
          }
        });
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  List<CategoryProjectModel> categoryList = [];

  void fetchCategoryListData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        'apis/CloudworkApi.php',
        queryParameters: {
          'action': 'relatedListProject',
          'parent_record': widget.data.toString(),
          'relation_id': '332',
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success 2!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        List<dynamic> entryList = parsed['entry_list'];
        for (var entry in entryList) {
          Map<String, dynamic> convertedMap = entry;
          CategoryProjectModel categoryModel =
              CategoryProjectModel.fromMap(convertedMap);
          categoryList.add(categoryModel);
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

  List<ProjectTaskModel> projectTaskList = [];

  void fetchProjectTaskListData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'relatedListProject',
          'parent_record': widget.data.toString(),
          'relation_id': '140',
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success 3!');
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

  static Map<String, double> dataMap = {
    "Hoàn thành": 5,
    "Đang tiến hành": 3,
    "Kế hoạch": 4,
    "Trễ hạn": 7,
  };
  final List<Color> colorList = [
    COLOR_DONE,
    COLOR_INPROGRESS,
    COLOR_PLAN,
    COLOR_LATE
  ];

  @override
  void initState() {
    // TODO: implement initState
    fetchData();
    fetchCategoryListData();
    fetchProjectTaskListData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return projectModel != null
        ? Scaffold(
            appBar: AppBar(
              backgroundColor: COLOR_WHITE,
              elevation: 0,
              // toolbarHeight: 50,
              title: const TextCustom(
                  text: "Chi tiết dự án",
                  color: COLOR_TEXT_MAIN,
                  fontSize: FONT_SIZE_SMALL_TITLE,
                  fontWeight: FontWeight.w600),
              centerTitle: true,
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
              actions: <Widget>[
                MenuSetting(
                  onItemSelected: (value) {
                    if (value == "Chỉnh sửa") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateProject(data: widget.data),
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
            ),
            body: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      widget3(),
                      const SizedBox(
                        height: 25,
                      ),
                      progressWidget(progress!),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  Expanded(
                    child: DefaultTabController(
                      length: 4,
                      child: Column(
                        children: [
                          TabBar(
                            labelPadding:
                                const EdgeInsets.symmetric(horizontal: 0),
                            indicatorColor: COLOR_GREEN,
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                            labelColor: COLOR_GREEN,
                            labelStyle: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w700,
                                fontSize: FONT_SIZE_TEXT_BUTTON),
                            unselectedLabelColor: COLOR_GRAY,
                            tabs: const [
                              Tab(text: 'Tổng quan'),
                              Tab(text: 'Hạng mục'),
                              Tab(text: 'Tác vụ'),
                              Tab(text: 'Thành viên'),
                            ],
                          ),
                          Expanded(
                            child: TabBarView(
                              children: [
                                SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      widget1(),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      widget4(),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      if (totalCount > 0)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Biểu đồ trạng thái",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_TEXT_BUTTON,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            StateChart(data: {
                                              'Completed': completedCount,
                                              'In Progress': inProgressCount,
                                              'plan': planCount,
                                              'late': lateCount,
                                              'total': totalCount,
                                            }),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      description()
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: Column(
                                    children: [
                                      CustomSearchBar(
                                        placeHolder: 'Tên hạng mục...',
                                        showFilter: showFilterDialog,
                                        onChanged: (value) {
                                          print(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomSortBar(
                                          labelName: 'Tất cả hạng mục',
                                          filterOptionList: const [
                                            'Tiến độ giảm dần',
                                            'Tiến độ tăng dần',
                                          ],
                                          selectedItem: (String value) {
                                            print(value);
                                          }),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: categoryList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(context,
                                                        "/detailCategory",
                                                        arguments:
                                                            categoryList[index]
                                                                .crmid);
                                                  },
                                                  child: CategoryItem(
                                                    projectName: projectModel!
                                                        .projectname!,
                                                    data: categoryList[index],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      CustomSearchBar(
                                        placeHolder: 'Tên tác vụ...',
                                        showFilter: showFilterDialog,
                                        onChanged: (value) {
                                          print(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      CustomSortBar(
                                          labelName: 'Tất cả tác vụ',
                                          filterOptionList: const [
                                            'Ngày giảm dần',
                                            'Ngày tăng dần',
                                            'Tiến độ giảm dần',
                                            'Tiến độ tăng dần',
                                          ],
                                          selectedItem: (String value) {
                                            print(value);
                                          }),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: projectTaskList.length,
                                          itemBuilder: (context, index) {
                                            return Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.pushNamed(
                                                        context,
                                                        AppRouterName
                                                            .detailTask,
                                                        arguments:
                                                            projectTaskList[
                                                                    index]
                                                                .crmid);
                                                  },
                                                  child: TaskItem(
                                                    data:
                                                        projectTaskList[index],
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 10),
                                  child: Column(
                                    children: [
                                      CustomSearchBar(
                                        placeHolder: 'Tên thành viên...',
                                        showFilter: showFilterDialog,
                                        onChanged: (value) {
                                          print(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 25,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const TextCustom(
                                                  text: 'Người phụ trách',
                                                  color: COLOR_TEXT_MAIN,
                                                  fontSize:
                                                      FONT_SIZE_TEXT_BUTTON,
                                                  fontWeight: FontWeight.w600),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ...mentorList.map(
                                                (e) => Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: MemberItem(
                                                        data: e,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              const TextCustom(
                                                  text: 'Thành viên',
                                                  color: COLOR_TEXT_MAIN,
                                                  fontSize:
                                                      FONT_SIZE_TEXT_BUTTON,
                                                  fontWeight: FontWeight.w600),
                                              const SizedBox(
                                                height: 20,
                                              ),
                                              ...memberList.map(
                                                (e) => Column(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {},
                                                      child: MemberItem(
                                                        data: e,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 15,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget widget1() {
    return Container(
      width: double.infinity,
      // height: 200,
      padding: const EdgeInsets.symmetric(vertical: 25),
      decoration: const BoxDecoration(
        color: COLOR_CARD_BACKGROUND,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: stateColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(50),
              ),
            ),
            child: TextCustom(
                text: stateName!,
                color: COLOR_WHITE,
                fontSize: FONT_SIZE_NORMAL,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/detail_project/calendar_add_icon.png',
                    width: 21,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextCustom(
                    text: projectModel!.startdate!,
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(
                width: 15,
              ),
              const Icon(
                Icons.arrow_forward,
                size: 30,
              ),
              const SizedBox(
                width: 15,
              ),
              Row(
                children: [
                  Image.asset(
                    'lib/assets/images/detail_project/calendar_tick_icon.png',
                    width: 21,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextCustom(
                    text: projectModel!.targetenddate!,
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget progressWidget(double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextCustom(
          text: "Tiến độ",
          color: COLOR_TEXT_MAIN,
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 15,
        ),
        Row(
          children: [
            TextCustom(
              text: '${progress.round().toString()}%',
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              fontWeight: FontWeight.w600,
            ),
            const SizedBox(
              width: 15,
            ),
            Expanded(
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 12,
                animationDuration: 800,
                percent: progress / 100,
                barRadius: const Radius.circular(20),
                progressColor: COLOR_DONE,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget widget3() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextCustom(
                text: 'Dự án',
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 10,
              ),
              TextCustom(
                text: projectModel!.projectname!,
                color: COLOR_BLACK,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
        const SizedBox(
          width: 30,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TextCustom(
                text: 'Ngày KT dự kiến',
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 15,
              ),
              TextCustom(
                text: projectModel!.targetenddate!,
                color: COLOR_BLACK,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                fontWeight: FontWeight.w600,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget widget4() {
    return Container(
      width: double.infinity,
      // height: 200,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
      decoration: const BoxDecoration(
        color: COLOR_CARD_BACKGROUND,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: const BoxDecoration(
                color: COLOR_DONE,
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const TextCustom(
                    text: 'Hoàn thành',
                    color: Colors.white,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextCustom(
                    text: '${completedCount.round()}/${totalCount.round()}',
                    color: Colors.white,
                    fontSize: FONT_SIZE_NORMAL_TITLE,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            width: 30,
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: dayLeftsColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Column(
                children: [
                  const TextCustom(
                    text: 'Ngày còn lại',
                    color: Colors.white,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w700,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextCustom(
                    text: '$dayLefts ngày',
                    color: Colors.white,
                    fontSize: FONT_SIZE_NORMAL_TITLE,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget description() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextCustom(
          text: "Mô tả",
          color: COLOR_TEXT_MAIN,
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w600,
        ),
        const SizedBox(
          height: 10,
        ),
        ExpandableText(
          text: projectModel!.description!,
        ),
      ],
    );
  }
}
