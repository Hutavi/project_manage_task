import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/models/notification/notification_item_model.dart';
import 'package:management_app/screens/notification_page/notification_item.dart';
import 'package:management_app/services/dio_client.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../data/data.dart';

class ActivityTab extends StatefulWidget {
  const ActivityTab({Key? key}) : super(key: key);

  @override
  State<ActivityTab> createState() => _ActivityTabState();
}

class _ActivityTabState extends State<ActivityTab> {
  List<NotificationItemModel> listNotification = [];
  List<NotificationItemModel> listNotificationComing = [];
  List<Map<String, Object>> notificationActivityList = [];
  @override
  void initState() {
    super.initState();
    fetchDataOverDue();
    fetchDataComing();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchDataOverDue() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        "/apis/CloudworkApi.php",
        queryParameters: {
          "action": "getNotificationActivity",
          "Params": {
            "type": "activity",
            "sub_type": "overdue",
            "paging": {"offset": 0}
          }
        },
        options: Options(method: "GET"),
      );
      if (response.statusCode == 200) {
        final parsed = json.decode(response.data!);

        if (parsed["success"] == "1") {
          // print(parsed["counts"]["activity_detail"]["overdue"]);

          listNotification.clear();
          for (var entry in parsed["entry_list"]) {
            NotificationItemModel notificationItemModel =
                NotificationItemModel.fromMap(entry);
            // print(notificationItemModel);
            listNotification.add(notificationItemModel);
          }
          notificationActivityList.add({
            'state': 'Trễ hạn',
            'data': listNotification,
            'count': parsed["counts"]["activity_detail"]["overdue"],
          });
          // print(notificationActivityList[0]['data']);
          setState(() {});
        }
      }
    } catch (e) {}
  }

  void fetchDataComing() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        "/apis/CloudworkApi.php",
        queryParameters: {
          "action": "getNotificationActivity",
          "Params": {
            "type": "activity",
            "sub_type": "coming",
            "paging": {"offset": 0}
          }
        },
        options: Options(method: "GET"),
      );
      // print("Call API 2");
      if (response.statusCode == 200) {
        final parsed = json.decode(response.data!);

        if (parsed["success"] == "1") {
          listNotificationComing.clear();
          for (var entry in parsed["entry_list"]) {
            NotificationItemModel notificationItemModel =
                NotificationItemModel.fromMap(entry);
            // print(notificationItemModel);
            listNotificationComing.add(notificationItemModel);
          }
          notificationActivityList.add({
            'state': 'Sắp đến hạn',
            'data': listNotificationComing,
            'count': parsed["counts"]["activity_detail"]["coming"]
          });
          // print(parsed["counts"]["activity_detail"]["coming"]);

          // print(notificationActivityList[0]['data']);
          setState(() {});
        }
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: ListView.builder(
        itemCount: notificationActivityList.length,
        itemBuilder: (context, i) {
          // Icon icon = const Icon(Icons.keyboard_arrow_down_rounded);
          return ExpansionTile(
            // onExpansionChanged: (value) {
            //   if (value) {
            //     icon = const Icon(Icons.keyboard_arrow_up_rounded);
            //   } else
            //     icon = const Icon(Icons.keyboard_arrow_down_rounded);
            // },
            // trailing: Row(
            //   mainAxisSize: MainAxisSize.min,
            //   children: [
            //     const Icon(Icons.keyboard_arrow_down_rounded),
            //     Text(
            //       'Mở rộng',
            //       style: GoogleFonts.montserrat(
            //         color: COLOR_TEXT_MAIN,
            //         fontSize: FONT_SIZE_NORMAL,
            //         fontWeight: FontWeight.w600,
            //       ),
            //     ),
            //   ],
            // ),
            iconColor: COLOR_TEXT_MAIN,
            collapsedIconColor: COLOR_TEXT_MAIN,
            initiallyExpanded: i == 0,
            title: Row(
              children: [
                Text(
                  notificationActivityList[i]['state'] as String,
                  style: GoogleFonts.montserrat(
                    color: COLOR_BLACK,
                    fontSize: FONT_SIZE_BIG,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: COLOR_LATE,
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: TextCustom(
                    // text: '0',
                    text: notificationActivityList[i]['count'].toString(),
                    color: COLOR_WHITE,
                    fontSize: FONT_SIZE_NORMAL,
                    fontWeight: FontWeight.w700,
                  ),
                )
              ],
            ),
            children: <Widget>[
              Column(
                children: _buildExpandableContent(notificationActivityList[i]),
              ),
            ],
          );
        },
      ),
    );
  }

  _buildExpandableContent(Map<String, Object> value) {
    // print('1111111');
    // print(value);
    List<Widget> columnContent = [];

    List<NotificationItemModel> data =
        value['data'] as List<NotificationItemModel>;
    data.forEach((item) {
      // if (item['seen'] == 'true') {}
      columnContent.add(NotificationItem(data: item));
    });

    return columnContent;
  }

  // int getNewNotification(Map<String, Object> dataObject) {
  //   List<dynamic> dataList = dataObject['data'] as List<dynamic>;
  //   int count = dataList.where((item) => item['seen'] == 'false').length;
  //   return count;
  // }
}
