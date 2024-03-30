import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/screens/calendar_page/home_lock/hours.dart';
import 'package:management_app/screens/calendar_page/home_lock/minutes.dart';

class HomeLock extends StatefulWidget {
  const HomeLock({
    super.key,
    required this.popDialog,
    required this.propTime,
  });
  final void Function() popDialog;
  final void Function(int currentMinutes, int currentHours) propTime;

  @override
  State<HomeLock> createState() => _HomeLockState();
}

class _HomeLockState extends State<HomeLock> {
  late FixedExtentScrollController _controller;
  int currentMinutes = 0;
  int currentHours = 0;
  @override
  void initState() {
    super.initState();
    _controller = FixedExtentScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Chọn thời gian',
        textAlign: TextAlign.center,
      ),
      content: Container(
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 70,
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (value) {
                        setState(() {
                          currentHours = value;
                        });
                      },
                      controller: _controller,
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 24,
                        builder: (context, index) {
                          return MyHours(
                            hours: index,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                    child: Text(
                      ":",
                      style: GoogleFonts.montserrat(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: COLOR_GREEN),
                    ),
                  ),
                  SizedBox(
                    width: 70,
                    child: ListWheelScrollView.useDelegate(
                      onSelectedItemChanged: (value) {
                        setState(() {
                          currentMinutes = value;
                        });
                      },
                      itemExtent: 50,
                      perspective: 0.005,
                      diameterRatio: 1.2,
                      physics: const FixedExtentScrollPhysics(),
                      childDelegate: ListWheelChildBuilderDelegate(
                        childCount: 60,
                        builder: (context, index) {
                          return MyMinutes(
                            mins: index,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              child: const Text('Xong'),
              onPressed: () {
                widget.popDialog();
                widget.propTime(currentHours, currentMinutes);
              },
            )
          ],
        ),
      ),
    );
  }
}
