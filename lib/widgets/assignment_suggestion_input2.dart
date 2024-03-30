// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/models/user/user_model.dart';
import 'package:management_app/widgets/text_custom.dart';

class AssignmentSuggestionInput extends StatefulWidget {
  const AssignmentSuggestionInput({
    Key? key,
    required this.placeHolder,
    required this.chooseAssign,
    this.assignList,
  }) : super(key: key);

  final String placeHolder;
  final void Function(UserModel value) chooseAssign;
  final List<UserModel>? assignList;

  @override
  State<AssignmentSuggestionInput> createState() =>
      _AssignmentSuggestionInputState();
}

class _AssignmentSuggestionInputState extends State<AssignmentSuggestionInput> {
  final inputController = TextEditingController();

  List<UserModel> assignSuggestion(String value) {
    List<UserModel> suggestion = [];
    if (value.isNotEmpty) {
      for (final i in widget.assignList!) {
        if (i.user_name!.toLowerCase().contains(value.toLowerCase())) {
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
          text: suggestion.user_name!,
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w500,
          color: COLOR_TEXT_MAIN,
        ),
      ),
      suggestionsCallback: (pattern) {
        List<UserModel> matches = assignSuggestion(pattern);
        return matches;
      },
    );
  }
}
