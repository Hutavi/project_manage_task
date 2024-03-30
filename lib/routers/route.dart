import 'package:flutter/material.dart';
import 'package:management_app/navigation/navigation.dart';
import 'package:management_app/screens/authen_page/authen_page.dart';
import 'package:management_app/screens/calendar_page/bottom_sheet_calendar/bottom_sheet_widget.dart';
import 'package:management_app/screens/calendar_page/bottom_sheet_calendar/create_event_calendar.dart';
import 'package:management_app/screens/create_page/create_category/create_category.dart';
import 'package:management_app/screens/create_page/create_project/create_project.dart';
import 'package:management_app/screens/create_page/create_project_task/create_quick.dart';
import 'package:management_app/screens/create_page/create_report/create_report_view.dart';
import 'package:management_app/screens/details_page/detail_category/detail_category.dart';
import 'package:management_app/screens/details_page/detail_task/detail_task_view.dart';
import 'package:management_app/screens/intro/intro_screen.dart';
import 'package:management_app/screens/list_page/leaving_list_page/leaving_list_page.dart';
import 'package:management_app/screens/list_page/project_list_page/project_list_page.dart';
import 'package:management_app/screens/list_page/report_list_page/report_list_page.dart';
import 'package:management_app/screens/list_page/task_list_page/task_list_page.dart';
import 'package:management_app/screens/profile_page/profile_page.dart';
import 'package:management_app/screens/setting_page/setting_page.dart';
import 'package:management_app/screens/splash/splash_page.dart';
import 'package:management_app/screens/task/task_page.dart';
import 'package:management_app/screens/calendar_page/calendar_page.dart';
import '../screens/create_page/create_cp_leaving/create_leaving_page.dart';
import '../screens/create_page/create_personal_task/add_personal_task_page.dart';
import '../screens/details_page/detail_project/detail_project_page.dart';
import '../screens/home_page/home_page.dart';
import '../screens/list_page/category_list_page/category_list_page.dart';
import 'route_name.dart';

class AppRoute {
  static Route onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    // check các điều kiện để trả về route tương ứng với settings.name
    switch (settings.name) {
      case AppRouterName.taskPage:
        return MaterialPageRoute(builder: (_) => const TaskPage());

      case AppRouterName.homePage:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRouterName.AddPersonalTaskPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const AddPersonalTaskPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.authenPage:
        return MaterialPageRoute(builder: (_) => const AuthenPage());
      case AppRouterName.introPage:
        return MaterialPageRoute(builder: (_) => const IntroPage());
      case AppRouterName.splashPage:
        return MaterialPageRoute(builder: (_) => const SplashPage());
      case AppRouterName.calendarPage:
        return MaterialPageRoute(builder: (_) => const CalendarPage());
      case AppRouterName.navigationPage:
        return MaterialPageRoute(builder: (_) => const NavigationBottom());
      case AppRouterName.createProject:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateProject(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.createProjectTask:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateProjectTask(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.creatReportPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateReportView(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.createProjectCategory:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateCategory(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.createLeavingPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateLeavingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.DetailProjectPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DetailProjectPage(
            data: args,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.detailCategory:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DetailCategory(id: args!),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.profilePage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProfilePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.createEvent:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CreateEventCalendar(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.listCategoryProject:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const CategoryListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.listReport:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ReportListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.listTaskProject:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const TaskListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.listLeaving:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const LeavingListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.settingPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const SettingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.todolistPage:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const NavigationBottom(initialIndex: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );

      case AppRouterName.listProject:
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const ProjectListPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      case AppRouterName.detailTask:
        final args = settings.arguments as String;
        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              DetailTaskView(data: args),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        );
      default:
        _errPage();
    }
    return _errPage();
  }

  static Route _errPage() {
    return MaterialPageRoute(builder: (_) {
      return const Scaffold(
        body: Center(
          child: Text('No Router! Please check your configuration'),
        ),
      );
    });
  }
}
