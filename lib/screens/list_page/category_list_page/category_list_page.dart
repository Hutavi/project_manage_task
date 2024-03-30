import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/screens/list_page/category_list_page/category_item.dart';
import 'package:management_app/widgets/custom_sort_bar.dart';
import 'package:management_app/widgets/floating_add_button.dart';
import 'package:management_app/widgets/search_bar.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({Key? key}) : super(key: key);

  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        shadowColor: Colors.transparent,
        backgroundColor: COLOR_WHITE,
        iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
        title: Text(
          'Danh sách hạng mục',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w600,
            fontSize: FONT_SIZE_SMALL_TITLE,
            color: COLOR_TEXT_MAIN,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
        child: Column(
          children: [
            CustomSearchBar(
              showFilter: () {},
              placeHolder: 'Tên hạng mục...',
              onChanged: (String value) {
                print(value);
              },
            ),
            const SizedBox(
              height: 24,
            ),
            CustomSortBar(
              labelName: 'Danh sách hạng mục',
              filterOptionList: const ['Tiến độ tăng dần', 'Tiến độ giảm dần'],
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
                    ...categoryList.map(
                      (e) => Column(
                        children: [
                          CategoryItem(data: e),
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
          Navigator.pushNamed(context, '/createProjectCategory');
        },
        child: const FloatingAddButton(
          title: 'Thêm hạng mục',
          width: 180,
          marginBottom: 10,
        ),
      ),
    );
  }
}
