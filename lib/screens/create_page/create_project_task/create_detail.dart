import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/models/category/category_project_model.dart';
import 'package:management_app/models/project/project_model.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../models/user/user_model.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/assignment_item2.dart';
import '../../../widgets/assignment_suggestion_input2.dart';
import '../../../widgets/text_custom.dart';
import '../../home_page/task_tab/cancel_dialog.dart';

class CreateProjectTaskDetail extends StatefulWidget {
  final data;
  const CreateProjectTaskDetail({Key? key, this.data}) : super(key: key);

  @override
  _CreateProjectTaskDetailState createState() =>
      _CreateProjectTaskDetailState();
}

class _CreateProjectTaskDetailState extends State<CreateProjectTaskDetail> {
  final _formkey = GlobalKey<FormState>();
  String? selectedProgress;
  final _controller_progress = TextEditingController();
  final _controller_title = TextEditingController();
  final _controller_description = TextEditingController();
  final projectInputController = TextEditingController();

  final _dropdownCategoryKey = GlobalKey<DropdownSearchState<String>>();
  final Set<String> selectedPriorities = {};
  final Set<String> selectedStatuses = {};
  bool categoryEnable = false;

  List<ProjectModel> projectList = [];
  List<CategoryProjectModel> categoryList = [];
  List<UserModel> userList = [];

  String? projecttaskname;
  ProjectModel project = ProjectModel();
  CategoryProjectModel category = CategoryProjectModel();
  String? start_date_plan;
  String? end_date_plan;
  String? startdate;
  String? enddate;
  String? projecttaskstatus;
  String? projecttaskpriority;
  List<UserModel> assigned_owners = [];
  String? description;

  @override
  void initState() {
    // TODO: implement initState
    getProjectListData();
    fetchUserData();
    if (widget.data != null) {
      print(widget.data);
      // _controller_title.text = widget.data['task-name'];
      // projectTask.title = widget.data['task-name'];
      // projectInputController.text = widget.data['project'];
      // projectTask.project = widget.data['project'];
      // categoryEnable = true;
      // _controller_progress.text = widget.data['progress'];
      // projectTask.description = widget.data['description'];
      // projectTask.category = widget.data['category'];
      // selectedPriorities.add(widget.data['priority']);
      // selectedStatuses.add(widget.data['state']);
      // _controller_description.text = widget.data['description'];
      // projectTask.priority = widget.data['priority'];
      // projectTask.startDate = widget.data['startDay'];
      // projectTask.finishPlanDate = widget.data['finishPlanDay'];
      // projectTask.startPlanDate = widget.data['startPlanDay'];
      // projectTask.finishDate = widget.data['finishDay'];

      // projectTask.assignment =
      //     List<String>.from(json.decode(widget.data["assign"]));
    } else {
      start_date_plan = DateFormat('yyyy-MM-dd').format(DateTime.now());
      selectedStatuses.add('Kế hoạch');
      selectedPriorities.add("Thấp");
      projecttaskstatus = 'plan';
      projecttaskpriority = 'low';
    }
    super.initState();
  }

  bool isPositiveIntegerInRange(String value) {
    try {
      if (value.isEmpty) return true;
      int number = int.parse(value);
      return number >= 0 && number <= 100;
    } catch (e) {
      return false;
    }
  }

  void _presentDatePicker(
    String type,
    FormFieldState<Object?> field,
    StateSetter stateSetter,
  ) async {
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
          startdate = DateFormat('yyyy-MM-dd').format(pickedDate!);
          field.didChange(startdate);
        } else if (type == 'finishPlanDate') {
          end_date_plan = DateFormat('yyyy-MM-dd').format(pickedDate!);
          field.didChange(end_date_plan);
        } else if (type == 'startPlanDate') {
          start_date_plan = DateFormat('yyyy-MM-dd').format(pickedDate!);
          field.didChange(start_date_plan);
        } else if (type == 'finishDate') {
          enddate = DateFormat('yyyy-MM-dd').format(pickedDate!);
          field.didChange(enddate);
        }
      },
    );
  }

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

  List<ProjectModel> projectSuggestion(String value) {
    List<ProjectModel> suggestion = [];
    if (value.isNotEmpty) {
      for (final i in projectList) {
        if (i.projectname!.toLowerCase().contains(value.toLowerCase())) {
          suggestion.add(i);
        }
      }
    }
    return suggestion;
  }

  void getProjectListData() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        '/apis/OpenAPI/list',
        queryParameters: {'module': 'Project'},
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('get project list success!');
        final parsed = json.decode(response.data!);
        for (var entry in parsed['entry_list']) {
          ProjectModel projectModel = ProjectModel.fromMap(entry);
          projectList.add(projectModel);
        }
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void getCategoryListData() async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/relatedList',
        queryParameters: {
          'parent_module': 'Project',
          'parent_record': project.projectid,
          'relation_id': '332',
        },
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        // Xử lý dữ liệu nhận được từ response.data
        print('Success category!');
        final parsed = json.decode(response.data!).cast<String, dynamic>();
        List<dynamic> entryList = parsed['entry_list'];
        for (var entry in entryList) {
          Map<String, dynamic> convertedMap = entry;
          CategoryProjectModel categoryModel =
              CategoryProjectModel.fromMap(convertedMap);
          categoryList.add(categoryModel);
        }
        print(categoryList);
        setState(() {});
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void sendProjectTask(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/create',
        queryParameters: {
          'module': 'ProjectTask',
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        'thành công';
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
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

  void saveForm() {
    print('===== SAVE =====');

    print(projecttaskname);
    print(project.projectid);
    print(category.crmid);
    print(start_date_plan);
    print(end_date_plan);
    print(projecttaskpriority);
    print(startdate);
    print(enddate);
    print(_controller_progress.text);
    print(projecttaskstatus);
    print(assigned_owners);
    print(description);

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime dateToCompare = dateFormat.parse(start_date_plan!);
    DateTime today = DateTime.now();

    Duration difference = dateFormat
        .parse(end_date_plan!)
        .difference(dateFormat.parse(start_date_plan!));

    var data = json.encode({
      "data": {
        "projecttaskname": projecttaskname,
        "projectid": project.projectid,
        "related_cpprojectitem": category.crmid,
        "start_date_plan": start_date_plan,
        "end_date_plan": end_date_plan,
        "startdate": startdate,
        "enddate": enddate,
        "projecttaskpriority": projecttaskpriority,
        "leadtime": difference.inDays.abs().toString(),
        "projecttaskstatus": projecttaskstatus,
        "projecttaskprogress": '${_controller_progress.text}%',
        "assigned_owners": assigned_owners,
        "description": description,
      }
    });

    sendProjectTask(data);
  }

  void enableCategory() {
    setState(() {
      categoryEnable = true;
      getCategoryListData();
    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');

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
            'Tạo tác vụ dự án',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_SMALL_TITLE,
              color: COLOR_TEXT_MAIN,
            ),
          ),
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
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 21, left: 15, right: 15, bottom: 20),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  titleWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  projectNameWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      categoryWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      startPlanDateWidget(),
                      const SizedBox(
                        width: 20,
                      ),
                      finishPlanDateWidget(),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      startDateWidget(),
                      const SizedBox(
                        width: 20,
                      ),
                      finishDateWidget(),
                    ],
                  ),
                  buildProgress(),
                  const SizedBox(
                    height: 20,
                  ),
                  buildStatus(),
                  const SizedBox(
                    height: 10,
                  ),
                  buildPriority(),
                  const SizedBox(
                    height: 20,
                  ),
                  assignmentWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  descriptionWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
            selectedColor: (item['color'] as Color),
            onSelected: (selected) {
              setStatePriority(() {
                if (selected) {
                  selectedPriorities.clear();
                  selectedPriorities.add(item['label'].toString());
                  projecttaskpriority = item['value'].toString();
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
    return FormField<String>(
      validator: (value) {
        if (selectedPriorities.length <= 0) {
          return 'Vui lòng chọn độ ưu tiên';
        }
        return null;
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Độ ưu tiên',
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
            StatefulBuilder(
              builder: (context, setStatePriority) =>
                  buildPrioritySelection(setStatePriority),
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
        );
      },
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
                  projecttaskstatus = status['value'].toString();
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
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Expanded(
                      flex: 3,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_TEXT_MAIN,
                        ),
                        validator: (value) {
                          if (!isPositiveIntegerInRange(value!)) {
                            return 'Giá trị không hợp lệ';
                          }
                          return null;
                        },
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
                    const Expanded(flex: 3, child: SizedBox()),
                  ]),
                ],
              ),
            ),
          ],
        );
      },
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
            if (value == null || value.isEmpty) {
              return 'Chưa nhập tiêu đề';
            }
            return null;
          },
          onChanged: (value) {
            projecttaskname = value;
          },
        ),
      ],
    );
  }

  Widget projectNameWidget() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              'Dự án',
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
        FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              projectSuggestionInput(field),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                  ),
                  child: Text(
                    field.errorText!,
                    style: GoogleFonts.montserrat(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                    ),
                  ),
                )
            ],
          ),
          validator: (value) {
            if (project.projectid == null) {
              return 'Chọn một dự án';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget categoryWidget() {
    return Expanded(
      child: Opacity(
        opacity: categoryEnable ? 1 : 0.4,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Hạng mục dự án',
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
            DropdownSearch<CategoryProjectModel>(
              key: _dropdownCategoryKey,
              enabled: categoryEnable,
              onChanged: (newValue) {
                category = newValue!;
              },
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null) {
                  return 'Chọn 1 loại';
                }
                return null;
              },
              // selectedItem: projectTask.category,
              popupProps: PopupProps.menu(
                itemBuilder: (context, item, isSelected) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 14),
                    child: Text(
                      item.name!,
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
              items: categoryList,
              dropdownDecoratorProps: DropDownDecoratorProps(
                baseStyle: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_BLACK,
                ),
                dropdownSearchDecoration: InputDecoration(
                  hintText:
                      project.id == null ? 'Chọn dự án trước' : 'Chọn hạng mục',
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
                  disabledBorder: const OutlineInputBorder(
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
      ),
    );
  }

  Widget startPlanDateWidget() {
    return StatefulBuilder(
      builder: (context, setStartPlanDateState) => Expanded(
        child: FormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Ngày BĐ kế hoạch',
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
                        'startPlanDate', field, setStartPlanDateState);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        start_date_plan == null
                            ? 'Chọn 1 ngày'
                            : start_date_plan!,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_BLACK,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _presentDatePicker(
                              'startPlanDate', field, setStartPlanDateState);
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
            if (start_date_plan == null) {
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
                        end_date_plan == null ? 'Chọn 1 ngày' : end_date_plan!,
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
            if (end_date_plan == null) {
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
              Text(
                'Ngày bắt đầu',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
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
                        startdate == null ? 'Chọn 1 ngày' : startdate!,
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
                ),
            ],
          ),
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
              Text(
                'Ngày kết thúc',
                style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  color: COLOR_TEXT_MAIN,
                ),
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
                        enddate == null ? 'Chọn 1 ngày' : enddate!,
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
        ),
      ),
    );
  }

  Widget projectSuggestionInput(FormFieldState<Object?> field) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: projectInputController,
        style: GoogleFonts.montserrat(
          color: const Color.fromARGB(255, 106, 106, 106),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        onChanged: (value) {
          if (value.isEmpty) {
            setState(() {
              categoryEnable = false;
            });
            _dropdownCategoryKey.currentState?.clear();
          }
        },
        decoration: InputDecoration(
          hintText: 'Nhập tên dự án',
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
        field.didChange(suggestion);
        projectInputController.text = suggestion.projectname!;
        project = suggestion;
        enableCategory();
      },
      itemBuilder: (ctx, suggestion) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: TextCustom(
          text: suggestion.projectname!,
          fontSize: FONT_SIZE_TEXT_BUTTON,
          fontWeight: FontWeight.w500,
          color: COLOR_TEXT_MAIN,
        ),
      ),
      suggestionsCallback: (pattern) {
        List<ProjectModel> matches = projectSuggestion(pattern);
        return matches;
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
                        fontSize: 12,
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
          controller: _controller_description,
          maxLines: 2,
          cursorColor: COLOR_TEXT_MAIN,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            color: COLOR_TEXT_MAIN,
          ),
          onChanged: (value) {
            description = value;
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
