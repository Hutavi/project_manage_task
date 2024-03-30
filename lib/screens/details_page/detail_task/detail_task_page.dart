import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/blocs/report_progress_bloc/report_progress_bloc.dart';
import 'package:management_app/blocs/report_progress_bloc/report_progress_state.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/models/comment/comment_model.dart';
import 'package:management_app/models/project_task/project_task.dart';
import 'package:management_app/screens/create_page/create_project_task/create_detail.dart';
import 'package:management_app/screens/details_page/detail_task/widget/bottom_sheet_report_progress/bottom_sheet_report_progress.dart';
import 'package:management_app/screens/details_page/detail_task/widget/checklist/checklist_page.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/menu_setting.dart';
import 'widget/comment/Comment_page.dart';

class DetailTaskPage extends StatefulWidget {
  const DetailTaskPage({super.key, required this.data});
  final String data;

  @override
  State<DetailTaskPage> createState() => _DetailTaskPageState();
}

class _DetailTaskPageState extends State<DetailTaskPage> {
  String priortity = '';
  String statusText = 'Không xác định';
  Color stateColor = COLOR_BLACK;
  ProjectTaskModel? projectTaskModel;
  List<CommentModel> commentList = [];
  List<Map<String, String>> progressReport = [];
  final commentController = TextEditingController();
  void fetchData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/retrieve',
        queryParameters: {
          'module': 'ProjectTask',
          'record': widget.data.toString(),
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('success 1!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        projectTaskModel = ProjectTaskModel.fromMap(parsed['data']);

        progressReport = parseJsonString(projectTaskModel!.progressreport!);

        int dayLefts = DateFormat("yyyy-MM-dd")
            .parse(projectTaskModel!.end_date_plan!)
            .difference(DateTime.now())
            .inDays;

        if (projectTaskModel!.projecttaskpriority == 'low') {
          priortity = 'Thấp';
        } else if (projectTaskModel!.projecttaskpriority == 'normal') {
          priortity = 'Trung bình';
        } else if (projectTaskModel!.projecttaskpriority == 'high') {
          priortity = 'Cao';
        }

        if (projectTaskModel!.projecttaskstatus == 'In Progress') {
          if (dayLefts >= 0) {
            stateColor = COLOR_INPROGRESS;
            statusText = 'Đang xử lí';
          } else {
            stateColor = COLOR_LATE;
            statusText = 'Trễ hạn';
          }
        } else if (projectTaskModel!.projecttaskstatus == 'Completed') {
          stateColor = COLOR_DONE;
          statusText = 'Hoàn thành';
        } else if (projectTaskModel!.projecttaskstatus == 'plan') {
          stateColor = COLOR_PLAN;
          statusText = 'Kế hoạch';
        } else if (projectTaskModel!.projecttaskstatus == 'late' ||
            dayLefts < 0) {
          stateColor = COLOR_LATE;
          statusText = 'Trễ hạn';
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

  void fetchCommentData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/relatedList',
        queryParameters: {
          'parent_module': 'ProjectTask',
          'parent_record': widget.data.toString(),
          'relation_id': '139',
          'max_rows': '50',
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('success 2!');
        final parsed = json.decode(response.data!);
        for (var entry in parsed['entry_list']) {
          if (entry['parent_comments'] == '0') {
            CommentModel parentComment = CommentModel.fromMap(entry);
            for (var _entry in parsed['entry_list']) {
              if (_entry['parent_comments'] == parentComment.modcommentsid) {
                parentComment.replies.add(CommentModel.fromMap(_entry));
              }
            }
            commentList.add(parentComment);
          }
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

  void postCommentData(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/create',
        queryParameters: {
          'module': 'ModComments',
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        commentList.clear();
        fetchCommentData();
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void editCommentData(var data, String commentId) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/update',
        queryParameters: {
          'module': 'ModComments',
          'record': commentId,
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        commentList.clear();
        fetchCommentData();
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void updateProgressData(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/update',
        queryParameters: {
          'module': 'ProjectTask',
          'record': projectTaskModel!.id,
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        print('success 35555565!');
        progressReport.clear();
        fetchData();
        // Xử lý dữ liệu nhận được từ response.data
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
    fetchCommentData();
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    commentController.dispose();
    super.dispose();
  }

  void _showDialog(BuildContext context, Map<String, String> value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            width: 280,
            height: 300,
            color: Colors.white,
            child: Column(children: [
              const Text(
                'Báo cáo tiến độ',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const TextCustom(
                    text: "Ngày: ",
                    color: COLOR_TEXT_MAIN,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w600,
                  ),
                  const SizedBox(height: 5),
                  TextCustom(
                    text: value['time']!,
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Trạng thái",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                            color: stateColor,
                            borderRadius: BorderRadius.circular(15)),
                        child: TextCustom(
                          text: value['projecttaskstatus']!,
                          color: COLOR_WHITE,
                          fontSize: FONT_SIZE_NORMAL,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextCustom(
                        text: "Tiến độ",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      const SizedBox(height: 5),
                      TextCustom(
                        text: value['projecttaskprogress']!,
                        color: COLOR_BLACK,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextCustom(
                          text: "Mô tả",
                          color: COLOR_BLACK,
                          fontSize: FONT_SIZE_NORMAL,
                          fontWeight: FontWeight.w700,
                        ),
                        const SizedBox(height: 10),
                        ExpandableText(text: value['description']!),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return projectTaskModel != null
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              shadowColor: Colors.transparent,
              backgroundColor: COLOR_WHITE,
              iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
              actions: <Widget>[
                MenuSetting(
                  onItemSelected: (value) {
                    if (value == "Chỉnh sửa") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateProjectTaskDetail(data: widget.data),
                        ),
                      );
                    } else if (value == "Xoá") {
                      print("Xoá ở đây");
                      Navigator.pop(context);
                    }
                  },
                ),
                const SizedBox(
                  width: 15,
                ),
              ],
              title: Text(
                projectTaskModel!.projecttaskname!,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_SMALL_TITLE,
                  color: COLOR_TEXT_MAIN,
                ),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                              text: "Giao cho",
                              color: COLOR_TEXT_MAIN,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 5),
                            TextCustom(
                              text: 'Bùi Quang Thành',
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextCustom(
                              text: "Ngày kết thúc dự kiến",
                              color: COLOR_TEXT_MAIN,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            TextCustom(
                              text: projectTaskModel!.end_date_plan!,
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextCustom(
                              text: "Thời gian dự kiến",
                              color: COLOR_TEXT_MAIN,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                            const SizedBox(height: 5),
                            TextCustom(
                              text: projectTaskModel!.leadtime!,
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 25,
                      ),
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
                            TextCustom(
                              text: projectTaskModel!
                                      .projecttaskprogress!.isNotEmpty
                                  ? projectTaskModel!.projecttaskprogress!
                                  : '0%',
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_NORMAL,
                              fontWeight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Expanded(
                      child: DefaultTabController(
                    length: 4,
                    child: Container(
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
                              fontSize: FONT_SIZE_NORMAL),
                          unselectedLabelColor: COLOR_GRAY,
                          tabs: const [
                            Tab(
                              text: 'Tổng quan',
                            ),
                            Tab(
                              text: 'Checklist',
                            ),
                            Tab(
                              text: 'Bình luận',
                            ),
                            Tab(
                              text: 'Tài liệu',
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const TextCustom(
                                    text: "Thông tin chung",
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Dự án",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text: projectTaskModel!
                                                  .projectid_label!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Hạng mục dự án",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text: projectTaskModel!
                                                  .related_cpprojectitem_label!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Ngày bắt đầu kế hoạch",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            SizedBox(height: 5),
                                            TextCustom(
                                              text: projectTaskModel!
                                                  .start_date_plan!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Ngày kết thúc kế hoạch",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text: projectTaskModel!
                                                  .end_date_plan!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Ngày bắt đầu",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text:
                                                  projectTaskModel!.startdate!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Ngày kết thúc ",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text: projectTaskModel!.enddate!,
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 25),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Trạng thái",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 10),
                                              decoration: BoxDecoration(
                                                  color: stateColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15)),
                                              child: TextCustom(
                                                text: statusText,
                                                color: COLOR_WHITE,
                                                fontSize: FONT_SIZE_NORMAL,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextCustom(
                                              text: "Độ ưu tiên ",
                                              color: COLOR_TEXT_MAIN,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            const SizedBox(height: 5),
                                            TextCustom(
                                              text: priortity.isNotEmpty
                                                  ? priortity
                                                  : 'Không xác định',
                                              color: COLOR_BLACK,
                                              fontSize: FONT_SIZE_NORMAL,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  const TextCustom(
                                    text: "Mô tả",
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  const SizedBox(height: 10),
                                  ExpandableText(
                                      text: projectTaskModel!.description!),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const TextCustom(
                                        text: "Báo cáo tiến độ",
                                        color: COLOR_BLACK,
                                        fontSize: FONT_SIZE_NORMAL,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              builder: (BuildContext context) =>
                                                  BottomSheetReportProgress(
                                                    update: (Map<String, String>
                                                        value) {
                                                      String status = '';
                                                      if (value[
                                                              'projecttaskstatus'] ==
                                                          'Đang tiến hành') {
                                                        status = 'In Progress';
                                                      } else if (value[
                                                              'projecttaskstatus'] ==
                                                          'Kế hoạch') {
                                                        status = 'plan';
                                                      } else if (value[
                                                              'projecttaskstatus'] ==
                                                          'Hoàn thành') {
                                                        status = 'Completed';
                                                      }

                                                      progressReport.insert(
                                                          0, value);
                                                      var data = json.encode({
                                                        "data": {
                                                          "progressreport":
                                                              progressReport
                                                                  .toString(),
                                                          "projecttaskstatus":
                                                              status,
                                                          "projecttaskprogress":
                                                              "${value['projecttaskprogress']}%",
                                                        }
                                                      });

                                                      updateProgressData(data);

                                                      Navigator.pop(context);
                                                    },
                                                  ));
                                        },
                                        child: const Icon(
                                          Icons.add,
                                          color: COLOR_BLACK,
                                          size: 30,
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: progressReport.length,
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            _showDialog(
                                                context, progressReport[index]);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                bottom: 8),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 6),
                                            decoration: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(5)),
                                              color: Color.fromARGB(
                                                  255, 233, 233, 233),
                                            ),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      'Tiến độ ngày: ${progressReport[index]['time']}'),
                                                  Text(
                                                      'Tiến độ: ${progressReport[index]['projecttaskprogress']}'
                                                          .toString())
                                                ]),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  BlocBuilder<ReportProgressBloc,
                                      ReportProgressState>(
                                    builder: (context, state) {
                                      if (state is ReportProgressInitial) {
                                        return Container();
                                      } else {
                                        return Container();
                                      }
                                    },
                                  )
                                ],
                              ),
                              projectTaskModel != null
                                  ? CheckList(
                                      checkListTask: parseJsonString(
                                        projectTaskModel!.checklist!,
                                      ),
                                      projectTaskId: projectTaskModel!.id!,
                                    )
                                  : Container(),
                              StatefulBuilder(
                                builder: (context, setCommentState) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            maxLines: 2,
                                            controller: commentController,
                                            cursorColor: COLOR_TEXT_MAIN,
                                            style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontSize: FONT_SIZE_TEXT_BUTTON,
                                              color: COLOR_TEXT_MAIN,
                                            ),
                                            onChanged: (value) {
                                              // project.description = value;
                                            },
                                            decoration: const InputDecoration(
                                              hintText: 'Nhập bình luận...',
                                              isDense: true,
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 5),
                                              border: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: COLOR_GRAY),
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: COLOR_GRAY),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: COLOR_GRAY),
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            if (commentController
                                                .text.isNotEmpty) {
                                              var data = json.encode({
                                                "data": {
                                                  "commentcontent":
                                                      commentController.text,
                                                  "related_to":
                                                      projectTaskModel!.id,
                                                  "modifiedtime": DateFormat(
                                                          'yyyy-MM-dd HH:mm:ss')
                                                      .format(DateTime.now()),
                                                  "parent_comments": "0",
                                                  "assigned_user_id": "1",
                                                }
                                              });
                                              postCommentData(data);
                                              commentController.text = '';
                                            }
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            width: 46,
                                            height: 46,
                                            decoration: const BoxDecoration(
                                              color: COLOR_DONE,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(30),
                                              ),
                                            ),
                                            child: const Row(
                                              children: [
                                                SizedBox(
                                                  width: 13,
                                                ),
                                                Icon(
                                                  Icons.send,
                                                  size: 24,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const TextCustom(
                                        text: 'Bình luận gần đây',
                                        color: COLOR_TEXT_MAIN,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                    Expanded(
                                        child: ListView.builder(
                                            // shrinkWrap: true,
                                            itemCount: commentList.length,
                                            itemBuilder: (context, index) {
                                              return CommentWidget(
                                                comment: commentList[index],
                                                onReply: (String commnent,
                                                    String parrentComment) {
                                                  var data = json.encode({
                                                    "data": {
                                                      "commentcontent":
                                                          commnent,
                                                      "related_to":
                                                          projectTaskModel!.id,
                                                      "modifiedtime": DateFormat(
                                                              'yyyy-MM-dd HH:mm:ss')
                                                          .format(
                                                              DateTime.now()),
                                                      "parent_comments":
                                                          parrentComment,
                                                      "assigned_user_id": "1",
                                                    }
                                                  });
                                                  postCommentData(data);
                                                },
                                                onUpdate: (content, commentId) {
                                                  var data = json.encode({
                                                    "data": {
                                                      "commentcontent": content,
                                                      "assigned_user_id": "1",
                                                    }
                                                  });
                                                  editCommentData(
                                                      data, commentId);
                                                },
                                              );
                                            })),
                                  ],
                                ),
                              ),
                              const Text('Tài liệu'),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ))
                ],
              ),
            ),
          )
        : Container();
  }

  List<Map<String, String>> parseJsonString(String jsonString) {
    if (jsonString.length > 3) {
      jsonString =
          jsonString.substring(1, jsonString.length - 1); // Loại bỏ "[" và "]"
      List<String> jsonItems = jsonString.split('},');

      List<Map<String, String>> result = [];

      for (String item in jsonItems) {
        String cleanedItem = item.replaceAll('{', '').replaceAll('}', '');
        List<String> keyValuePairs = cleanedItem.split(',');

        Map<String, String> map = {};

        for (String keyValue in keyValuePairs) {
          List<String> parts = keyValue.split(':');
          String key = parts[0].replaceAll("'", "").trim();
          String value = parts[1].replaceAll("'", "").trim();
          map[key] = value;
        }

        result.add(map);
      }

      return result;
    }
    return [];
  }
}

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;

  ExpandableText({required this.text, this.maxLines = 3});

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.text,
            maxLines: _isExpanded ? null : widget.maxLines,
            overflow: _isExpanded ? null : TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: FONT_SIZE_NORMAL,
              color: COLOR_TEXT_MAIN,
            )),
        TextButton(
          child: Text(_isExpanded ? 'Xem ít hơn' : 'Xem thêm',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: FONT_SIZE_NORMAL,
                color: COLOR_GREEN,
              )),
          onPressed: _toggleExpanded,
        ),
      ],
    );
  }
}
