import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/screens/home_page/menu/menu_option.dart';
import 'package:management_app/screens/home_page/project_tab/project_tab.dart';
import 'task_tab/task_tab.dart';

class HomePage extends StatefulWidget {
  final int initialTab;
  const HomePage({super.key, this.initialTab = 0});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // fetchData();
    void showOptionsDialog() {
      showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return const MenuOption();
        },
      );
    }

    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: COLOR_WHITE,
          titleTextStyle: GoogleFonts.montserrat(
            color: COLOR_TEXT_MAIN,
            fontSize: FONT_SIZE_BIG_TITLE,
            fontWeight: FontWeight.bold,
          ),
          automaticallyImplyLeading: false,
          title: const Text('Trang chủ'),
          actions: <Widget>[
            IconButton(
              padding: const EdgeInsets.only(right: 10),
              icon: Image.asset(
                'lib/assets/images/home_page/options_button.png',
                height: 24,
                width: 24,
              ),
              onPressed: () {
                showOptionsDialog();
              },
            ),
          ],
          bottom: TabBar(
            indicatorColor: COLOR_GREEN,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            labelColor: COLOR_GREEN,
            labelStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700, fontSize: FONT_SIZE_BIG),
            unselectedLabelColor: COLOR_GRAY,
            tabs: const [
              Tab(
                text: 'Công việc',
              ),
              Tab(
                text: 'Dự án',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            TaskTab(),
            ProjectTab(),
          ],
        ),
      ),
    );
  }
}
