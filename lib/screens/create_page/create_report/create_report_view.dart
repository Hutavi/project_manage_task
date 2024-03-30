import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_app/blocs/upload_file/upload_file_bloc.dart';

import 'create_report.dart';

class CreateReportView extends StatelessWidget {
  const CreateReportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => UploadFileBloc(),
        child: const CreateReportPage(),
      ),
    );
  }
}
