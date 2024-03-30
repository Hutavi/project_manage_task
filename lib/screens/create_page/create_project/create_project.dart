import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/models/project/project_model.dart';
import 'package:management_app/widgets/assignment_item2.dart';
import 'package:management_app/widgets/assignment_suggestion_input2.dart';
import 'dart:convert';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../data/data.dart';
import '../../../models/user/user_model.dart';
import '../../../services/dio_client.dart';
import '../../home_page/task_tab/cancel_dialog.dart';

class CreateProject extends StatefulWidget {
  final data;
  const CreateProject({Key? key, this.data}) : super(key: key);

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  final _formkey = GlobalKey<FormState>();

  final Set<String> selectedStatuses = {};
  final _controller_progress = TextEditingController();
  final _controller_title = TextEditingController();
  final _controlller_description = TextEditingController();
  final formatter = DateFormat.yMd();
  ProjectModel project = ProjectModel();
  List<UserModel> listUser = [];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _controller_progress.dispose();
    _controller_title.dispose();
    _controlller_description.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    project.assigned_owners = [];
    print("Từ trang " + widget.data.toString());
    fetchData();
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
        if (type == 'startDate') {
          project.startdate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(project.startdate);
        } else if (type == 'finishPlanDate') {
          project.targetenddate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(project.targetenddate);
        } else if (type == 'finishDate') {
          project.actualenddate = DateFormat('dd/MM/yyyy').format(pickedDate!);
          field.didChange(project.actualenddate);
        }
      },
    );
  }

  void addAssignment(UserModel value, StateSetter stateSetter) {
    print("object");
    print(value);
    stateSetter(() {
      project.assigned_owners?.add(value);
    });
  }

  void removeAssignment(UserModel value, StateSetter stateSetter) {
    stateSetter(() {
      project.assigned_owners?.remove(value);
    });
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

  Future<void> saveForm() async {
    try {
      print("object");
      project.projectstatus = selectedStatuses.first;
      project.progress = _controller_progress.text;
      print(project);
      if (project.projectstatus == "Kế hoạch") {
        project.projectstatus = "plan";
      } else if (project.projectstatus == "Đang tiến hành") {
        project.projectstatus = "In Progress";
      } else if (project.projectstatus == "Hoàn thành") {
        project.projectstatus = "Completed";
      } else {
        project.projectstatus = "late";
      }

      project.assigned_user_id =
          project.assigned_owners!.map((user) => 'Users:${user.id}').join(',');
      print(project.assigned_user_id);

      final dioClient = DioClient();
      final response = await dioClient.request(
        '/apis/OpenAPI/create',
        queryParameters: {'module': 'Project'},
        data: json.encode({
          "data": {
            "projectname": project.projectname,
            "startdate": project.startdate,
            "targetenddate": project.targetenddate,
            "actualenddate": project.actualenddate,
            "projectstatus": project.projectstatus,
            "projecttype": project.projecttype,
            "progress": project.progress,
            "description": project.description,
            "assigned_user_id": project.assigned_user_id
          }
        }),
        options: Options(method: 'POST'),
      );

      if (response.statusCode == 200) {
        print("chạy ok");
        print(response.data);
        Map<String, dynamic> responseData = json.decode(response.data);
        String success = responseData['success'];

        if (success == '1') {
          // Thực hiện các điều kiện tương ứng khi success là '1'
          // ignore: use_build_context_synchronously
          Navigator.pushNamed(context, '/listProject');
        } else {
          // Thực hiện các điều kiện tương ứng khi success không phải '1'
        }
        setState(() {});
        // print(listLeaving);
        // if (response.success == 1) {}
      } else {
        print("lỗi");
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        bottomNavigationBar: buildSaveAndCancelButton(),
        appBar: AppBar(
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: COLOR_WHITE,
          iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
          title: Text(
            'Tạo dự án',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_SMALL_TITLE,
              color: COLOR_TEXT_MAIN,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              showCancelDialog(context);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget(),
                  buildStatus(),
                  Row(
                    children: [
                      typeWidget(),
                      const SizedBox(
                        width: 20,
                      ),
                      startDateWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      finishDateWidget(),
                      const SizedBox(
                        width: 20,
                      ),
                      finishPlanDateWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  assignmentWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  descriptionWidget(),
                  const SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
              if (_formkey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Processing Data')),
                );
                saveForm();
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

  Widget titleWidget() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Tiêu đề',
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
        TextFormField(
          controller: _controller_title,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: COLOR_TEXT_MAIN,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            color: COLOR_BLACK,
          ),
          decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
              errorStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                value.trim().length <= 1 ||
                value.trim().length > 50) {
              return 'Phải tồn tại giá trị trong khoảng từ 1 đến 50 kí tự';
            }
            return null;
          },
          onChanged: (value) {
            project.projectname = value;
          },
        ),
      ],
    );
  }

  Widget typeWidget() {
    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'Loại',
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
              project.projecttype = newValue;
            },
            autoValidateMode: AutovalidateMode.onUserInteraction,
            validator: (value) {
              if (value == null) {
                return 'Chọn 1 loại';
              }
              return null;
            },
            selectedItem: project.projecttype,
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
              showSelectedItems: true,
            ),
            items: typeOptionList,
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

  Widget stateWidget() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tình trạng',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              fontSize: FONT_SIZE_TEXT_BUTTON,
              color: COLOR_TEXT_MAIN,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          DropdownSearch<String>(
            onChanged: (value) {
              project.projectstatus = value;
            },
            onSaved: (newValue) {
              project.projectstatus = newValue;
            },
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
              showSelectedItems: true,
            ),
            items: stateOptionList,
            selectedItem: project.projectstatus,
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
                    _presentDatePicker('startDate', field, setStartDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        project.startdate == null
                            ? 'Chọn 1 ngày'
                            : project.startdate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'startDate', field, setStartDateState);
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
            if (project.startdate == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
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
                    'Ngày KT kế hoạch',
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
                    _presentDatePicker(
                        'finishPlanDate', field, setFinishPlanDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        project.targetenddate == null
                            ? 'Chọn 1 ngày'
                            : project.targetenddate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'finishPlanDate', field, setFinishPlanDateState);
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
            if (project.targetenddate == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget finishDateWidget() {
    return StatefulBuilder(
      builder: (context, setFinishDateState) => Expanded(
        child: FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
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
                    _presentDatePicker('finishDate', field, setFinishDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        project.actualenddate == null
                            ? 'Chọn 1 ngày'
                            : project.actualenddate!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'finishDate', field, setFinishDateState);
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
            if (project.actualenddate == null) {
              return 'Chọn 1 ngày';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget buildProgress() {
    return Expanded(
      flex: 3,
      child: StatefulBuilder(
        builder: (context, setState) {
          return Column(
            children: [
              Row(
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
              const SizedBox(
                height: 10,
              ),
              FormField(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  final double parsedValue =
                      double.tryParse(value.toString()) ?? 0;
                  if (parsedValue == null ||
                      parsedValue < 0 ||
                      parsedValue > 100) {
                    return "Nhập giá trị từ 0-100";
                  }
                  return null; // Return null if the input is valid.
                },
                builder: (field) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            onChanged: (value) {
                              field.didChange(value);
                            },
                            keyboardType: TextInputType.number,
                            style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontSize: FONT_SIZE_TEXT_BUTTON,
                              color: COLOR_TEXT_MAIN,
                            ),
                            controller: _controller_progress,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
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
                              hintText: 'Nhập % tiến độ',
                              hintStyle: TextStyle(
                                color: COLOR_TEXT_MAIN,
                                fontSize: FONT_SIZE_TEXT_BUTTON,
                              ),
                            ),
                          ),
                        ),
                        // SizedBox(width: 5),
                        Expanded(
                          flex: 2,
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
                                bottom:
                                    BorderSide(color: Colors.grey, width: 1),
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
                              hint: const Text("Chọn %"),
                              underline: const SizedBox(),
                              items: progresses.map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                _controller_progress.text = value!;
                              },
                            ),
                          ),
                        ),
                      ]),
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
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  Widget assignmentWidget() {
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
                        if (project.assigned_owners!.isNotEmpty)
                          ...project.assigned_owners!.map((e) {
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
              if (project.assigned_owners!.isEmpty) {
                return 'Giao cho ít nhất một người';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget descriptionWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Mô tả',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w500,
                fontSize: FONT_SIZE_TEXT_BUTTON,
                color: COLOR_TEXT_MAIN,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
          maxLines: 2,
          controller: _controlller_description,
          cursorColor: COLOR_TEXT_MAIN,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            color: COLOR_TEXT_MAIN,
          ),
          onChanged: (value) {
            project.description = value;
          },
          decoration: const InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            border: UnderlineInputBorder(
              borderSide: BorderSide(color: COLOR_GRAY),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_GRAY),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: COLOR_GRAY),
            ),
          ),
        ),
      ],
    );
  }
}
