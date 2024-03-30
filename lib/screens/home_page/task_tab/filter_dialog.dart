import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key, required this.setFilter}) : super(key: key);

  final void Function(String filter) setFilter;
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  static List<String> filter_list = [
    'Hôm nay',
    'Tuần này',
    'Tuần trước',
    'Tháng này',
    'Tháng trước',
  ];
  String filter_index = filter_list.first;
  void changeFilter(String e) {
    setState(() {
      widget.setFilter(e);
      filter_index = e;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              top: 150,
              right: 0,
              child: SizedBox(
                width: screenSize.width * 0.85,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                  child: Material(
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              'Tuỳ chọn thời gian',
                              style: GoogleFonts.montserrat(
                                color: COLOR_BLACK,
                                fontSize: FONT_SIZE_BIG,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ...filter_list.map(
                              (e) => InkWell(
                                onTap: () {
                                  changeFilter(e);
                                  print(e);
                                  // Navigator.pop(context);
                                },
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 15),
                                  color: (filter_index == e)
                                      ? const Color.fromARGB(20, 144, 144, 144)
                                      : Colors.transparent,
                                  child: Text(
                                    e,
                                    style: GoogleFonts.montserrat(
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_NORMAL,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: COLOR_GREEN,
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Xong',
                                  style: GoogleFonts.montserrat(
                                    color: COLOR_WHITE,
                                    fontSize: FONT_SIZE_TEXT_BUTTON,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
