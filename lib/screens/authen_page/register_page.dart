//fst
import 'package:flutter/material.dart';
import 'package:management_app/screens/authen_page/inputRegister.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: const Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
          child: SingleChildScrollView(
            child: Column(
              children: [SizedBox(height: 50), InputRegister()],
            ),
          ),
        ),
      ),
    );
  }
}
