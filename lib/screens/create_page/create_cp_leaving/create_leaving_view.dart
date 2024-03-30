// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:management_app/blocs/upload_file/upload_file_state.dart';
import 'package:management_app/models/leaving/leaving_model.dart';

import '../../../blocs/upload_file/upload_file_bloc.dart';
import '../../../blocs/upload_file/upload_file_event.dart';
import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../models/user/user_model.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/assignment_item2.dart';
import '../../../widgets/assignment_suggestion_input2.dart';
import '../../home_page/task_tab/cancel_dialog.dart';

class CreateLeavingView extends StatefulWidget {
  const CreateLeavingView({super.key});

  @override
  State<CreateLeavingView> createState() => _CreateLeavingViewState();
}

class LeavingType {
  String? label;
  String? value;
  LeavingType(String this.label, String this.value);
  @override
  String toString() {
    // TODO: implement toString
    return label!;
  }
}

class _CreateLeavingViewState extends State<CreateLeavingView> {
  final _formKey = GlobalKey<FormState>();
  int? originalMaxLines;
  int? maxLines;
  final Set<String> selectedTypeDate = {"Nửa ngày"};

  List<UserModel> userList = [];

  String? title;
  LeavingType? type;
  String? description;

  List<UserModel> assigned_owners = [];
  String? typeTime;
  final Set<String> selectedTimeDate = {};
  String? fromDate;
  String? toDate;

  // List<String> assignment = [];
  List<LeavingType> typeLeaving = [
    LeavingType('Nghỉ phép', 'On leave'),
    LeavingType('Nghỉ bệnh', 'Sick leave'),
    LeavingType('Nghỉ thai sản', 'Maternity leave'),
    LeavingType('Xin làm ở nhà', 'WFH'),
    LeavingType('Khác', 'Other'),
  ];

  static const typeDateTimeLeaving = [
    {
      "label": "Nửa buổi",
      "color": COLOR_GREEN,
      'value': 'Half day',
    },
    {
      "label": "Một ngày",
      "color": COLOR_INPROGRESS,
      'value': 'A day',
    },
    {
      "label": "Nhiều ngày",
      "color": COLOR_PLAN,
      'value': 'Several days',
    }
  ];
  static const typeTimeLeaving = [
    {
      "label": "Sáng",
      "color": COLOR_TEXT_MAIN,
      'value': 'Morning',
    },
    {
      "label": "Chiều",
      "color": COLOR_TEXT_MAIN,
      'value': 'Afternoon',
    },
  ];

  void addAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      assigned_owners.add(value);
    });
  }

  void removeAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      assigned_owners.remove(value);
    });
  }

  void fetchUserData() async {
    try {
      final dioClient = DioClient();
      final responseUser = await dioClient.request("/apis/OpenAPI/list",
          queryParameters: {'module': 'Users'},
          options: Options(method: 'GET'));
      if (responseUser.statusCode == 200) {
        print('success user data');
        final parsed = json.decode(responseUser.data!);
        for (var entry in parsed['entry_list']) {
          userList.add(UserModel.fromMap(entry));
        }
        setState(() {});
      } else {
        print('Error: ${responseUser.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void sendLeaving(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/create',
        queryParameters: {
          'module': 'CPLeaving',
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        'Tạo lịch nghỉ thành công';
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void saveForm() {
    print('===== SAVE =====');
    print(title);
    print(type!.value);
    print(description);
    print(assigned_owners);
    print(typeTime);
    print(selectedTimeDate.first);
    print(fromDate);
    print(toDate);

    String? leavingDate;
    if (typeTime == 'Half day') {
      leavingDate = '$fromDate: nửa ngày (${selectedTimeDate.first})';
    } else if (typeTime == 'A day') {
      leavingDate = '$fromDate: full ngày';
    } else if (typeTime == 'Several days') {
      leavingDate = 'Từ ${fromDate} Đến ${toDate} (${selectedTimeDate.first})';
    }

    var data = json.encode({
      "data": {
        "name": title,
        "cpleaving_no": "",
        "description": description,
        "assigned_user_id": "1",
        "cpleaving_type": type!.value,
        "leaving_date": leavingDate!,
        "attachments": "",
        "assigned_owners": assigned_owners,
      }
    });
    sendLeaving(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild");
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: buildSaveAndCancelButton(),
        appBar: AppBar(
          elevation: 0.5,
          iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
          backgroundColor: COLOR_WHITE,
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
          title: Text(
            "Tạo lịch nghỉ phép",
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                fontSize: FONT_SIZE_SMALL_TITLE,
                color: COLOR_BLACK),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
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
                      const SizedBox(height: 10),
                      buildTypeLeaving(),
                      const SizedBox(height: 10),
                      buildDescription(),
                      const SizedBox(height: 10),
                      buildAttachment(),
                      const SizedBox(height: 10),
                      buildAssignmentWidget(),
                      const SizedBox(height: 10),
                      buildDateAndTime(),
                      buildAddLeavingButton(),
                    ],
                  ),
                ),
              )),
        ),
      ),
    );
  }

  Widget buildAddLeavingButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(COLOR_GREEN),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text("Thêm lịch nghỉ phép"),
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
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                saveForm();
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

  Widget buildDateAndTime() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: COLOR_GRAY_SEARCH,
          ),
          child: Column(
            children: [
              buildTypeDay(setState),
              const SizedBox(width: 15),
              ((selectedTypeDate.isNotEmpty &&
                      selectedTypeDate.first == "Một ngày"))
                  ? IgnorePointer(
                      child:
                          Opacity(opacity: 0.3, child: buildTimeLeavingDay()))
                  : buildTimeLeavingDay(),
              const SizedBox(height: 10),
              ((selectedTypeDate.isNotEmpty &&
                      selectedTypeDate.first != "Nhiều ngày"))
                  ? buildLeavingDateSingle()
                  : buildDate(),
            ],
          ),
        );
      },
    );
  }

  Widget buildDate() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              startDateWidget(),
              const SizedBox(
                width: 20,
              ),
              finishPlanDateWidget(),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLeavingDateSingle() {
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              startLeavingDateWidget(),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: SizedBox())
            ],
          ),
        ],
      ),
    );
  }

  Widget startLeavingDateWidget() {
    return StatefulBuilder(
      builder: (context, setStartDateState) => Expanded(
        child: FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ngày',
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
                child: InkWell(
                  onTap: () {
                    _presentDatePicker('fromDate', field, setStartDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        fromDate == null ? 'Chọn ngày' : fromDate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'fromDate', field, setStartDateState);
                        },
                        icon: Image.asset(
                          'lib/assets/images/create_project/pick_date_icon.png',
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            if (value == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget startDateWidget() {
    return StatefulBuilder(
      builder: (context, setStartDateState) => Expanded(
        child: FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Từ ngày',
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
                child: InkWell(
                  onTap: () {
                    _presentDatePicker('fromDate', field, setStartDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        fromDate == null ? 'Chọn ngày' : fromDate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'fromDate', field, setStartDateState);
                        },
                        icon: Image.asset(
                          'lib/assets/images/create_project/pick_date_icon.png',
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            if (value == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
    );
  }

  void _presentDatePicker(String type, FormFieldState<Object?> field,
      StateSetter stateSetter) async {
    final now = DateTime.now();
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    stateSetter(
      () {
        if (type == 'toDate') {
          toDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(toDate);
        } else if (type == 'fromDate') {
          fromDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(fromDate);
        }
      },
    );
  }

  Widget finishPlanDateWidget() {
    return StatefulBuilder(
      builder: (context, setFinishPlanDateState) => Expanded(
        child: FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Đến ngày',
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
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 0,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color:
                          COLOR_TEXT_MAIN, // Đặt màu sắc của border ở cạnh dưới
                      width: 1.0, // Đặt độ dày của border
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    _presentDatePicker('toDate', field, setFinishPlanDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        toDate == null ? 'Chọn ngày' : toDate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'toDate', field, setFinishPlanDateState);
                        },
                        icon: Image.asset(
                          'lib/assets/images/create_project/pick_date_icon.png',
                          width: 28,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
            if (value == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildTypeDay(StateSetter setStateType) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                "Loại",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
              ),
              Text(
                " *",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_LATE,
                ),
              ),
            ],
          ),
        ),
        buildTypeDaySelection(setStateType),
      ],
    );
  }

  Widget buildTypeDaySelection(StateSetter setStateStatus) {
    return Wrap(
      spacing: 2,
      runSpacing: 10,
      children: typeDateTimeLeaving.map(
        (status) {
          final isSelected =
              selectedTypeDate.contains(status['label'].toString());
          // print(status['label']);
          // print(isSelected);
          // print(selectedTypeDate.first);
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
                  selectedTypeDate.clear();
                  selectedTimeDate.clear();
                  selectedTypeDate.add(status['label'].toString());
                  typeTime = status['value'].toString();
                  print(typeTime);
                } else {
                  selectedTimeDate.clear();
                  selectedTypeDate.clear();
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget buildTimeLeavingDay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Text(
                "Buổi",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
              ),
              Text(
                " *",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_LATE,
                ),
              ),
            ],
          ),
        ),
        StatefulBuilder(
          builder: (context, setStateStatus) =>
              buildTimeLeavingSelection(setStateStatus),
        ),
      ],
    );
  }

  Widget buildTimeLeavingSelection(StateSetter setStateStatus) {
    return Wrap(
      spacing: 2,
      runSpacing: 10,
      children: typeTimeLeaving.map(
        (status) {
          final isSelected = selectedTimeDate.contains(status['label']);
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
                if (selectedTypeDate.first != "Nhiều ngày") {
                  if (selected) {
                    selectedTimeDate.clear();
                    selectedTimeDate.add(status['label'].toString());
                  } else {
                    selectedTimeDate.clear();
                  }
                } else {
                  if (selected) {
                    selectedTimeDate.add(status['label'].toString());
                  } else {
                    selectedTimeDate.remove(status['label'].toString());
                  }
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  Widget buildAssignmentWidget() {
    return StatefulBuilder(
      builder: (context, setAssignmentState) => Column(
        children: [
          Row(
            children: [
              Text(
                'Giao cho',
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
                        ...assigned_owners.map(
                          (e) => Column(
                            children: [
                              AssignmentItem(
                                user: e,
                                remove: (UserModel value) {
                                  removeAssignment(value, setAssignmentState);
                                },
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                AssignmentSuggestionInput(
                  placeHolder: 'Vui lòng nhập ít nhất 2 kí tự',
                  chooseAssign: (UserModel value) {
                    addAssignment(value, setAssignmentState);
                    field.didChange(value);
                  },
                  assignList: userList,
                ),
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
              if (assigned_owners.isEmpty) {
                return 'Giao cho ít nhất một người';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buildAttachment() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text("Tệp đính kèm",
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                )),
          ),
          Row(
            children: [
              InkWell(
                onTap: () => {
                  context.read<UploadFileBloc>().add(PressUploadButton()),
                },
                child: Container(
                  height: 50,
                  width: 70,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: COLOR_CARD_BACKGROUND,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(4, 8), // Shadow position
                        ),
                      ]),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.upload_file,
                        color: COLOR_TEXT_MAIN,
                      ),
                      Text(
                        "Tải lên",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_NORMAL,
                          color: COLOR_TEXT_MAIN,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              BlocBuilder<UploadFileBloc, UploadFileState>(
                builder: (context, state) {
                  if (state is UploadFileLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is UploadFileNoData) {
                    print(state);
                    return Center(
                      child: Text(
                        "Không có tệp nào được chọn!",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w200,
                          fontSize: FONT_SIZE_NORMAL,
                          color: COLOR_BLACK,
                        ),
                      ),
                    );
                  } else if (state is UploadFileSuccess) {
                    // leavingModel.PickedFileDatas = state.pickedFileDatas;
                    print(state);
                    return Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: COLOR_CARD_BACKGROUND,
                        ),
                        height: 70,
                        width: double.infinity,
                        child: ListView.builder(
                          itemCount: state.pickedFileDatas.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          right: 10,
                                          bottom: 10,
                                          top: 10,
                                          left: 10),
                                      width:
                                          85, // specify the width of the containers
                                      height: 50,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: COLOR_WHITE,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.file_present,
                                            color: COLOR_TEXT_MAIN,
                                          ),
                                          Text("File ${index + 1}"),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                        top: -5,
                                        right: -2,
                                        child: IconButton(
                                          iconSize: 16,
                                          icon: const Icon(
                                            Icons.close,
                                            color: COLOR_LATE,
                                          ),
                                          onPressed: () {
                                            // TODO: Add delete functionality
                                            print("de");
                                            context.read<UploadFileBloc>().add(
                                                PressDeleteButton(
                                                    index: index));
                                          },
                                        )),
                                  ],
                                ),
                                Container(
                                  width: 100,
                                  child: Text(
                                    state.pickedFileDatas[index].name
                                        .toString(),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    );
                  } else if (state is UploadFileFailure) {
                    return const Center(child: Text("Lỗi"));
                  } else {
                    return Center(
                      child: Text(
                        "Không có tệp nào được chọn!",
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w200,
                          fontSize: FONT_SIZE_NORMAL,
                          color: COLOR_BLACK,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
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

  Widget buildTypeLeaving() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Text(
                      "Loại nghỉ phép",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: FONT_SIZE_TEXT_BUTTON,
                        color: COLOR_TEXT_MAIN,
                      ),
                    ),
                    Text(
                      " *",
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: FONT_SIZE_TEXT_BUTTON,
                        color: COLOR_LATE,
                      ),
                    ),
                  ],
                ),
              ),
              FormField<String>(
                builder: (field) {
                  return DropdownSearch<LeavingType>(
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null) {
                        return 'Chọn 1 giá trị';
                      }
                      return null;
                    },
                    popupProps: PopupProps.menu(
                      itemBuilder: (context, item, isSelected) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 14),
                          child: Text(
                            item.label!,
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
                    // selectedItem: type,
                    items: typeLeaving,
                    onChanged: (newValue) {
                      type = newValue;
                    },
                    ///////////////////// ==========================
                    dropdownDecoratorProps: DropDownDecoratorProps(
                      baseStyle: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        fontSize: FONT_SIZE_TEXT_BUTTON,
                        color: COLOR_BLACK,
                      ),
                      dropdownSearchDecoration: InputDecoration(
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(
                            color: Colors.grey,
                          ),
                        ),
                        hintText: "Chọn 1 giá trị",
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
                  );
                },
              ),
            ],
          ),
        ),
      ],
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
}
