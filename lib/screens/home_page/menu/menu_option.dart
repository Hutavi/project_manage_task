import 'package:flutter/material.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../data/data.dart';
import '../../list_page/category_list_page/category_list_page.dart';
import '../../list_page/report_list_page/report_list_page.dart';

class MenuOption extends StatelessWidget {
  const MenuOption({super.key});
  static final List<Widget> _pages = <Widget>[
    const ReportListPage(),
    const ReportListPage(),
    const ReportListPage(),
    const CategoryListPage(),
    const ReportListPage(),
    const ReportListPage(),
    const ReportListPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.topRight,
      widthFactor: 0.8,
      heightFactor: 0.68,
      child: Material(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              // height: 700,
              width: 320,
              decoration: const BoxDecoration(
                color: COLOR_WHITE,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Image.asset(
                          "lib/assets/images/home_page/options_dialog/avatar.png",
                          width: 45,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextCustom(
                                text: 'Đinh Nguyễn Duy Khang',
                                fontWeight: FontWeight.w700,
                                fontSize: FONT_SIZE_SMALL_TITLE,
                                color: COLOR_BLACK),
                            SizedBox(
                              height: 2,
                            ),
                            TextCustom(
                                text: 'Mobile developer',
                                color: COLOR_BLACK,
                                fontSize: FONT_SIZE_NORMAL,
                                fontWeight: FontWeight.w500),
                          ],
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: optionsData.length,
                    itemBuilder: (context, index) {
                      final e = optionsData[index];
                      return InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, e['router'].toString());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1, color: COLOR_GRAY),
                            ),
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                e['icon'].toString(),
                                width: 21,
                                height: 21,
                              ),
                              const SizedBox(width: 15),
                              TextCustom(
                                text: e['title'].toString(),
                                color: COLOR_TEXT_MAIN,
                                fontSize: FONT_SIZE_NORMAL,
                                fontWeight: FontWeight.w600,
                              ),
                              const Spacer(),
                              Image.asset(
                                'lib/assets/images/home_page/options_dialog/arrow_icon.png',
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, left: 20, right: 15),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 1, color: COLOR_GRAY),
                      ),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: Row(
                        children: [
                          Image.asset(
                            'lib/assets/images/home_page/options_dialog/logout_icon.png',
                            width: 21,
                            height: 21,
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          const TextCustom(
                            text: 'Đăng xuất',
                            color: COLOR_LATE,
                            fontSize: FONT_SIZE_NORMAL,
                            fontWeight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
