import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constants/color.dart';
import '../../constants/font.dart';
import '../../widgets/text_custom.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double setWidthAvt = MediaQuery.of(context).size.width * 0.5 - 50;
    double containerHeight = screenHeight * 1 / 2.1;
    double containeItem = screenHeight * 1 / 14;
    return Scaffold(
        backgroundColor: COLOR_WHITE,
        appBar: AppBar(
          backgroundColor: COLOR_WHITE,
          elevation: 0,
          title: const TextCustom(
              text: 'Thông tin tài khoản',
              color: COLOR_BLACK,
              fontSize: FONT_SIZE_NORMAL_TITLE,
              fontWeight: FontWeight.w600),
          centerTitle: true,
          automaticallyImplyLeading: true,
          iconTheme: const IconThemeData(color: COLOR_BLACK),
          actionsIconTheme: const IconThemeData(color: COLOR_DELAY),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 10,
            ),
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: containerHeight,
                  margin: const EdgeInsets.fromLTRB(15, 55, 15, 0),
                  padding: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    color: COLOR_WHITE,
                    border: Border.all(width: 1, color: COLOR_GRAY),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(70, 185, 185, 185)
                            .withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(
                            0, 1), // Điều chỉnh vị trí của boxShadow
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextCustom(
                                text: "Nguyễn Quang Hải",
                                color: COLOR_BLACK,
                                fontSize: FONT_SIZE_NORMAL_TITLE,
                                fontWeight: FontWeight.w700)
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextCustom(
                                text: "Sale Manager",
                                color: COLOR_TEXT_MAIN,
                                fontSize: FONT_SIZE_SMALL_TITLE,
                                fontWeight: FontWeight.w500)
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Tên người dùng:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "hai.nguyen",
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: COLOR_TEXT_MAIN,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Số điện thoại:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "032 456 7897",
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: COLOR_TEXT_MAIN,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Email:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "nqhai@gmail.com",
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: COLOR_TEXT_MAIN,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Giới tính:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Nam",
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: COLOR_TEXT_MAIN,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Ngày sinh:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "20/11/2000",
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            )
                          ],
                        ),
                        const Divider(
                          color: COLOR_TEXT_MAIN,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Expanded(
                              flex: 2,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextCustom(
                                      text: "Địa chỉ:",
                                      color: COLOR_TEXT_MAIN,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500)
                                ],
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "13 Đường 37, KĐC Vạn Phúc dfgdfg dg d",
                                    style: GoogleFonts.montserrat(
                                      color: COLOR_BLACK,
                                      fontSize: FONT_SIZE_TEXT_BUTTON,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 3, // Giới hạn số dòng là 3
                                    overflow: TextOverflow
                                        .ellipsis, // Xác định hiển thị dấu "..." khi văn bản vượt quá số dòng đã giới hạn
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.center,
                  child: CircleAvatar(
                    radius: 45,
                    backgroundImage:
                        AssetImage('lib/assets/images/intro/avt.jpeg'),
                  ),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              height: containeItem,
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              decoration: BoxDecoration(
                color: COLOR_WHITE,
                border: Border.all(width: 1, color: COLOR_GRAY),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(70, 185, 185, 185)
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset(
                    'lib/assets/images/intro/lock.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Đổi mật khẩu",
                    style: TextStyle(
                      color: COLOR_BLACK,
                      fontSize: FONT_SIZE_SMALL_TITLE,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              height: containeItem,
              margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
              decoration: BoxDecoration(
                color: COLOR_WHITE,
                border: Border.all(width: 1, color: COLOR_GRAY),
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(70, 185, 185, 185)
                        .withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const SizedBox(width: 15),
                  Image.asset(
                    'lib/assets/images/intro/logout.png',
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(width: 20),
                  const Text(
                    "Đăng xuất",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: FONT_SIZE_SMALL_TITLE,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
