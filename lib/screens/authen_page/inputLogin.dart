import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/navigation/navigation.dart';

class InputField extends StatefulWidget {
  const InputField({super.key});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final _formKeyLogin = GlobalKey<FormState>();

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
                return 'Vui lòng nhập số điện thoại hoặc email';
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
              setState(() {});
            },
          ),
          const SizedBox(
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKeyLogin.currentState!.validate()) {
                // If the form is valid, display a Snackbar.
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NavigationBottom()));
              }
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
              backgroundColor: COLOR_GREEN,
            ),
            child: const Text('Đăng nhập'),
          ),
        ],
      ),
    );
  }
}
