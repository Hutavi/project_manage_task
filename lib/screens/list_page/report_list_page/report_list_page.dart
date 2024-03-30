import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/screens/list_page/report_list_page/report_item.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../widgets/custom_sort_bar.dart';
import '../../../widgets/floating_add_button.dart';
import '../../../widgets/search_bar.dart';

class ReportListPage extends StatelessWidget {
  const ReportListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: COLOR_WHITE,
        iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
        title: Text(
          'Danh sách báo cáo',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: FONT_SIZE_SMALL_TITLE,
            color: COLOR_TEXT_MAIN,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 21, left: 15, right: 15, bottom: 0),
        child: Column(
          children: [
            CustomSearchBar(
              showFilter: () {},
              placeHolder: 'Tên báo cáo...',
              onChanged: (String value) {
                print(value);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            CustomSortBar(
              labelName: 'Danh sách báo cáo',
              filterOptionList: const ['Ngày tăng dần', 'Ngày giảm dần'],
              selectedItem: (String value) {
                print(value);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...reportList.map(
                      (e) => Column(
                        children: [
                          ReportItem(data: e),
                          const SizedBox(
                            height: 14,
                          )
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/createReport');
        },
        child: const FloatingAddButton(
          title: 'Thêm báo cáo',
          width: 180,
          marginBottom: 10,
        ),
      ),
    );
  }
}
