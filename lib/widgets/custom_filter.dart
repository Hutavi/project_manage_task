import 'package:flutter/material.dart';

class CustomFilter extends StatelessWidget {
  const CustomFilter({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    Widget filterWidget;
    switch (name) {
      case 'widget1':
        filterWidget = Widget1();
        break;
      case 'widget2':
        filterWidget = Widget2();
        break;
      case 'widget3':
        filterWidget = Widget3();
        break;
      default:
        filterWidget =
            Container(); // Widget mặc định nếu không có tên tương ứng
        break;
    }
    return Scaffold();
  }
}

class Widget1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Widget 1'),
    );
  }
}

class Widget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Widget 2'),
    );
  }
}

class Widget3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Widget 3'),
    );
  }
}
