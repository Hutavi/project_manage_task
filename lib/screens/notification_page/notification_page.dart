import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/screens/notification_page/activity_tab.dart';
import 'package:management_app/screens/notification_page/update_tab.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../widgets/text_custom.dart';
import '../home_page/menu/menu_option.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key, this.initialTab = 0}) : super(key: key);
  final int initialTab;

  @override
  _NoficationPageState createState() => _NoficationPageState();
}

class _NoficationPageState extends State<NotificationPage> {
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
          title: const Text('Thông báo'),
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
                text: 'Cập nhật',
              ),
              Tab(
                text: 'Hoạt động',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            UpdateTab(),
            ActivityTab(),
          ],
        ),
      ),
    );
  }
}
