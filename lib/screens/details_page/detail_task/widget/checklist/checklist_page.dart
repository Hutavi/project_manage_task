import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../../constants/color.dart';
import '../../../../../constants/font.dart';
import '../../../../../services/dio_client.dart';
import '../../../../../widgets/text_custom.dart';

class CheckList extends StatefulWidget {
  const CheckList({required this.checkListTask, required this.projectTaskId});
  final List<Map<String, String>> checkListTask;
  final String projectTaskId;

  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  final TextEditingController _textFieldController = TextEditingController();

  void editChecklistData(var data) async {
    try {
      final dioClient = DioClient();

      final response = await dioClient.request(
        '/apis/OpenAPI/update',
        queryParameters: {
          'module': 'ProjectTask',
          'record': widget.projectTaskId,
        },
        options: Options(method: 'POST'),
        data: data,
      );

      if (response.statusCode == 200) {
        print('success 3!');
        // Xử lý dữ liệu nhận được từ response.data
      } else {
        // Xử lý lỗi nếu có
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      // Xử lý lỗi nếu có
      print('Error: $e');
    }
  }

  void _addTodoItem(String title) {
    setState(() {
      widget.checkListTask.insert(0, {
        'status': '0',
        'name': title,
      });
      var data = json.encode({
        "data": {"checklist": widget.checkListTask.toString()}
      });
      editChecklistData(data);
    });
    _textFieldController.clear();
  }

  void _toggleTodoItem(bool? value, int index) {
    if (value != null) {
      setState(() {
        widget.checkListTask[index]['status'] = value ? '1' : '0';
        var data = json.encode({
          "data": {"checklist": widget.checkListTask.toString()}
        });
        editChecklistData(data);
      });
    }
  }

  void _removeTodoItem(int index) {
    setState(() {
      widget.checkListTask.removeAt(index);
      var data = json.encode({
        "data": {"checklist": widget.checkListTask.toString()}
      });
      editChecklistData(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const TextCustom(
            text: "Công việc liên quan",
            color: COLOR_BLACK,
            fontSize: FONT_SIZE_NORMAL,
            fontWeight: FontWeight.w700,
          ),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      contentTextStyle: const TextStyle(
                          fontSize: FONT_SIZE_NORMAL,
                          fontWeight: FontWeight.w600,
                          color: COLOR_TEXT_MAIN),
                      title: const TextCustom(
                        text: "Thêm công việc",
                        color: COLOR_BLACK,
                        fontSize: FONT_SIZE_NORMAL,
                        fontWeight: FontWeight.w700,
                      ),
                      content: TextField(
                        controller: _textFieldController,
                        decoration: const InputDecoration(
                            hintText: "Nhập tên công việc"),
                      ),
                      actions: <Widget>[
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  COLOR_GREEN)),
                          child: const TextCustom(
                            text: "Huỷ",
                            color: COLOR_WHITE,
                            fontSize: FONT_SIZE_NORMAL,
                            fontWeight: FontWeight.w700,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  COLOR_GREEN)),
                          child: const TextCustom(
                            text: "Thêm",
                            color: COLOR_WHITE,
                            fontSize: FONT_SIZE_NORMAL,
                            fontWeight: FontWeight.w700,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            _addTodoItem(_textFieldController.text);
                          },
                        ),
                      ],
                    );
                  });
            },
            child: const Icon(
              Icons.add,
              color: COLOR_BLACK,
              size: 30,
            ),
          )
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      Expanded(
        child: ListView.builder(
          itemCount: widget.checkListTask.length,
          itemBuilder: (context, index) {
            return CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: COLOR_GREEN,
              title: Text(
                widget.checkListTask[index]['name']!,
                style: widget.checkListTask[index]['status'] == '1'
                    ? const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey)
                    : null,
              ),
              value: widget.checkListTask[index]['status'] == '1',
              onChanged: (value) => _toggleTodoItem(value, index),
              secondary: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeTodoItem(index),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
