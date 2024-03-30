import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../constants/image_assets.dart';
import '../../../data/data.dart';
import '../../../models/calendar/calendardata.dart';
import '../../../models/user/user_model.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/assignment_item2.dart';
import '../../../widgets/assignment_suggestion_input2.dart';
import '../../home_page/task_tab/cancel_dialog.dart';
import '../button_switch.dart';
import '../home_lock/homelock.dart';

class BottomSheetCalendar extends StatefulWidget {
  const BottomSheetCalendar({super.key});

  @override
  State<BottomSheetCalendar> createState() => _BottomSheetCalendarState();
}

class _BottomSheetCalendarState extends State<BottomSheetCalendar> {
  final _formKeyCalendar = GlobalKey<FormState>();
  DataCalendarModel dataCalendarModel = DataCalendarModel();
  int originalMaxLines = 5; // Set the initial value of maxLines
  int maxLines = 1;
  String? selectedProgress;
  final _controller_progress = TextEditingController();
  bool marginValidator = false;
  List<UserModel> listUser = [];

  @override
  void initState() {
    // dataCalendarModel.visibility = false as String?;
    dataCalendarModel.assigned_owners = [];
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchData() async {
    try {
      final dioClient = DioClient();
      final responseUser = await dioClient.request("/apis/OpenAPI/list",
          queryParameters: {'module': 'Users'},
          options: Options(method: 'GET'));
      if (responseUser.statusCode == 200) {
        print("chạy ok");
        final parsed = json.decode(responseUser.data!);
        for (var entry in parsed['entry_list']) {
          // project.assigned_owners?.add(ProjectModel.fromMap(entry));
          listUser.add(UserModel.fromMap(entry));
        }
        // print(listUser);
        setState(() {});
      } else {
        print('Error: ${responseUser.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void saveForm() async {
    print(dataCalendarModel.subject);
    print(dataCalendarModel.description);
    print(dataCalendarModel.time_start);
    print(dataCalendarModel.time_end);
    print(dataCalendarModel.visibility);
    print(_controller_progress.text);
    print(dataCalendarModel.assigned_owners);

    final dioClient = await new DioClient();
    final reponse = dioClient.request(
      '/apis/OpenAPI/create',
      queryParameters: {'module': 'Calendar'},
      data: json.encode({
        "data": {
          "subject": dataCalendarModel.subject,
          "activitytype": "Meeting",
          "date_start": "2023-02-28",
          "time_start": dataCalendarModel.time_start,
          "due_date": "2023-02-28",
          "taskstatus": "Planned",
          "eventstatus": "Planned",
          "parent_id": "",
          "related_account": "",
          "contact_id": "",
          "related_lead": ""
        }
      }),
      options: Options(method: 'POST'),
    );
  }

  void addAssignment(UserModel value, StateSetter stateSetter) {
    print("object");
    print(value);
    stateSetter(() {
      dataCalendarModel.assigned_owners?.add(value);
    });
  }

  void removeAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      dataCalendarModel.assigned_owners?.remove(value);
    });
  }

  _selectedTimeAdd(
      StateSetter setStateTimeStart, FormFieldState<String> field) {
    showDialog(
        context: context,
        builder: (context) => HomeLock(popDialog: () {
              Navigator.pop(context);
            }, propTime: (currentHour, currentMinute) {
              setTime(currentHour, currentMinute, setStateTimeStart, field);
            }));
  }

  _selectedTimeEnd(
      StateSetter setStateTimeEnd, FormFieldState<String> fieldEnd) {
    showDialog(
        context: context,
        builder: (context) => HomeLock(popDialog: () {
              Navigator.pop(context);
            }, propTime: (currentHour, currentMinute) {
              setTimeEnd(currentHour, currentMinute, setStateTimeEnd, fieldEnd);
            }));
  }

  void getStatus(bool value) {
    dataCalendarModel.visibility = value;
  }

  void setTime(int currentHour, int currentMinute, StateSetter setStateTime,
      FormFieldState<String> field) {
    setStateTime(() {
      dataCalendarModel.time_start =
          "${currentHour.toString().padLeft(2, '0')} : ${currentMinute.toString().padLeft(2, '0')}";

      field.didChange(dataCalendarModel.time_start.toString());
    });
  }

  void setTimeEnd(int currentHour, int currentMinute,
      StateSetter setStateTimeEnd, FormFieldState<String> field) {
    setStateTimeEnd(() {
      dataCalendarModel.time_end =
          "${currentHour.toString().padLeft(2, '0')} : ${currentMinute.toString().padLeft(2, '0')}";
      field.didChange(dataCalendarModel.time_end.toString());
    });
  }

  bool compareTime(String startTime, String endTime) {
    if (dataCalendarModel.time_start!.isNotEmpty) {
      final startTimeOfDay = TimeOfDay(
        hour: int.parse(startTime.split(':')[0]),
        minute: int.parse(startTime.split(':')[1]),
      );

      final endTimeOfDay = TimeOfDay(
        hour: int.parse(endTime.split(':')[0]),
        minute: int.parse(endTime.split(':')[1]),
      );

      if (startTimeOfDay.hour < endTimeOfDay.hour ||
          (startTimeOfDay.hour == endTimeOfDay.hour &&
              startTimeOfDay.minute < endTimeOfDay.minute)) {
        // startTime is earlier than endTime
        return true;
      } else if (startTimeOfDay.hour == endTimeOfDay.hour &&
          startTimeOfDay.minute == endTimeOfDay.minute) {
        // startTime is equal to endTime
        return false;
      } else {
        // startTime is later than endTime
        return false;
      }
    }
    return true;
  }

  void _handleTapOutside(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("rebuilt");
    return GestureDetector(
      onTap: () => _handleTapOutside(context),
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
            color: COLOR_WHITE,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
            child: Form(
              key: _formKeyCalendar,
              child: Column(
                children: [
                  const TextCustom(
                    text: 'Thêm lịch họp',
                    color: COLOR_BLACK,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16.0),
                  inputTitle(),
                  const SizedBox(height: 16.0),
                  descriptionInput(),
                  const SizedBox(height: 16.0),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: chooseTimeStart(),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: chooseTimeEnd(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  statusEvent(),
                  assignmentWidget(),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color.fromARGB(255, 255, 233, 231)),
                            foregroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
                            side: MaterialStateProperty.all<BorderSide>(
                                const BorderSide(
                                    color:
                                        Color.fromARGB(255, 255, 255, 255)))),
                        onPressed: () {
                          print("object");
                          // Navigator.pop(context);
                          showCancelDialog(context);
                          setState(() {
                            dataCalendarModel.subject = '';
                            dataCalendarModel.description = '';
                            dataCalendarModel.time_start = '';
                            dataCalendarModel.time_end = '';
                            dataCalendarModel.visibility = false;
                            dataCalendarModel.assigned_owners?.clear();
                          });
                          // Navigator.pop(context);
                        },
                        child: const Text('Hủy'),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(COLOR_GREEN),
                        ),
                        child: const Text('Thêm lịch họp'),
                        onPressed: () {
                          if (_formKeyCalendar.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Processing Data')),
                            );
                            print("object");
                            saveForm();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTitle() {
    return StatefulBuilder(
      builder: (context, setStateTitle) {
        return TextFormField(
          textCapitalization: TextCapitalization.words,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (value) {
            dataCalendarModel.subject = value;
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Vui lòng nhập tiêu đề cuộc họp';
            }
            return null;
          },
          decoration: InputDecoration(
            labelStyle: const TextStyle(
                color: COLOR_BLACK, fontSize: FONT_SIZE_TEXT_BUTTON),
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            filled: true,
            focusColor: COLOR_GREEN,
            hintStyle: const TextStyle(color: Colors.blue),
            labelText: 'Tiêu đề cuộc họp',
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(255, 186, 186, 186),
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          ),
          style: const TextStyle(color: COLOR_BLACK),
        );
      },
    );
  }

  Widget chooseTimeStart() {
    return StatefulBuilder(
      builder: (context, setStateTimeStart) {
        return Column(
          children: [
            const Row(
              children: [
                TextCustom(
                    text: "Giờ bắt đầu",
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    fontWeight: FontWeight.w600),
                SizedBox(
                  width: 2,
                ),
                TextCustom(
                    text: '*',
                    color: COLOR_LATE,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    fontWeight: FontWeight.w600),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FormField<String>(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (dataCalendarModel.time_start == null) {
                  return 'Nhập thời gian bắt đầu';
                }
                return null;
              },
              builder: (field) {
                // field.didChange("132");
                return Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 5.0, 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: COLOR_GRAY, // Đặt màu sắc của border
                            width: 1.0, // Đặt độ dày của border
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          _selectedTimeAdd(setStateTimeStart, field);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              dataCalendarModel.time_start == null
                                  ? 'Giờ bắt đầu'
                                  : dataCalendarModel.time_start!,
                              style: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontSize: FONT_SIZE_TEXT_BUTTON,
                                color: COLOR_BLACK,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _selectedTimeAdd(setStateTimeStart, field);
                              },
                              icon: Image.asset(
                                IC_LOCK,
                                width: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    field.hasError
                        ? Center(
                            child: Text(
                              field.errorText.toString(),
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : const SizedBox()
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget chooseTimeEnd() {
    return StatefulBuilder(
      builder: (context, setTimeEndState) {
        return Column(
          children: [
            const Row(
              children: [
                TextCustom(
                    text: "Giờ kết thúc",
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    fontWeight: FontWeight.w600),
                SizedBox(
                  width: 2,
                ),
                TextCustom(
                    text: '*',
                    color: COLOR_LATE,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    fontWeight: FontWeight.w600),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            FormField<String>(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (dataCalendarModel.time_end == null) {
                    return 'Nhập thời gian kết thúc';
                  } else if (dataCalendarModel.time_start != null &&
                      !compareTime(dataCalendarModel.time_start!,
                          dataCalendarModel.time_end!)) {
                    return 'Thời gian không hợp lệ';
                  }
                  return null;
                },
                builder: (fieldTimeEnd) {
                  return Column(
                    children: [
                      Container(
                          padding: const EdgeInsets.fromLTRB(20.0, 0, 5.0, 0),
                          decoration: BoxDecoration(
                              border: Border.all(
                                color: COLOR_GRAY,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {
                              _selectedTimeEnd(setTimeEndState, fieldTimeEnd);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  dataCalendarModel.time_end == null
                                      ? 'Giờ kết thúc'
                                      : dataCalendarModel.time_end!,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FONT_SIZE_TEXT_BUTTON,
                                    color: COLOR_BLACK,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    _selectedTimeEnd(
                                        setTimeEndState, fieldTimeEnd);
                                  },
                                  icon: Image.asset(
                                    IC_LOCK,
                                    width: 25,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      fieldTimeEnd.hasError
                          ? Center(
                              child: Text(
                                fieldTimeEnd.errorText.toString(),
                                style: const TextStyle(color: Colors.red),
                              ),
                            )
                          : const SizedBox()
                    ],
                  );
                }),
          ],
        );
      },
    );
  }

  Widget descriptionInput() {
    return StatefulBuilder(
      builder: ((context, setStateDes) {
        return TextFormField(
          textCapitalization: TextCapitalization.words,
          maxLines: maxLines,
          onChanged: (value) {
            setStateDes(() {
              dataCalendarModel.description = value;
              originalMaxLines = maxLines;
              int newMaxLines =
                  value.length ~/ (MediaQuery.of(context).size.width * 0.102) +
                      1;
              maxLines = newMaxLines.clamp(1, 3);
            });
          },
          decoration: InputDecoration(
            labelText: 'Mô tả',
            labelStyle: const TextStyle(
                color: COLOR_BLACK, fontSize: FONT_SIZE_TEXT_BUTTON),
            fillColor: const Color.fromARGB(255, 255, 255, 255),
            filled: true,
            focusColor: COLOR_GREEN,
            hintStyle: const TextStyle(color: Colors.blue),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                width: 1,
                color: Color.fromARGB(255, 212, 212, 212),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget statusEvent() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: TextCustom(
                            text: "Lịch riêng tư",
                            color: COLOR_BLACK,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                            fontWeight: FontWeight.w600),
                      ),
                      ButtonSwitch(
                        propStatus: getStatus,
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      TextCustom(
                          text: "Tình trạng hoạt động:",
                          color: COLOR_BLACK,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          fontWeight: FontWeight.w600),
                      SizedBox(
                        width: 2,
                      ),
                      TextCustom(
                          text: '*',
                          color: COLOR_LATE,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          fontWeight: FontWeight.w600),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(children: [
                    Expanded(
                      flex: 2,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_TEXT_MAIN,
                        ),
                        controller: _controller_progress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập giá trị';
                          }
                          return null;
                        },
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
                          hintText: 'Chọn 1 giá trị',
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
                        margin: EdgeInsets.only(
                            bottom: marginValidator == true ? 22 : 0),
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
                              horizontal: 10, vertical: 11),
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                            color: COLOR_TEXT_MAIN,
                          ),

                          // value: selectedProgress,
                          underline: const SizedBox(),
                          items: stateOptionList
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
                  ]),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  Widget assignmentWidget() {
    return StatefulBuilder(
      builder: (context, setAssignmentState) => Column(
        children: [
          Row(
            children: [
              Text(
                'Mời',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w600,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_BLACK,
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
            height: 15,
          ),
          FormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (field) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints:
                      const BoxConstraints(minHeight: 0, maxHeight: 106),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (dataCalendarModel.assigned_owners!.isNotEmpty)
                          ...dataCalendarModel.assigned_owners!.map((e) {
                            UserModel userModel = e;
                            return Column(
                              children: [
                                AssignmentItem(
                                  user: userModel,
                                  remove: (UserModel value) {
                                    removeAssignment(
                                        value as UserModel, setAssignmentState);
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                listUser.isNotEmpty
                    ? AssignmentSuggestionInput(
                        placeHolder: 'Vui lòng nhập ít nhất 2 kí tự',
                        chooseAssign: (UserModel value) {
                          print(1);
                          addAssignment(value, setAssignmentState);
                          print(2);

                          field.didChange(value);
                        },
                        assignList: listUser,
                      )
                    : Container(),
                if (field.hasError)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    child: Text(
                      field.errorText!,
                      style: GoogleFonts.montserrat(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  )
              ],
            ),
            validator: (value) {
              if (dataCalendarModel.assigned_owners!.isEmpty) {
                return 'Giao cho ít nhất một người';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }
}
