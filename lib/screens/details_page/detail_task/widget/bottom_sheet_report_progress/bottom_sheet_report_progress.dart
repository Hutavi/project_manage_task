import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/font.dart';
import '../../../../../data/data.dart';
import '../../../../../widgets/text_custom.dart';

class BottomSheetReportProgress extends StatefulWidget {
  const BottomSheetReportProgress({super.key, required this.update});

  final void Function(Map<String, String> value) update;

  @override
  State<BottomSheetReportProgress> createState() =>
      _BottomSheetReportProgressState();
}

class _BottomSheetReportProgressState extends State<BottomSheetReportProgress> {
  final _formKey = GlobalKey<FormState>();
  String? selectedStatus;
  String? selectedProgress;
  String? description = '';
  int? originalMaxLines;
  int? maxLines;

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextCustom(
              text: "Báo cáo tiến độ",
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_NORMAL_TITLE,
              fontWeight: FontWeight.w700,
            ),
            SizedBox(height: 10),
            Form(
              key: _formKey,
              child: Row(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  statusWidget(),
                  const SizedBox(
                    width: 20,
                  ),
                  progressWidget(),
                ],
              ),
            ),
            buildDescription(),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String date =
                          DateFormat('yyyy-MM-dd').format(DateTime.now());
                      widget.update({
                        'time': date,
                        'projecttaskprogress': selectedProgress!,
                        'projecttaskstatus': selectedStatus!,
                        'description': description!,
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')));
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(COLOR_GREEN)),
                  child: Container(
                    child: const TextCustom(
                      text: "Cập nhật",
                      color: COLOR_WHITE,
                      fontSize: FONT_SIZE_NORMAL,
                      fontWeight: FontWeight.w700,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  Widget buildDescription() {
    return StatefulBuilder(
      builder: (context, setStateDescription) {
        return Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  "Mô tả",
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    color: COLOR_TEXT_MAIN,
                  ),
                ),
              ),
              TextFormField(
                onChanged: (value) {
                  description = value;
                  setStateDescription(() {
                    // Store the original maxLines value
                    originalMaxLines = maxLines;
                    // Calculate the new maxLines value based on the content length
                    int newMaxLines = value.length ~/
                            (MediaQuery.of(context).size.width * 0.1) +
                        1;

                    // Ensure the newMaxLines value is between 1 and 3
                    maxLines = newMaxLines.clamp(1, 3);
                  });
                },
                maxLines: maxLines,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget statusWidget() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Trạng thái',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                '*',
                style: TextStyle(color: COLOR_LATE),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            onChanged: (newValue) {
              selectedStatus = newValue;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return 'Chọn 1 loại';
              }
            },
            selectedItem: selectedStatus,
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isSelected) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: FONT_SIZE_TEXT_BUTTON,
                      color: isSelected ? COLOR_GREEN : COLOR_TEXT_MAIN,
                    ),
                  ),
                );
              },
              fit: FlexFit.loose,
              // showSelectedItems: true,
            ),
            items: stateOptionList,
            ///////////////// ========================
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                color: COLOR_BLACK,
              ),
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Chọn một giá trị',
                hintStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_LATE),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                focusedErrorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_GRAY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_GRAY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_GRAY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget progressWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Tiến độ',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
              ),
              const SizedBox(
                width: 2,
              ),
              const Text(
                '*',
                style: TextStyle(color: COLOR_LATE),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            onChanged: (value) {
              selectedProgress = value;
            },
            validator: (value) {
              if (value == null) {
                return 'Chọn 1 loại';
              }
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            popupProps: PopupProps.menu(
              itemBuilder: (context, item, isSelected) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
                  child: Text(
                    item,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w500,
                      fontSize: FONT_SIZE_TEXT_BUTTON,
                      color: isSelected ? COLOR_GREEN : COLOR_TEXT_MAIN,
                    ),
                  ),
                );
              },
              showSelectedItems: true,
            ),
            items: progresses,
            selectedItem: selectedProgress,
            dropdownDecoratorProps: DropDownDecoratorProps(
              baseStyle: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                color: COLOR_BLACK,
              ),
              dropdownSearchDecoration: InputDecoration(
                hintText: 'Chọn một giá trị',
                hintStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_GRAY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: COLOR_GRAY),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
