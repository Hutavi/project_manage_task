import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/widgets/assignment_suggestion_input2.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../models/project/project_model.dart';
import '../../../models/user/user_model.dart';
import '../../../services/dio_client.dart';
import '../../../widgets/assignment_item2.dart';
import '../../../widgets/text_custom.dart';
import '../../home_page/task_tab/cancel_dialog.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({Key? key}) : super(key: key);

  @override
  _CreateCategoryState createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  final _formkey = GlobalKey<FormState>();
  List<ProjectModel> projectList = [];
  List<UserModel> userList = [];

  String? categoryname;
  ProjectModel project = ProjectModel();
  String? description;
  List<UserModel> assigned_owners = [];

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

  final projectInputController = TextEditingController();

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

  void sendCategory(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/create',
        queryParameters: {
          'module': 'CPProjectItem',
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        print('tạo category thành công');
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
    print(categoryname);
    print(project.projectid);
    print(description);
    print(assigned_owners);
    List<Map<String, dynamic>> assigned_owners_list = [];

    for (UserModel userItem in assigned_owners) {
      assigned_owners_list.add(userItem.toMap());
    }

    var data = json.encode({
      "data": {
        "name": categoryname,
        "related_project": project.projectid,
        "assigned_user_id": "1",
        "description": description,
        "assigned_owners": assigned_owners_list,
      }
    });
    sendCategory(data);
  }

  @override
  void initState() {
    // TODO: implement initState
    getProjectListData();
    fetchUserData();
    super.initState();
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
            'Tạo hạng mục dự án',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_SMALL_TITLE,
              color: COLOR_TEXT_MAIN,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              // if () {
              //   showCancelDialog(context);
              // } else {
              Navigator.pop(context);
              // }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 21, left: 15, right: 15, bottom: 20),
              child: Column(
                children: [
                  titleWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  projectNameWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  descriptionWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  assignmentWidget(),
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
          height: 10,
        ),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          cursorColor: COLOR_TEXT_MAIN,
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.w500,
            fontSize: FONT_SIZE_TEXT_BUTTON,
            color: COLOR_TEXT_MAIN,
          ),
          decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
              errorStyle: GoogleFonts.montserrat(fontWeight: FontWeight.w500)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Phải tồn tại giá trị trong khoảng từ 1 đến 50 kí tự';
            }
            return null;
          },
          onChanged: (value) {
            categoryname = value;
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
            if (project.projectid == null || project.projectid!.isEmpty) {
              return 'Chọn một dự án';
            }
            return null;
          },
        ),
      ],
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
                color: COLOR_BLACK,
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        TextFormField(
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

  Widget projectSuggestionInput(FormFieldState<Object?> field) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: projectInputController,
        style: GoogleFonts.montserrat(
          color: const Color.fromARGB(255, 106, 106, 106),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        decoration: InputDecoration(
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
}
