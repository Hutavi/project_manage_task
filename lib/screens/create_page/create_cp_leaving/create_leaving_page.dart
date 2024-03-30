import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:management_app/blocs/upload_file/upload_file_bloc.dart';

import 'create_leaving_view.dart';

class CreateLeavingPage extends StatelessWidget {
  const CreateLeavingPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => UploadFileBloc(),
        child: const CreateLeavingView(),
      ),
    );
  }
}
