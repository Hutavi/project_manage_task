import 'package:flutter/material.dart';
import 'package:management_app/constants/color.dart';

class ButtonSwitch extends StatefulWidget {
  final void Function(bool checkStatus) propStatus;
  const ButtonSwitch({super.key, required this.propStatus});

  @override
  State<ButtonSwitch> createState() => _ButtonSwitchState();
}

class _ButtonSwitchState extends State<ButtonSwitch> {
  bool checkStatus = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: checkStatus,
      activeColor: COLOR_GREEN,
      onChanged: (bool value) {
        setState(() {
          widget.propStatus(value);
          checkStatus = value;
        });
      },
    );
  }
}
