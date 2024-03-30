import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/models/notification/notification_item_model.dart';
import 'package:management_app/screens/notification_page/notification_item.dart';
import 'package:management_app/services/dio_client.dart';
import 'package:management_app/widgets/text_custom.dart';

class UpdateTab extends StatefulWidget {
  const UpdateTab({Key? key}) : super(key: key);

  @override
  _UpdateTabState createState() => _UpdateTabState();
}

class _UpdateTabState extends State<UpdateTab> {
  List<NotificationItemModel> listNotification = [];
  // List<Map<String, Object>> notificationActivityList = [];

  @override
  void initState() {
    super.initState();
    fetchDataNoti();
  }

  void fetchDataNoti() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        "/apis/CloudworkApi.php",
        queryParameters: {
          "action": "getNotificationActivity",
          "Params": {
            "type": "notify",
            "sub_type": "update",
            "paging": {"offset": 0}
          }
        },
        options: Options(method: "GET"),
      );

      if (response.statusCode == 200) {
        final parsed = json.decode(response.data!);

        if (parsed["success"] == "1") {
          // print(listNotification.length);
          // listNotification.clear();
          for (var entry in parsed["entry_list"]!) {
            NotificationItemModel notificationItemModel =
                NotificationItemModel.fromMap(entry);
            listNotification.add(notificationItemModel);
          }
        }
        setState(() {});
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.remove_red_eye_sharp),
              SizedBox(
                width: 10,
              ),
              TextCustom(
                  text: 'Đánh dấu tất cả đã đọc',
                  color: COLOR_TEXT_MAIN,
                  fontSize: FONT_SIZE_TEXT_BUTTON,
                  fontWeight: FontWeight.w600),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: listNotification.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    InkWell(
                      onTap: () {},
                      child: NotificationItem(
                        data: listNotification[index],
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
