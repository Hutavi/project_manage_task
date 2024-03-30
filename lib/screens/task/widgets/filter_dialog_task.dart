import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';
import '../../../data/data.dart';

class FilterDialogTask extends StatefulWidget {
  const FilterDialogTask(
      {Key? key, required this.setValue, required this.value})
      : super(key: key);

  final Function(Map<String, List<String>> value) setValue;
  final Map<String, List<String>> value;

  @override
  _FilterDialogTaskState createState() => _FilterDialogTaskState();
}

class _FilterDialogTaskState extends State<FilterDialogTask> {
  // Define sets for the selected items
  final Set<String> selectedStatuses = {};
  final Set<String> statusValue = {};
  final Set<String> selectedPriorities = {};
  final Set<String> priorityValue = {};
  final Set<String> selectedTime = {};
  final Set<String> timeValue = {};

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
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_NORMAL,
                  fontWeight: FontWeight.w600,
                )),
            selected: isSelected,
            selectedColor: (item['color'] as Color).withOpacity(0.5),
            onSelected: (selected) {
              setStatePriority(() {
                if (selected) {
                  selectedPriorities.add(item['label'].toString());
                  priorityValue.add(item['value'].toString());
                } else {
                  selectedPriorities.remove(item['label'].toString());
                  priorityValue.add(item['value'].toString());
                }
              });
            },
          );
        },
      ).toList(),
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
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_NORMAL,
                  fontWeight: FontWeight.w600,
                )),
            selected: isSelected,
            selectedColor: status['color'] as Color,
            onSelected: (selected) {
              setStateStatus(() {
                if (selected) {
                  selectedStatuses.add(status['label'].toString());
                  statusValue.add(status['value'].toString());
                } else {
                  selectedStatuses.remove(status['label'].toString());
                  statusValue.remove(status['value'].toString());
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  String startDate = '';
  String endDate = '';

  void _presentDatePicker(StateSetter stateSetter) async {
    final now = DateTime.now();
    final pickedDate = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
    );
    stateSetter(() {
      if (pickedDate != null &&
          pickedDate.start != null &&
          pickedDate.end != null) {
        startDate = DateFormat('yyyy-MM-dd').format(pickedDate.start);
        endDate = DateFormat('yyyy-MM-dd').format(pickedDate.end);
      }
    });
  }

  Widget buildTimeSelection(StateSetter setStateStatus) {
    return Wrap(
      spacing: 10,
      runSpacing: 5,
      children: time_list_2.map(
        (time) {
          final isSelected = selectedTime.contains(time['label']);
          return ChoiceChip(
            label: Container(
              constraints: const BoxConstraints(maxWidth: 180),
              child: Text(
                time['label'].toString() != 'Chọn khoảng thời gian'
                    ? time['label'].toString()
                    : '${time['label'].toString()} ($startDate - $endDate)',
                style: GoogleFonts.montserrat(
                  color: COLOR_BLACK,
                  fontSize: FONT_SIZE_NORMAL,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                softWrap: true,
              ),
            ),
            selected: isSelected,
            selectedColor: time['color'] as Color,
            onSelected: (selected) {
              setStateStatus(() {
                if (selected) {
                  if (time['label'].toString() == 'Chọn khoảng thời gian') {
                    _presentDatePicker(setStateStatus);
                  }
                  selectedTime.add(time['label'].toString());
                  timeValue.add(time['label'].toString());
                } else {
                  selectedTime.remove(time['label'].toString());
                  timeValue.remove(time['label'].toString());
                }
              });
            },
          );
        },
      ).toList(),
    );
  }

  // Widget buildTimeSelection(StateSetter setStateTime) {
  //   return ListView.builder(
  //     shrinkWrap: true,
  //     itemCount: time_list.length,
  //     itemBuilder: (context, index) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(10),
  //           color: (selectedTime == time_list[index])
  //               ? const Color.fromARGB(20, 144, 144, 144)
  //               : null,
  //         ),
  //         child: ListTile(
  //           title: Text(
  //             time_list[index],
  //             style: GoogleFonts.montserrat(
  //               color: COLOR_TEXT_MAIN,
  //               fontSize: FONT_SIZE_NORMAL,
  //               fontWeight: FontWeight.w600,
  //             ),
  //           ),
  //           onTap: () {
  //             setStateTime(() {
  //               selectedTime = time_list[index];
  //             });
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Positioned(
              top: 50,
              right: 0,
              child: SizedBox(
                width: screenSize.width * 0.85,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                  ),
                  child: Material(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bộ lọc',
                                style: GoogleFonts.montserrat(
                                  color: COLOR_GREEN,
                                  fontSize: FONT_SIZE_BIG,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Icon(Icons.clear,
                                      color: COLOR_LATE)),
                            ],
                          ),
                          const Divider(),
                          Text(
                            'Tuỳ chọn độ ưu tiên',
                            style: GoogleFonts.montserrat(
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_BIG,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: StatefulBuilder(
                              builder: (context, setStatePriority) =>
                                  buildPrioritySelection(setStatePriority),
                            ),
                          ),
                          Text(
                            'Tuỳ chọn trạng thái',
                            style: GoogleFonts.montserrat(
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_BIG,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: StatefulBuilder(
                              builder: (context, setStateStatus) =>
                                  buildStatusSelection(setStateStatus),
                            ),
                          ),
                          Text(
                            'Tuỳ chọn thời gian',
                            style: GoogleFonts.montserrat(
                              color: COLOR_BLACK,
                              fontSize: FONT_SIZE_BIG,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: StatefulBuilder(
                              builder: (context, setStateTime) =>
                                  buildTimeSelection(setStateTime),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: COLOR_GREEN,
                                  shape: const StadiumBorder(),
                                  padding: EdgeInsets.symmetric(horizontal: 30),
                                ),
                                onPressed: () {
                                  widget.setValue(
                                    {
                                      'priority':
                                          List<String>.from(priorityValue),
                                      'status': List<String>.from(statusValue),
                                      'time': List<String>.from(timeValue),
                                      'dateRange': [startDate, endDate],
                                    },
                                  );
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Xong',
                                  style: GoogleFonts.montserrat(
                                    color: COLOR_WHITE,
                                    fontSize: FONT_SIZE_TEXT_BUTTON,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
