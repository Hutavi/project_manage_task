import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/screens/details_page/detail_task/detail_task_page.dart';
import 'package:management_app/widgets/text_custom.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../../models/category/category_project_model.dart';
import '../../../../services/dio_client.dart';

class OverviewTab extends StatefulWidget {
  const OverviewTab({super.key, required this.id});

  final String id;

  @override
  State<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends State<OverviewTab> {
  final TextEditingController textEditingController = TextEditingController();

  void _handleTapOutside(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  DateTime? dateTime;
  String createDate = '';
  double progress = 0;

  CategoryProjectModel? categoryProjectModel;
  void fetchData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/CloudworkApi.php',
        queryParameters: {
          'action': 'getProjectCategoryById',
          'record': widget.id,
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        categoryProjectModel = CategoryProjectModel.fromMap(parsed['data']);
        dateTime = DateTime.parse(categoryProjectModel!.createdtime!);
        createDate =
            '${dateTime!.year}-${dateTime!.month.toString().padLeft(2, '0')}-${dateTime!.day.toString().padLeft(2, '0')}';
        progress = categoryProjectModel!.progress != 'NAN'
            ? double.parse(categoryProjectModel!.progress!.toString())
            : 0;
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
    return GestureDetector(
      onTap: () => _handleTapOutside(context),
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        resizeToAvoidBottomInset: true,
        body: categoryProjectModel != null
            ? Padding(
                padding: const EdgeInsets.only(
                    top: 21, left: 15, right: 15, bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tiến độ',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: FONT_SIZE_NORMAL),
                    ),
                    const Divider(
                      color: COLOR_GRAY,
                    ),
                    const SizedBox(
                      height: 10,
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
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Thông tin chung',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: FONT_SIZE_NORMAL),
                    ),
                    const Divider(
                      color: COLOR_GRAY,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextCustom(
                                    text: "Dự án",
                                    color: COLOR_TEXT_MAIN,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextCustom(
                                    text: categoryProjectModel!
                                        .related_project_label!,
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                                const SizedBox(
                                  height: 16,
                                ),
                                const TextCustom(
                                    text: "Hang mục",
                                    color: COLOR_TEXT_MAIN,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextCustom(
                                    text: categoryProjectModel!.name!,
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 10.0, 0, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const TextCustom(
                                    text: "Ngày tạo",
                                    color: COLOR_TEXT_MAIN,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextCustom(
                                    text: createDate,
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                                const SizedBox(
                                  height: 16,
                                ),
                                const TextCustom(
                                  text: "Người phụ trách",
                                  color: COLOR_TEXT_MAIN,
                                  fontSize: FONT_SIZE_NORMAL,
                                  fontWeight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                TextCustom(
                                    text:
                                        categoryProjectModel!.main_owner_name!,
                                    color: COLOR_BLACK,
                                    fontSize: FONT_SIZE_NORMAL,
                                    fontWeight: FontWeight.w600),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Mô tả',
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: FONT_SIZE_NORMAL),
                    ),
                    const Divider(
                      color: COLOR_GRAY,
                    ),
                    ExpandableText(text: categoryProjectModel!.description!),
                  ],
                ),
              )
            : Container(),
      ),
    );
  }
}
