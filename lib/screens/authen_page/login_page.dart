import 'package:flutter/material.dart';
import 'package:management_app/screens/authen_page/inputLogin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Khi nhấn vào không gian trống xung quanh, unfocus các input field
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(children: [
              SizedBox(height: 50),
              InputField(),
            ]),
          ),
        ),
      ),
    );
  }
}
