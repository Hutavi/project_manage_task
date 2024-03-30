import 'package:flutter/material.dart';
import 'package:management_app/screens/task/task_view.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TaskView(),
    );
  }
}
