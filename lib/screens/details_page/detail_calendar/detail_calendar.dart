import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/constants/image_assets.dart';
import 'package:management_app/screens/calendar_page/home_lock/homelock.dart';
import 'package:management_app/widgets/text_custom.dart';
import '../../../models/calendar/detail_calendar_detail.dart';
import '../../../models/user/user_model.dart';
import '../../../navigation/navigation.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/assignment_item2.dart';
import '../../../widgets/assignment_suggestion_input2.dart';

class DetailCalendar extends StatefulWidget {
  const DetailCalendar(
      {super.key, required this.dataCalendar, required this.dateEvent});
  final Map<String, Object> dataCalendar;
  final String dateEvent;

  @override
  State<DetailCalendar> createState() => _DetailCalendarState();
}

class _DetailCalendarState extends State<DetailCalendar> {
  final _formKey = GlobalKey<FormState>();
  late FocusNode inputFocusEvent;
  int originalMaxLines = 5; // Set the initial value of maxLines
  int maxLines = 1;
  bool isDataLoaded = false;
  DetailCalendarData detailCalendarData = DetailCalendarData();
  List<UserModel> listUser = [];

  void fetchData() async {
    // print("vinhhhhh");
    // print(widget.dataCalendar['id']);
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        '/apis/OpenAPI/retrieve',
        queryParameters: {
          'module': 'Calendar',
          'record': widget.dataCalendar['id'],
          'view': 'Detail'
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        //giải mã chuỗi JSON từ response.data, sau đó chuyển kết quả thành một Map với các khóa và giá trị có kiểu dữ liệu tương ứng
        // final parsed = json.decode(response.data!).cast<String, dynamic>();
        final parsedResponse = json.decode(response.data);
        final data = parsedResponse['data'];
        detailCalendarData = DetailCalendarData.fromMap(data);
        print(detailCalendarData.toString());
        setState(() {});
        isDataLoaded = true; // Đánh dấu dữ liệu đã sẵn sàng
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      maxLines = 3;
    });
    fetchData();
    fetchDataUser();
    print(widget.dataCalendar["id"]);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchDataUser() async {
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

  void setTime(int currentHour, int currentMinute, StateSetter setTimeState) {
    setTimeState(() {
      detailCalendarData.time_start =
          "${currentHour.toString().padLeft(2, '0')} : ${currentMinute.toString().padLeft(2, '0')}";
    });
  }

  void setTimeEnd(
      int currentHour, int currentMinute, StateSetter setTimeEndState) {
    setTimeEndState(() {
      detailCalendarData.time_end =
          "${currentHour.toString().padLeft(2, '0')} : ${currentMinute.toString().padLeft(2, '0')}";
    });
  }

  _selectedTimeAdd(StateSetter setStateTimeStart) {
    showDialog(
        context: context,
        builder: (context) => HomeLock(
              popDialog: () {
                Navigator.pop(context);
              },
              propTime: (currentHour, currentMinute) {
                setTime(currentHour, currentMinute, setStateTimeStart);
              },
            ));
  }

  _selectedTimeEnd(StateSetter setTimeEndState) {
    showDialog(
        context: context,
        builder: (context) => HomeLock(popDialog: () {
              Navigator.pop(context);
            }, propTime: (currentHour, currentMinute) {
              setTimeEnd(currentHour, currentMinute, setTimeEndState);
            }));
  }

  void _presentDatePicker(String type, StateSetter setSateDate) async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 2),
    );
    setSateDate(
      () {
        detailCalendarData.date_start =
            DateFormat('dd/MM/yyyy').format(pickedDate!);
      },
    );
  }

  void addAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      detailCalendarData.assigned_owners ??= [];
      detailCalendarData.assigned_owners
          ?.add({'id': value.id, 'name': value.user_name});
    });
  }

  void removeAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      if (detailCalendarData.assigned_owners != null) {
        detailCalendarData.assigned_owners
            ?.removeWhere((e) => e['id'] == value.id);
      }
    });
  }

  void _handleTapOutside(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.hasFocus) {
      currentFocus.unfocus();
    }
  }

  void getStatus(String value) {
    setState(() {
      detailCalendarData.visibility = value;
    });
  }

  Future<void> saveForm() async {
    if (detailCalendarData.visibility == "Private") {
      detailCalendarData.visibilityTemp = true;
    } else {
      detailCalendarData.visibilityTemp = false;
    }

    print(detailCalendarData.subject);
    print(detailCalendarData.date_start);
    print(detailCalendarData.time_start);
    print(detailCalendarData.time_end);
    print(detailCalendarData.due_date);
    print(detailCalendarData.description);
    print(detailCalendarData.visibilityTemp);
    print(detailCalendarData.assigned_owners);
    print(widget.dataCalendar['id']);

    detailCalendarData.assigned_user_id = detailCalendarData.assigned_owners!
        .map((user) => 'Users:${user['id']}')
        .join(',');
    print(detailCalendarData.assigned_user_id);
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        "/apis/OpenAPI/update",
        queryParameters: {
          "module": "Calendar",
          "record": widget.dataCalendar['id']
        },
        data: json.encode({
          "data": {
            "subject": detailCalendarData.subject,
            "activitytype": "Meeting",
            "date_start": detailCalendarData.date_start,
            "time_start": detailCalendarData.time_start,
            "time_end": detailCalendarData.time_end,
            // "due_date": detailCalendarData.due_date,
            "description": detailCalendarData.description,
            "visibility": detailCalendarData.visibilityTemp,
            "assigned_user_id": detailCalendarData.assigned_user_id,
            "parent_id": "",
            "related_account": "",
            "contact_id": "",
            "related_lead": ""
          }
        }),
        options: Options(method: "POST"),
      );
      if (response.statusCode == 200) {
        print(response);
        // Navigator.pushNamed(context, "/navigation", arguments: 3);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const NavigationBottom(initialIndex: 3)),
        );
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    print('rebuilt');
    // print(detailCalendarData?.description);
    if (!isDataLoaded) {
      return Container(
        color: COLOR_WHITE,
        child: const Center(
          child: SizedBox(
            width: 32, // Đặt chiều rộng bạn mong muốn
            height: 32, // Đặt chiều cao bạn mong muốn
            child: CircularProgressIndicator(),
          ),
        ),
      );
// Hoặc widget tương tự để hiển thị đợi
    }
    return GestureDetector(
      onTap: () => _handleTapOutside(context),
      child: Scaffold(
        bottomNavigationBar: Container(
          padding: const EdgeInsets.only(top: 10, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(COLOR_GREEN),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Processing Data')),
                    );
                    saveForm();
                  }
                },
                child: Text(
                  'Cập nhật',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    fontSize: FONT_SIZE_TEXT_BUTTON,
                    color: COLOR_WHITE,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          backgroundColor: COLOR_WHITE,
          elevation: 0,
          title: const TextCustom(
              text: 'Chi tiết lịch',
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_NORMAL_TITLE,
              fontWeight: FontWeight.w600),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: COLOR_BLACK),
          actionsIconTheme: const IconThemeData(color: COLOR_DELAY),
          actions: <Widget>[
            IconButton(
                padding: const EdgeInsets.only(right: 10),
                icon: Image.asset(
                  IC_EDIT,
                  width: 24,
                  height: 24,
                ),
                onPressed: () {})
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Row(
                    children: [
                      TextCustom(
                          text: "Tên cuộc họp",
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
                  inputMeetingName(),
                  const SizedBox(
                    height: 20,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        TextCustom(
                            text: "Mô tả",
                            color: COLOR_BLACK,
                            fontSize: FONT_SIZE_TEXT_BUTTON,
                            fontWeight: FontWeight.w600),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildDescription(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  pickerDateMeeting(),
                  const SizedBox(height: 8.0),
                  Row(
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
                  const SizedBox(width: 16.0),
                  checkEventType(),
                  const SizedBox(height: 10),
                  assignmentWidget(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputMeetingName() {
    return StatefulBuilder(
      builder: (context, StateSetter setStateTitle) {
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                initialValue: detailCalendarData.subject,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                textCapitalization: TextCapitalization.words,
                onChanged: (value) {
                  detailCalendarData.subject = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập tên cuộc họp';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  isDense: true,
                  labelStyle:
                      TextStyle(color: COLOR_BLACK, fontSize: FONT_SIZE_NORMAL),
                  fillColor: Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                  focusColor: COLOR_GREEN,
                  hintStyle: TextStyle(color: Colors.blue),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget buildDescription() {
    return StatefulBuilder(
      builder: (context, StateSetter setStateDes) {
        return TextFormField(
          initialValue: detailCalendarData.description,
          textCapitalization: TextCapitalization.words,
          maxLines: maxLines,
          onChanged: (value) {
            detailCalendarData.description = value;
            setStateDes(() {
              originalMaxLines = maxLines;
              int newMaxLines =
                  value.length ~/ (MediaQuery.of(context).size.width * 0.102) +
                      1;
              maxLines = newMaxLines.clamp(1, 3);
            });
          },
          decoration: InputDecoration(
            labelStyle:
                const TextStyle(color: COLOR_BLACK, fontSize: FONT_SIZE_NORMAL),
            fillColor: COLOR_WHITE,
            filled: true,
            focusColor: COLOR_GREEN,
            hintStyle: const TextStyle(color: Colors.blue),
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
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          ),
        );
      },
    );
  }

  Widget pickerDateMeeting() {
    return StatefulBuilder(
      builder: (context, setStateDate) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                TextCustom(
                    text: 'Ngày họp',
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
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212),
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212),
                      width: 1.0,
                    ),
                    left: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212),
                      width: 1.0,
                    ),
                    right: BorderSide(
                      color: Color.fromARGB(255, 212, 212, 212),
                      width: 1.0,
                    ),
                  ),
                  borderRadius:
                      BorderRadius.circular(10), // Set the border radius here
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      detailCalendarData.date_start ?? "Chọn 1 ngày",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: FONT_SIZE_TEXT_BUTTON,
                        color: COLOR_BLACK,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        _presentDatePicker('startDate', setStateDate);
                      },
                      icon: Image.asset(
                        'lib/assets/images/create_project/pick_date_icon.png',
                        width: 28,
                      ),
                    ),
                  ],
                ))
          ],
        );
      },
    );
  }

  Widget chooseTimeStart() {
    return StatefulBuilder(
      builder: (context, setStateTimeStart) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
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
            InkWell(
              onTap: () {
                // Navigator.pop(context);

                _selectedTimeAdd(setStateTimeStart);
              },
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: detailCalendarData.time_start ?? 'Giờ bắt đầu',
                  labelStyle: const TextStyle(color: COLOR_BLACK),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      IC_LOCK,
                      width: 1,
                      height: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1,
                      color: COLOR_GRAY,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                style: const TextStyle(
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_GRAY,
                ),
              ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
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
            InkWell(
              onTap: () {
                // Navigator.pop(context);
                _selectedTimeEnd(setTimeEndState);
              },
              child: TextField(
                enabled: false,
                decoration: InputDecoration(
                  labelText: detailCalendarData.time_end ?? 'Giờ kết thúc',
                  labelStyle: const TextStyle(color: COLOR_BLACK),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      IC_LOCK,
                      width: 1,
                      height: 1,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 186, 186, 186),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(16.0),
                ),
                style: const TextStyle(
                  fontSize: FONT_SIZE_NORMAL,
                  color: COLOR_GRAY,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget checkEventType() {
    return StatefulBuilder(
      builder: (context, setStateType) {
        return Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: TextCustom(
                  text: 'Lịch riêng tư:',
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  fontWeight: FontWeight.w600),
            ),
            Switch(
              value: detailCalendarData.visibility ==
                  "Private", // Kiểm tra nếu là "Public"
              activeColor: COLOR_GREEN,
              onChanged: (bool value) {
                setStateType(() {
                  // Cập nhật giá trị dựa trên sự thay đổi của Switch
                  detailCalendarData.visibility = value ? "Private" : "Public";
                });
              },
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
          const Row(
            children: [
              TextCustom(
                  text: "Mời",
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  fontWeight: FontWeight.w600),
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
                        if (detailCalendarData.assigned_owners != null &&
                            detailCalendarData.assigned_owners!.isNotEmpty)
                          ...detailCalendarData.assigned_owners!.map(
                            (e) {
                              UserModel userModel =
                                  UserModel(id: e['id'], user_name: e['name']);
                              return Column(
                                children: [
                                  AssignmentItem(
                                    user: userModel,
                                    remove: (UserModel value) {
                                      removeAssignment(
                                          value, setAssignmentState);
                                    },
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                ],
                              );
                            },
                          ),
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
              if (detailCalendarData.assigned_owners!.isEmpty) {
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
