import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/widgets/text_custom.dart';

class AssignmentSuggestionInput extends StatefulWidget {
  const AssignmentSuggestionInput({
    super.key,
    required this.placeHolder,
    required this.chooseAssign,
  });
  final String placeHolder;
  final void Function(String value) chooseAssign;
  @override
  State<AssignmentSuggestionInput> createState() =>
      _AssignmentSuggestionInputState();
}

class _AssignmentSuggestionInputState extends State<AssignmentSuggestionInput> {
  final inputController = TextEditingController();
  List<String> assignList = [
    'Bùi Quang Thành (bqthanh@gmail.com)',
    'Huỳnh Tấn Vinh (htvinh@gmail.com)',
    'Đinh Nguyễn Duy Khang (dndkhang@gmail.com)',
  ];
  List<String> assignSuggestion(String value) {
    List<String> suggestion = [];
    if (value.isNotEmpty) {
      for (final i in assignList) {
        if (i.toLowerCase().contains(value.toLowerCase())) {
          suggestion.add(i);
        }
      }
    }
    return suggestion;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: inputController,
        style: GoogleFonts.montserrat(
          color: const Color.fromARGB(255, 106, 106, 106),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: widget.placeHolder,
          hintStyle: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            color: COLOR_PLACE_HOLDER,
          ),
          isDense: true,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          border: const UnderlineInputBorder(
            borderSide: BorderSide(color: COLOR_GRAY),
          ),
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: COLOR_GRAY),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: COLOR_GRAY),
          ),
        ),
      ),
      animationStart: 0,
      animationDuration: Duration.zero,
      suggestionsBoxDecoration: const SuggestionsBoxDecoration(
        elevation: 3,
        shadowColor: Color.fromARGB(100, 212, 212, 212),
        borderRadius: BorderRadius.all(
          Radius.circular(6),
        ),
      ),
      noItemsFoundBuilder: (context) => Padding(
        padding: const EdgeInsets.all(15),
        child: Text(
          'Không tìm thấy...',
          style: GoogleFonts.montserrat(
            color: const Color.fromARGB(255, 106, 106, 106),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
      hideOnLoading: true,
      onSuggestionSelected: (suggestion) {
        inputController.text = '';
        widget.chooseAssign(suggestion);
      },
      itemBuilder: (ctx, suggestion) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextCustom(
          text: suggestion,
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w500,
          color: COLOR_TEXT_MAIN,
        ),
      ),
      suggestionsCallback: (pattern) {
        List<String> matches = assignSuggestion(pattern);
        return matches;
      },
    );
  }
}
