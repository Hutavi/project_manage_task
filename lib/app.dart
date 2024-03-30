import 'package:flutter/material.dart';
import 'package:management_app/routers/route.dart';
import 'package:management_app/screens/create_page/create_project_task/create_quick.dart';
import 'package:management_app/screens/calendar_page/calendar_page.dart';
import 'package:management_app/screens/create_page/create_category/create_category.dart';
import 'package:management_app/screens/create_page/create_report/create_report.dart';
import 'package:management_app/screens/home_page/home_page.dart';
import 'package:management_app/screens/list_page/project_list_page/project_list_page.dart';
// import 'package:management_app/screens/detail_project/detail_project_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Management App',
      debugShowCheckedModeBanner: false,
      // theme: AppThemes.lightTheme,
      initialRoute: '/navigation',
      // home: ProjectListPage(),
      // home: CreateProjectTask(),
      // home: CalendarPage(),
      // home: DetailProjectPage(),
      // home: CreateReportPage(),
      // home: HomePage(),
      // initialRoute: '/HomePage',
      // home: DetailProjectPage(),
      // darkTheme: AppThemes.darkTheme,
      onGenerateRoute: AppRoute.onGenerateRoute,
    );
  }
}
