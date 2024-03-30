import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/constants/image_assets.dart';
import 'package:management_app/models/category/category_project_model.dart';
import 'package:management_app/screens/details_page/detail_category/overview_tab/overview_tab.dart';
import 'package:management_app/screens/details_page/detail_category/task_list_tab/task_list_tab.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../services/dio_client.dart';

class DetailCategory extends StatefulWidget {
  final int initialTab;
  const DetailCategory({super.key, this.initialTab = 0, required this.id});
  final Object id;

  @override
  State<DetailCategory> createState() => _DetailCategoryState();
}

void _handleTapOutside(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
    currentFocus.unfocus();
  }
}

class _DetailCategoryState extends State<DetailCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTapOutside(context),
      child: DefaultTabController(
          length: 2,
          initialIndex: widget.initialTab,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              backgroundColor: COLOR_WHITE,
              elevation: 0,
              // toolbarHeight: 50,
              title: const TextCustom(
                  text: "Chi tiết hạng mục",
                  color: COLOR_TEXT_MAIN,
                  fontSize: FONT_SIZE_SMALL_TITLE,
                  fontWeight: FontWeight.w600),
              centerTitle: true,
              automaticallyImplyLeading: true,
              iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),

              actions: <Widget>[
                IconButton(
                    padding: const EdgeInsets.only(right: 10),
                    icon: Image.asset(
                      IC_EDIT,
                      width: 24,
                      height: 24,
                    ),
                    onPressed: () {})
              ],
              bottom: TabBar(
                indicatorColor: COLOR_GREEN,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                labelColor: COLOR_GREEN,
                labelStyle: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w700, fontSize: FONT_SIZE_BIG),
                unselectedLabelColor: COLOR_GRAY,
                tabs: const [
                  Tab(
                    text: "Tổng quan",
                  ),
                  Tab(
                    text: "Danh sách tác vụ",
                  ),
                ],
              ),
            ),
            body: TabBarView(children: [
              OverviewTab(
                id: widget.id.toString(),
              ),
              TaskListTab(id: widget.id.toString())
            ]),
          )),
    );
  }
}
