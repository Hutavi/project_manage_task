import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/screens/authen_page/authen_page.dart';
import 'package:status_alert/status_alert.dart';

class InputRegister extends StatefulWidget {
  const InputRegister({super.key});

  @override
  State<InputRegister> createState() => _InputRegisterState();
}

class _InputRegisterState extends State<InputRegister> {
  final _formKeyLogin = GlobalKey<FormState>();
  late String pass;
  late String confirmpass;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKeyLogin,
      child: Column(
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Tên đăng nhập',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: COLOR_GREEN),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Vui lòng nhập username';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Mật khẩu',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: COLOR_GREEN),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Vui lòng nhập mật khẩu';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                pass = value;
              });
            },
          ),
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Xác nhận mật khẩu',
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: COLOR_GREEN),
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Vui lòng xác nhận mật khẩu';
              }
              if (pass != confirmpass) {
                return 'Xác nhận mật khẩu không trùng khớp';
              }
              return null;
            },
            onChanged: (value) {
              setState(() {
                confirmpass = value;
              });
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKeyLogin.currentState!.validate() &&
                  pass == confirmpass) {
                StatusAlert.show(
                  context,
                  duration: const Duration(seconds: 1),
                  title: 'Thành công',
                  configuration: const IconConfiguration(icon: Icons.done),
                  maxWidth: 200,
                );
                // If the form is valid, display a Snackbar.
                Future.delayed(const Duration(seconds: 1), () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AuthenPage()));
                });
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: COLOR_GREEN,
            ),
            child: const Text('Đăng ký'),
          ),
        ],
      ),
    );
  }
}
