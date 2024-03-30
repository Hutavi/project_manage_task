import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/data/data.dart';
import 'package:management_app/models/leaving/leving_model_list.dart';
import 'package:management_app/services/dio_client.dart';

import '../../../constants/color.dart';
import '../../../constants/font.dart';

import '../../../widgets/floating_add_button.dart';
import '../../../widgets/search_bar.dart';
import 'leaving_item.dart';

class LeavingListPage extends StatefulWidget {
  const LeavingListPage({super.key});

  @override
  State<LeavingListPage> createState() => _LeavingListPageState();
}

class _LeavingListPageState extends State<LeavingListPage> {
  List<LeavingModelList> listLeaving = [];

  void fetchData() async {
    try {
      final dioClient = DioClient();
      final response = await dioClient.request(
        '/apis/OpenAPI/list',
        queryParameters: {'module': 'CPLeaving'},
        options: Options(method: 'GET'),
      );

      if (response.statusCode == 200) {
        print("chạy ok");
        final parsed = json.decode(response.data!);
        List<dynamic> entryList = parsed['entry_list'];
        for (var entry in entryList) {
          listLeaving.add(LeavingModelList.fromMap(entry));
        }
        setState(() {});
        // print(listLeaving);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          shadowColor: Colors.transparent,
          backgroundColor: COLOR_WHITE,
          iconTheme: const IconThemeData(color: COLOR_TEXT_MAIN),
          title: Text(
            'Danh sách nghỉ phép',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w600,
              fontSize: FONT_SIZE_SMALL_TITLE,
              color: COLOR_TEXT_MAIN,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 0),
          child: Column(
            children: [
              CustomSearchBar(
                showFilter: () {},
                placeHolder: 'Tên nghỉ phép...',
                onChanged: (String value) {
                  print(value);
                },
              ),
              if (listLeaving.isNotEmpty)
                Expanded(
                    child: ListView.builder(
                  itemCount: listLeaving.length,
                  itemBuilder: (context, index) {
                    print(listLeaving[index]);
                    return LeavingItem(
                      data: listLeaving[index],
                    );
                  },
                ))
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: InkWell(
          onTap: () {
            Navigator.pushNamed(context, '/createLeaving');
          },
          child: const FloatingAddButton(
            title: 'Thêm nghỉ phép',
            width: 180,
            marginBottom: 10,
          ),
        ));
  }
}
