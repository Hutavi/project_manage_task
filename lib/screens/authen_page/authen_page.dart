import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/screens/authen_page/login_page.dart';
import 'package:management_app/screens/authen_page/register_page.dart';

class AuthenPage extends StatefulWidget {
  const AuthenPage({super.key});

  @override
  State<AuthenPage> createState() => _AuthenPageState();
}

class _AuthenPageState extends State<AuthenPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Column(
            children: [
              // Image.asset('lib/assets/images/intro/login.png'),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 50, 30, 20),
                child: Image.asset(
                  'lib/assets/images/intro/login.png',
                  fit: BoxFit.contain,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 150),
                child: TabBar(
                  labelColor: COLOR_GREEN, // Màu chữ của tab được chọn
                  unselectedLabelColor:
                      Colors.black, // Màu chữ của tab không được chọn
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.green), // Thiết lập đường line và màu sắc
                    insets: EdgeInsets.symmetric(
                        vertical: 7,
                        horizontal: 16), // Thiết lập khoảng cách với chữ
                  ),
                  tabs: [
                    Tab(
                      child: Text(
                        'Đăng nhập',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), // Tab đăng nhập
                    Tab(
                      child: Text(
                        'Đăng kí',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ), // Tab đăng kí
                  ],
                ),
              ),
              const Expanded(
                  child: TabBarView(children: [LoginPage(), RegisterPage()]))
            ],
          ),
        ),
      ),
    );
  }
}
