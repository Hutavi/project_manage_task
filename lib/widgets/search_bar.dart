import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/color.dart';
import '../constants/font.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({
    super.key,
    required this.showFilter,
    required this.placeHolder,
    required this.onChanged,
  });

  final String placeHolder;
  final void Function() showFilter;
  final void Function(String value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            constraints: const BoxConstraints(
              maxHeight: 50,
            ),
            child: SearchBar(
              elevation: const MaterialStatePropertyAll(0),
              shadowColor: const MaterialStatePropertyAll(
                  Color.fromARGB(100, 235, 235, 235)),
              backgroundColor:
                  const MaterialStatePropertyAll(COLOR_GRAY_SEARCH),
              shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6))),
              side: const MaterialStatePropertyAll(
                BorderSide(
                  width: 1,
                  color: Color.fromARGB(255, 186, 186, 186),
                ),
              ),
              trailing: [
                InkWell(
                  child: const Icon(
                    Icons.search,
                    color: COLOR_TEXT_MAIN,
                  ),
                  onTap: () {
                    print('search');
                  },
                )
              ],
              textStyle: MaterialStatePropertyAll(
                GoogleFonts.montserrat(
                    fontWeight: FontWeight.w600,
                    fontSize: FONT_SIZE_NORMAL,
                    color: COLOR_TEXT_MAIN),
              ),
              padding: const MaterialStatePropertyAll(
                  EdgeInsets.symmetric(horizontal: 10, vertical: 0)),
              hintText: placeHolder,
              hintStyle: MaterialStatePropertyAll(
                GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: FONT_SIZE_NORMAL,
                    color: const Color.fromARGB(255, 179, 179, 179)),
              ),
              onChanged: (value) {
                onChanged(value);
              },
            ),
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        InkWell(
          onTap: showFilter,
          child: const Icon(
            Icons.filter_list_alt,
            size: 28,
            color: COLOR_TEXT_MAIN,
          ),
        )
      ],
    );
  }
}
