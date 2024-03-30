import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_app/screens/details_page/detail_task/detail_task_page.dart';

import '../../../blocs/report_progress_bloc/report_progress_bloc.dart';

class DetailTaskView extends StatelessWidget {
  final dynamic data;
  const DetailTaskView({super.key,required this.data});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => ReportProgressBloc(),
        child: DetailTaskPage(data: data,),
      ),
    );
  }
}
