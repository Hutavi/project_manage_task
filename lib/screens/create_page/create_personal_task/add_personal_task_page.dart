import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/services/dio_client.dart';
import '../../../constants/font.dart';
import '../../../data/data.dart';
import '../../home_page/task_tab/cancel_dialog.dart';

class AddPersonalTaskPage extends StatefulWidget {
  final data;
  const AddPersonalTaskPage({super.key, this.data});

  @override
  State<AddPersonalTaskPage> createState() => _AddPersonalTaskPageState();
}

class _AddPersonalTaskPageState extends State<AddPersonalTaskPage> {
  final Set<String> selectedStatuses = {};
  final Set<String> selectedPriorities = {};
  final _controller_title = TextEditingController();
  final _controller_description = TextEditingController();

  final _controller_progress = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller_progress.dispose();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();

  String title = '';
  String description = '';

  String? selectedPriority, selectedStatus, selectedProgress;
  String? startDate;
  String? finishDate;
  int? originalMaxLines;
  int? maxLines;

  @override
  void initState() {
    // TODO: implement initState

    if (widget.data != null) {
      _controller_description.text = widget.data['description'];
      _controller_title.text = widget.data['task-name'];
      selectedPriorities.add(widget.data['priority']);
      startDate = widget.data['startDay'];
      finishDate = widget.data['finishDay'];
      _controller_progress.text = widget.data['progress'];

      selectedStatuses.add(widget.data['state']);
    }
    startDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    super.initState();
  }

  void _presentDatePicker(String type, FormFieldState<String> field) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final ThemeData themeData = ThemeData(
      primarySwatch: Colors.green, // This changes the header color
      dialogBackgroundColor:
          Colors.grey.shade100, // This changes the background color
    );
    final pickedDate = await showDatePicker(
      helpText: "Chọn ngày",
      confirmText: "Chọn",
      cancelText: "Huỷ",
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2, now.month, now.day),
      builder: (context, child) {
        return Theme(
          data: themeData,
          child: child!,
        );
      },
    );

    setState(
      () {
        if (type == 'startDate') {
          startDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(startDate);
        } else if (type == 'finishDate') {
          finishDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(finishDate);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: buildSaveAndCancelButton(),
        appBar: AppBar(
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // if (project.checkNullValue()) {
              showCancelDialog(context);
              // } else {
              //   Navigator.pop(context);
              // }
            },
          ),
          iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
          backgroundColor: COLOR_WHITE,
          title: Text(
            "Tạo tác vụ cá nhân",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: FONT_SIZE_SMALL_TITLE,
                color: COLOR_BLACK),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildTitle(),
                      const SizedBox(height: 15),
                      buildPriority(),
                      const SizedBox(height: 15),
                      buildStatus(),
                      const SizedBox(height: 15),
                      buildStartDateAndFinishDate(),
                      const SizedBox(height: 15),
                      buildProgress(),
                      const SizedBox(height: 15),
                      buildDescription(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget buildTitle() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "Tiêu đề ",
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                color: COLOR_TEXT_MAIN,
              ),
            ),
            const Text(
              "*",
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        TextFormField(
          controller: _controller_title,
          onChanged: (value) {
            title = value;
          },
          decoration: const InputDecoration(
            isDense: true,
          ),
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Hãy điền tiêu đề';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget buildPrioritySelection(StateSetter setStatePriority) {
    return Wrap(
      spacing: 5,
      runSpacing: 10,
      children: priority_list.map(
        (item) {
          final isSelected = selectedPriorities.contains(item['label']);
          return ChoiceChip(
            label: Text(item['label'].toString(),
                style: GoogleFonts.montserrat(
                  color: !isSelected ? COLOR_TEXT_MAIN : COLOR_WHITE,
                  fontSize: FONT_SIZE_NORMAL,
                  fontWeight: FontWeight.w600,
                )),
            selected: isSelected,
            selectedColor: (item['color'] as Color).withOpacity(0.5),
            onSelected: (selected) {
              setStatePriority(() {
                if (selected) {
                  selectedPriorities.clear();
                  selectedPriorities.add(item['label'].toString());
                } else {
                  selectedPriorities.clear();
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget buildPriority() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Độ ưu tiên",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: COLOR_TEXT_MAIN,
            ),
          ),
        ),
        StatefulBuilder(
          builder: (context, setStatePriority) =>
              buildPrioritySelection(setStatePriority),
        ),
      ],
    );
  }

  Widget buildStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            "Tình trạng",
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: COLOR_TEXT_MAIN,
            ),
          ),
        ),
        StatefulBuilder(
          builder: (context, setStateStatus) =>
              buildStatusSelection(setStateStatus),
        ),
      ],
    );
  }

  Widget buildStatusSelection(StateSetter setStateStatus) {
    return Wrap(
      spacing: 2,
      runSpacing: 10,
      children: status_list.map(
        (status) {
          final isSelected = selectedStatuses.contains(status['label']);
          return ChoiceChip(
            label: Text(status['label'].toString(),
                style: GoogleFonts.montserrat(
                  color: !isSelected ? COLOR_TEXT_MAIN : Colors.white,
                  fontSize: FONT_SIZE_NORMAL,
                  fontWeight: FontWeight.w600,
                )),
            selected: isSelected,
            selectedColor: status['color'] as Color,
            onSelected: (selected) {
              setStateStatus(() {
                if (selected) {
                  selectedStatuses.clear();
                  selectedStatuses.add(status['label'].toString());
                } else {
                  selectedStatuses.clear();
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget buildStartDateAndFinishDate() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ngày bắt đầu',
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
              FormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (newValue) {
                  startDate = newValue;
                },
                validator: (value) {
                  if (startDate == null) {
                    return 'Hãy chọn ngày bắt đầu';
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  COLOR_TEXT_MAIN, // Đặt màu sắc của border ở cạnh dưới
                              width: 1.0, // Đặt độ dày của border
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              startDate == null ? 'Chọn 1 ngày' : startDate!,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: FONT_SIZE_TEXT_BUTTON,
                                color: COLOR_BLACK,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _presentDatePicker('startDate', field);
                              },
                              icon: Image.asset(
                                'lib/assets/images/create_project/pick_date_icon.png',
                                width: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (field.hasError) // Nếu có lỗi
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            textAlign: TextAlign.left,
                            field.errorText!, // Hiển thị lỗi
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ngày kết thúc',
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
              FormField<String>(
                validator: (value) {
                  if (finishDate == null) {
                    return 'Hãy chọn ngày kết thúc';
                  }
                  return null;
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  COLOR_TEXT_MAIN, // Đặt màu sắc của border ở cạnh dưới
                              width: 1.0, // Đặt độ dày của border
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              finishDate == null ? 'Chọn 1 ngày' : finishDate!,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: FONT_SIZE_TEXT_BUTTON,
                                color: COLOR_BLACK,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _presentDatePicker('finishDate', field);
                              },
                              icon: Image.asset(
                                'lib/assets/images/create_project/pick_date_icon.png',
                                width: 28,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (field.hasError) // Nếu có lỗi
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            field.errorText!, // Hiển thị lỗi
                            style: TextStyle(
                                fontSize: 11, color: Colors.red.shade700),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildProgress() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          "Tiến độ ",
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                            color: COLOR_TEXT_MAIN,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_TEXT_MAIN,
                        ),
                        controller: _controller_progress,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_LATE),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          hintText: 'Hãy nhập % tiến độ',
                          hintStyle: TextStyle(
                            color: COLOR_TEXT_MAIN,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(width: 5),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 0),
                        decoration: const BoxDecoration(
                          color: COLOR_CARD_BACKGROUND,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(8),
                            bottomRight: Radius.circular(8),
                          ),
                          border: Border(
                            top: BorderSide(color: Colors.grey, width: 1),
                            bottom: BorderSide(color: Colors.grey, width: 1),
                            right: BorderSide(color: Colors.grey, width: 1),
                            left: BorderSide(color: Colors.grey, width: 0),
                          ),
                        ),
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 11),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                            color: COLOR_TEXT_MAIN,
                          ),

                          // value: selectedProgress,
                          hint: const Text("Chọn %"),
                          underline: const SizedBox(),
                          items: progresses
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            selectedProgress = value;
                            _controller_progress.text = selectedProgress!;
                          },
                        ),
                      ),
                    ),
                    const Expanded(flex: 1, child: SizedBox()),
                  ]),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        controller: _controller_description,
        onChanged: (value) {
          description = value;
          setState(() {
            // Store the original maxLines value
            originalMaxLines = maxLines;
            // Calculate the new maxLines value based on the content length
            int newMaxLines =
                value.length ~/ (MediaQuery.of(context).size.width * 0.1) + 1;

            // Ensure the newMaxLines value is between 1 and 3
            maxLines = newMaxLines.clamp(1, 3);
          });
        },
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: 'Mô tả',
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSaveAndCancelButton() {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 25),
      decoration: const BoxDecoration(
        color: COLOR_WHITE,
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 220, 220, 220), // Màu của bóng đổ
            blurRadius: 5, // Bán kính của bóng đổ
            spreadRadius: 1, // Khoảng cách từ bóng đổ đến Container
            offset:
                Offset(0, 2), // Vị trí của bóng đổ (điểm bắt đầu từ Container)
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.red.shade100),
            ),
            onPressed: () {
              showCancelDialog(context);
            },
            child: Text(
              'Huỷ',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: FONT_SIZE_NORMAL,
                color: COLOR_LATE,
              ),
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(COLOR_GREEN),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                try {
                  if (selectedStatuses.first == "Kế hoạch") {
                    selectedStatuses.clear();
                    selectedStatuses.add("Planed");
                  } else if (selectedStatuses.first == "Đang tiến hành") {
                    selectedStatuses.clear();
                    selectedStatuses.add("In Progress");
                  } else if (selectedStatuses.first == "Hoàn thành") {
                    selectedStatuses.clear();
                    selectedStatuses.add("Completed");
                  } else {
                    selectedStatuses.clear();
                    selectedStatuses.add("Late");
                  }

                  if (selectedPriorities.first == "Thấp") {
                    selectedPriorities.clear();
                    selectedPriorities.add("Low");
                  } else if (selectedPriorities.first == "Trung Bình") {
                    selectedPriorities.clear();
                    selectedPriorities.add("Medium");
                  } else {
                    selectedPriorities.clear();
                    selectedPriorities.add("High");
                  }

                  if (!_controller_progress.text.endsWith("%")) {
                    _controller_progress.text += "%";
                  }
                  print(_controller_description.text);
                  print(_controller_title.text);
                  print(_controller_progress.text);
                  print(selectedStatuses.first);
                  print(selectedPriorities.first);
                  print(startDate);
                  print(finishDate);

                  final dioClient = DioClient();
                  final response = await dioClient.request(
                    "/apis/OpenAPI/create",
                    queryParameters: {'module': 'Calendar'},
                    data: json.encode({
                      "data": {
                        "subject": _controller_title.text,
                        "activitytype": "Task",
                        "date_start": startDate,
                        "due_date": finishDate,
                        "time_start": "00:00:00",
                        "calendar_progress": _controller_progress.text,
                        "taskstatus": selectedStatuses.first,
                        "taskpriority": selectedPriorities.first,
                        "description": _controller_description.text,
                        "eventstatus": selectedStatuses.first,
                        "parent_id": "",
                        "related_account": "",
                        "contact_id": "",
                        "related_lead": ""
                      }
                    }),
                    options: Options(method: "POST"),
                  );

                  if (response.statusCode == 200) {
                    print("chạy ok");
                    print(response.data);
                  }
                } catch (e) {
                  print('Error: $e');
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
              }
            },
            child: Text(
              'Lưu',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                color: COLOR_WHITE,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
