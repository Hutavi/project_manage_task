import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/models/calendar/calendardata.dart';
import 'package:management_app/screens/details_page/detail_calendar/detail_calendar.dart';
import 'package:management_app/screens/calendar_page/item_calendar.dart';
import 'package:management_app/widgets/text_custom.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../services/dio_client.dart';
import '../home_page/menu/menu_option.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  // DateTime today = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  String? timeStart;
  bool? checkStatus;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  // Map<String, List> mySelectedEvents = {};
  final titleController = TextEditingController();
  final descpController = TextEditingController();
  Map<String, List<Map<String, dynamic>>> convertedData = {};
  List<DataCalendarModel> dataCalendarList = [];
  bool isDataLoaded = false;
  int currentTabIndex = 0; // Default tab index
  bool showFab = true; // Flag to show FloatingActionButton

  List<String> userList = [];
  List<String> users = [
    'Người dùng 1',
    'Người dùng 2',
    'Người dùng 3',
    'Người dùng 4',
    'Người dùng 5',
    'Người dùng 1',
    'Người dùng 2',
    'Người dùng 3',
    'Người dùng 4',
    'Người dùng 5',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
    checkStatus = true;
    showFab = true;
    fetchData();
    loadPreviousEvents();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addUser(String user) {
    setState(() {
      userList.add(user);
    });
  }

  void removeUser(String user) {
    setState(() {
      userList.remove(user);
    });
  }

  loadPreviousEvents() {
    convertedData = convertedData;
  }

  void fetchData() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        '/apis/OpenAPI/list',
        queryParameters: {'module': 'Calendar'},
        options: Options(method: 'GET'),
      );
      if (response.statusCode == 200) {
        print("object");
        final parsedResponse =
            json.decode(response.data!).cast<String, dynamic>();
        final dataList = parsedResponse['entry_list'];
        List<dynamic> responseData = dataList; // Dữ liệu nguồn từ API
        for (var entry in responseData) {
          final id = entry['id'];
          final dateStart = entry['date_start'];
          final startTime = entry['time_start'];
          final endTime = entry['time_end'];
          final status = entry['eventstatus'] == 'Planned';
          final title = entry['subject'];
          final description = entry['description'];
          final assigned = entry['assigned_owners'] != null
              ? (entry['assigned_owners'] as List)
                  .cast<Map<String, dynamic>>()
                  .map<Map<String, dynamic>>(
                      (owner) => owner as Map<String, dynamic>)
                  .toList()
              : [];

          final formattedDate =
              DateFormat('yyyy-MM-dd').format(DateTime.parse(dateStart));

          if (convertedData.containsKey(formattedDate)) {
            convertedData[formattedDate]!.add({
              'id': id,
              'dateEvent':
                  DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStart)),
              'startTime': startTime,
              'endTime': endTime,
              'status': status,
              'title': title,
              'descripton': description,
              'assigned': assigned,
            });
          } else {
            convertedData[formattedDate] = [
              {
                'id': id,
                'dateEvent':
                    DateFormat('dd/MM/yyyy').format(DateTime.parse(dateStart)),
                'startTime': startTime,
                'endTime': endTime,
                'status': status,
                'title': title,
                'descripton': description,
                'assigned': assigned,
              }
            ];
          }
        }
        // print(convertedData); // Đây là dữ liệu đã chuyển đổi theo yêu cầu
        setState(() {});
        isDataLoaded = true;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  List<Map<String, dynamic>> _listOfDayEvents(DateTime dateTime) {
    if (convertedData[DateFormat('yyyy-MM-dd').format(dateTime)] != null) {
      return convertedData[DateFormat('yyyy-MM-dd').format(dateTime)]!;
    } else {
      return [];
    }
  }

  void showOptionsDialog() {
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return const MenuOption();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_WHITE,
        elevation: 0,
        actions: <Widget>[
          IconButton(
            padding: const EdgeInsets.only(right: 10),
            icon: Image.asset(
              'lib/assets/images/home_page/options_button.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {
              showOptionsDialog();
            },
          ),
        ],
        title: const TextCustom(
            text: "Lịch",
            color: COLOR_TEXT_MAIN,
            fontSize: FONT_SIZE_BIG_TITLE,
            fontWeight: FontWeight.bold),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(children: [
        buildTableCalendar(),
        buildEventListOfDate(),
      ]),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              backgroundColor: COLOR_GREEN,
              onPressed: () {
                Navigator.pushNamed(context, '/createEvent');
              },
              heroTag: "_showAddEventDialog",
              label: const Text(
                'Thêm sự kiện',
                style: TextStyle(color: COLOR_WHITE),
              ),
            )
          : Stack(
              children: [
                Positioned(
                  bottom: 15,
                  left: 30,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 30,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (String user in userList)
                              Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: GestureDetector(
                                  onTap: () {
                                    removeUser(user);
                                  },
                                  child: const Stack(
                                    children: [
                                      Column(
                                        children: [
                                          CircleAvatar(
                                            radius: 20,
                                            backgroundColor: COLOR_TEXT_MAIN,
                                            child: Stack(
                                              children: [
                                                Icon(Icons.person,
                                                    color: Colors.white),
                                              ],
                                            ),
                                          ),
                                          Text("data")
                                        ],
                                      ),
                                      Positioned(
                                        top: -3,
                                        right: -3,
                                        child: CircleAvatar(
                                          radius: 10,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 15,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    List<String> filteredUsers = [
                                      ...users
                                    ]; // Sao chép danh sách gốc

                                    return StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return AlertDialog(
                                          title: Text(
                                            'Chọn người dùng',
                                            style: GoogleFonts.montserrat(
                                              color: COLOR_BLACK,
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Tìm kiếm...',
                                                  hintStyle:
                                                      TextStyle(fontSize: 14),
                                                  prefixIcon:
                                                      Icon(Icons.search),
                                                ),
                                                onChanged: (value) {
                                                  setState(() {
                                                    filteredUsers = users
                                                        .where((user) => user
                                                            .toLowerCase()
                                                            .contains(value
                                                                .toLowerCase()))
                                                        .toList();
                                                  });
                                                },
                                              ),
                                              SizedBox(
                                                height: 200,
                                                width: double.maxFinite,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children:
                                                      filteredUsers.map((user) {
                                                    return ListTile(
                                                      title: Text(user),
                                                      onTap: () {
                                                        addUser(user);
                                                        Navigator.pop(
                                                            context); // Đóng dialog
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              },
                              child: const Column(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: COLOR_TEXT_MAIN,
                                    child: Icon(Icons.add, color: Colors.white),
                                  ),
                                  Text("Thêm"),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget buildTableCalendar() {
    return TableCalendar(
      locale: "en_US",
      availableGestures: AvailableGestures.all,
      rowHeight: 38,
      daysOfWeekHeight: 20,
      focusedDay: _focusedDay,
      firstDay: DateTime.utc(2022, 10, 14),
      lastDay: DateTime.utc(2040, 10, 14),
      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDate, selectedDay)) {
          // Call `setState()` when updating the selected day
          setState(() {
            _selectedDate = selectedDay;
            _focusedDay = focusedDay;
          });
        }
      },
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      calendarFormat: _calendarFormat,
      // eventLoader: ,
      onFormatChanged: (format) {
        if (_calendarFormat != format) {
          setState(() {
            _calendarFormat = format;
          });
        }
      },
      eventLoader: _listOfDayEvents,
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          if (day.weekday != DateTime.sunday) {
            final text = DateFormat.E().format(day);
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: COLOR_GREEN),
              ),
            );
          } else {
            final text = DateFormat.E().format(day);
            return Center(
              child: Text(
                text,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }
        },
      ),
    );
  }

  Widget buildEventListOfDate() {
    return Expanded(
      child: DefaultTabController(
        length: 2, // Số lượng tab
        child: Column(
          children: [
            TabBar(
              labelColor: COLOR_GREEN, // Màu chữ của tab được chọn
              unselectedLabelColor: Colors.black,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2, color: Colors.green),
                insets: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
              ),

              tabs: const [
                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Lịch cá nhân',
                    ),
                  ),
                ),

                Tab(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Lịch chia sẻ',
                    ),
                  ),
                ), // Tab thứ hai
              ],
              onTap: (index) {
                setState(() {
                  currentTabIndex = index;
                  showFab = currentTabIndex == 0;
                });
              },
            ),
            Expanded(
              child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 130),
                        child: Column(
                          children: [
                            ..._listOfDayEvents(_selectedDate!)
                                .map((myEvents) => InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                            transitionDuration: const Duration(
                                                milliseconds: 200),
                                            pageBuilder: (ctx, _, __) =>
                                                DetailCalendar(
                                                    dataCalendar: myEvents
                                                        .cast<String, Object>(),
                                                    dateEvent: _selectedDate
                                                        .toString()),
                                            transitionsBuilder:
                                                (_, animation, __, child) {
                                              return SlideTransition(
                                                position: Tween<Offset>(
                                                  begin: const Offset(1.0, 0.0),
                                                  end: Offset.zero,
                                                ).animate(animation),
                                                child: child,
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: ItemCalendar(
                                          dataCalendar:
                                              myEvents.cast<String, Object>(),
                                          dateEvent: _selectedDate.toString()),
                                    )),
                          ],
                        ),
                      ),
                    ),
                    SingleChildScrollView(
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 130),
                        child: Column(
                          children: [
                            ..._listOfDayEvents(_selectedDate!).map(
                                (myEvents) => ItemCalendar(
                                    dataCalendar:
                                        myEvents.cast<String, Object>(),
                                    dateEvent: _selectedDate.toString())),
                          ],
                        ),
                      ),
                    ),
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
