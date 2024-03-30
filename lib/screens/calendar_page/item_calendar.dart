import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/constants/image_assets.dart';
import 'package:management_app/widgets/text_custom.dart';

class ItemCalendar extends StatefulWidget {
  const ItemCalendar(
      {super.key, required this.dataCalendar, required this.dateEvent});
  final Map<String, Object> dataCalendar;
  final String dateEvent;

  @override
  State<ItemCalendar> createState() => _ItemCalendarState();
}

class _ItemCalendarState extends State<ItemCalendar> {
  @override
  Widget build(BuildContext context) {
    var assignedList =
        widget.dataCalendar['assigned'] as List<Map<String, dynamic>>;
    var names = assignedList.map((entry) => entry['name']).toList();
    var assignedString = names.join(", ");

    return Container(
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8.0),
      decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: COLOR_WHITE,
          boxShadow: [
            BoxShadow(
                color: COLOR_GREEN_SHADOW, blurRadius: 20, offset: Offset(5, 2))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 15.0,
                    height: 15.0,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        width: 5.0,
                        color: COLOR_GREEN,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextCustom(
                        text: widget.dataCalendar['dateEvent'].toString(),
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Column(
                  children: [
                    TextCustom(
                        text: widget.dataCalendar['startTime'].toString(),
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 5.0),
                child: Column(
                  children: [
                    TextCustom(
                        text: "-",
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600)
                  ],
                ),
              ),
              Column(
                children: [
                  TextCustom(
                      text: widget.dataCalendar['endTime'].toString(),
                      color: COLOR_TEXT_MAIN,
                      fontSize: FONT_SIZE_NORMAL,
                      fontWeight: FontWeight.w600)
                ],
              )
            ],
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            child: TextCustom(
                text: widget.dataCalendar['title'].toString(),
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_SMALL_TITLE,
                fontWeight: FontWeight.w600),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 10.0),
                child: Column(
                  children: [
                    Image.asset(
                      IC_PERSON,
                      width: 25,
                      height: 25,
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    width: 250, // Replace 200 with your desired width
                    child: Text(
                      assignedString,
                      style: const TextStyle(
                        color: COLOR_TEXT_MAIN,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
