import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../constants/color.dart';
import '../constants/font.dart';

class CustomSortBar extends StatefulWidget {
  const CustomSortBar(
      {Key? key,
      this.labelName,
      required this.filterOptionList,
      required this.selectedItem})
      : super(key: key);

  final String? labelName;
  final List<String> filterOptionList;
  final void Function(String item) selectedItem;

  @override
  _CustomSortBarState createState() => _CustomSortBarState();
}

class _CustomSortBarState extends State<CustomSortBar> {
  String? filterIndex;

  void setFilter(String value) {
    widget.selectedItem(value);
    setState(() {
      filterIndex = value;
    });
  }

  @override
  void initState() {
    filterIndex = widget.filterOptionList[0];
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.labelName ?? '',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w700,
            fontSize: FONT_SIZE_BIG,
            color: COLOR_TEXT_MAIN,
          ),
        ),
        PopupMenuButton<String>(
          child: Row(
            children: [
              Image.asset(
                'lib/assets/images/home_page/sort_icon.png',
                width: 18,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                filterIndex!,
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_TEXT_MAIN,
                ),
              )
            ],
          ),
          onSelected: (value) {
            setFilter(value);
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            ...widget.filterOptionList.map(
              (e) => PopupMenuItem<String>(
                value: e,
                child: TextCustom(
                  text: e,
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
