import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/models/report/report_model.dart';
import 'package:management_app/screens/create_page/create_report/task_report_item.dart';
import 'package:management_app/widgets/text_custom.dart';
import '../../../blocs/upload_file/upload_file_bloc.dart';
import '../../../blocs/upload_file/upload_file_event.dart';
import '../../../blocs/upload_file/upload_file_state.dart';
import '../../../models/report/item_task_report.dart';
import '../../../models/upload_file/PickedFileData.dart';
import '../../../widgets/assignment_item.dart';
import '../../../widgets/assignment_suggestion_input.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({super.key});

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final _formKey = GlobalKey<FormState>();
  List<PickedFileData> PickedFileDatas = [];
  final _dropdownReportKey = GlobalKey<DropdownSearchState<String>>();
  final titleDetailController = TextEditingController();
  final descpDetailController = TextEditingController();
  int maxLines = 1;
  int originalMaxLines = 5;
  List<String> assignment = [];
  String? reportType;
  Report report = new Report();
  List<ItemTaskReport> taskListReport = [];

  List<String> reportTypeList = [
    'Hôm nay',
    'Tuần nay',
  ];

  @override
  void initState() {
    super.initState();

    // Duyệt qua từng phần tử trong taskList (List<Map<String, String>>)
    for (Map<String, String> task in taskList) {
      // Tạo một đối tượng ItemTaskReport mới
      ItemTaskReport item = ItemTaskReport();

      // Gán giá trị cho các thuộc tính trong đối tượng ItemTaskReport từ Map
      item.taskName = task['task-name'];
      item.project = task['project'];
      item.startDay = task['start-day'];
      item.dueDay = task['due-day'];
      item.priority = task['priority'];
      item.dayLefts = task['day-lefts'];
      item.state = task['state'];

      // Thêm đối tượng ItemTaskReport đã gán giá trị vào danh sách taskListReport
      taskListReport.add(item);
    }
    report.taskListReport = taskListReport;
  }

  void addAssignment(String value, StateSetter stateSetter) {
    stateSetter(() {
      report.assignment.add(value);
    });
  }

  void removeAssignment(String value, StateSetter stateSetter) {
    stateSetter(() {
      report.assignment.remove(value);
    });
  }

  void saveForm() {
    print(report.nameReport);
    print(report.timeType);
    print(report.description);
    // print(report.taskListReport);
    for (ItemTaskReport item in report.taskListReport) {
      print("Task Name: ${item.taskName}");
      print("Project: ${item.project}");
      print("Start Day: ${item.startDay}");
      print("Due Day: ${item.dueDay}");
      print("Priority: ${item.priority}");
      print("Day Lefts: ${item.dayLefts}");
      print("State: ${item.state}");
      print("--------------------------------------");
    }
    print(report.PickedFileDatas);
    print(report.assignment);
  }

  @override
  Widget build(BuildContext context) {
    print("rebuild create report");
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          title: const TextCustom(
              text: "Tạo báo cáo",
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_BIG,
              fontWeight: FontWeight.w600),
          automaticallyImplyLeading: true,
          backgroundColor: COLOR_WHITE,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: COLOR_BLACK),
          actionsIconTheme: const IconThemeData(color: COLOR_DELAY),
        ),
        bottomNavigationBar: buttonBottoms(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Form(
              key: _formKey,
              child: Column(children: [
                inputTimeType(),
                const SizedBox(
                  height: 16,
                ),
                inputReportName(),
                const SizedBox(
                  height: 16,
                ),
                buildDescription(),
                const SizedBox(
                  height: 16,
                ),
                listTask(),
                const SizedBox(
                  height: 16,
                ),
                uploadFile(),
                const SizedBox(
                  height: 16,
                ),
                assignmentWidget(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget inputTimeType() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Row(
          children: [
            const TextCustom(
                text: 'Thời gian',
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_NORMAL,
                fontWeight: FontWeight.w500),
            const SizedBox(
              width: 2,
            ),
            const TextCustom(
                text: '*',
                color: Colors.red,
                fontSize: FONT_SIZE_NORMAL,
                fontWeight: FontWeight.w500),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              flex: 2,
              child: DropdownSearch<String>(
                key: _dropdownReportKey,
                onChanged: (newValue) {
                  report.timeType = newValue;
                },
                autoValidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) {
                  if (value == null) {
                    return 'Chọn 1 loại';
                  }
                  return null;
                },
                selectedItem: report.timeType,
                popupProps: PopupProps.menu(
                  itemBuilder: (context, item, isSelected) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 14),
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
                items: reportTypeList,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
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
                    )),
              ),
            ),
            const Expanded(
              flex: 1,
              child: Text(''),
            )
          ],
        );
      },
    );
  }

  Widget inputReportName() {
    return StatefulBuilder(
      builder: (context, StateSetter setStateTitle) {
        return Column(
          children: [
            const Row(
              children: [
                TextCustom(
                    text: "Tiêu đề",
                    color: COLOR_TEXT_MAIN,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w500),
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
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    // controller: titleDetailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tiêu đề báo cáo';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      labelStyle: TextStyle(
                          color: COLOR_BLACK, fontSize: FONT_SIZE_NORMAL),
                      fillColor: Color.fromARGB(255, 255, 255, 255),
                      filled: true,
                      focusColor: COLOR_GREEN,
                      hintStyle: TextStyle(color: Colors.blue),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    ),
                    onChanged: (value) {
                      report.nameReport = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget buildDescription() {
    return StatefulBuilder(
      builder: (context, StateSetter setStateDes) {
        return Column(
          children: [
            const Row(
              children: [
                TextCustom(
                    text: "Mô tả",
                    color: COLOR_TEXT_MAIN,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w500),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              // controller: descpDetailController,
              textCapitalization: TextCapitalization.words,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              maxLines: maxLines,
              onChanged: (value) {
                setStateDes(() {
                  report.description = value;
                  originalMaxLines = maxLines;
                  int newMaxLines = value.length ~/
                          (MediaQuery.of(context).size.width * 0.102) +
                      1;
                  maxLines = newMaxLines.clamp(1, 3);
                });
              },
              decoration: InputDecoration(
                labelStyle: const TextStyle(
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_NORMAL,
                ),
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
              validator: (value) {
                // Add your validation logic here if needed
                if (value == null) {
                  return 'Chọn 1 loại';
                }
                return null; // Return null if the value is valid, or an error message if invalid.
              },
            ),
          ],
        );
      },
    );
  }

  Widget taskItemBuilder() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: taskList.length,
      itemBuilder: (context, index) {
        return TaskReportItem(
          data: taskList[index],
        );
      },
    );
  }

  Widget listTask() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextCustom(
                text: "Danh sách công việc",
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_NORMAL,
                fontWeight: FontWeight.w500),
            const SizedBox(
              height: 8,
            ),
            SizedBox(height: 230, child: taskItemBuilder())
          ],
        );
      },
    );
  }

  Widget uploadFile() {
    return Row(children: [
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
                  offset: const Offset(2, 4), // Shadow position
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
      const SizedBox(
        width: 10,
      ),
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
            PickedFileDatas = state.pickedFileDatas;
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
                                  right: 10, bottom: 10, top: 10, left: 10),
                              width: 85, // specify the width of the containers
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: COLOR_WHITE,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
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
                                    context
                                        .read<UploadFileBloc>()
                                        .add(PressDeleteButton(index: index));
                                  },
                                )),
                          ],
                        ),
                        Container(
                          width: 100,
                          child: Text(
                            state.pickedFileDatas[index].name.toString(),
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
    ]);
  }

  Widget assignmentWidget() {
    return StatefulBuilder(
      builder: (context, setAssignmentState) => Column(
        children: [
          const Row(
            children: [
              Row(
                children: [
                  TextCustom(
                      text: "Người nhận",
                      color: COLOR_TEXT_MAIN,
                      fontSize: FONT_SIZE_NORMAL,
                      fontWeight: FontWeight.w500),
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
                        ...report.assignment.map(
                          (e) => Column(
                            children: [
                              AssignmentItem(
                                name: e,
                                remove: (String value) {
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
                  chooseAssign: (String value) {
                    addAssignment(value, setAssignmentState);
                    field.didChange(value);
                  },
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
              if (report.assignment.isEmpty) {
                return 'Giao cho ít nhất một người';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget buttonBottoms() {
    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              OutlinedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 233, 231)),
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                    side: MaterialStateProperty.all<BorderSide>(
                        const BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255)))),
                onPressed: () => {
                  // setState(() {
                  //   titleController.text = '';
                  //   descpController.text = '';
                  //   _selectedTime = '';
                  //   _selectedEndTime = '';
                  // }),
                  Navigator.pop(context)
                },
                child: const Text('Hủy'),
              ),
              const SizedBox(
                width: 20,
              ),
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
                  'Gửi',
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
      },
    );
  }
}
