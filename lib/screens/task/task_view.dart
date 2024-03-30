import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import '../../constants/font.dart';
import '../../routers/route_name.dart';
import '../../widgets/floating_add_button.dart';
import '../home_page/menu/menu_option.dart';
import 'personal/personal_page.dart';

class TaskView extends StatefulWidget {
  const TaskView({super.key});

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  void showOptionsDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const MenuOption();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_WHITE,
      appBar: AppBar(
        elevation: 0,
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
        automaticallyImplyLeading: false,
        centerTitle: false,
        backgroundColor: COLOR_WHITE,
        title: Text('Tác vụ cá nhân',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w700,
                fontSize: FONT_SIZE_BIG_TITLE,
                color: COLOR_TEXT_MAIN)),
      ),
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pushNamed(context, AppRouterName.AddPersonalTaskPage);
        },
        child: const FloatingAddButton(
            title: "Thêm tác vụ", marginBottom: 10, width: 150),
      ),
      // FloatingActionButton.extended(
      //   onPressed: () {
      //     // Hành động khi nhấn vào FloatingActionButton
      //     // Ví dụ: Navigator.pop(context);
      //     Navigator.pushNamed(context, AppRouterName.AddPersonalTaskPage);
      //   },
      //   icon: const Icon(Icons.add,
      //       color: COLOR_WHITE), // Icon của FloatingActionButton
      //   label: Text(
      //     'Thêm tác vụ',
      //     style: GoogleFonts.montserrat(
      //         fontWeight: FontWeight.w700,
      //         fontSize: FONT_SIZE_NORMAL,
      //         color: COLOR_WHITE),
      //   ), // Nhãn của FloatingActionButton
      //   backgroundColor: COLOR_GREEN,
      // ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: const PersonalTab(),
    );
  }
}
