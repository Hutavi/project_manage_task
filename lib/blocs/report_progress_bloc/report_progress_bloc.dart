import 'package:bloc/bloc.dart';
import 'package:management_app/blocs/report_progress_bloc/report_progress_event.dart';
import 'package:management_app/blocs/report_progress_bloc/report_progress_state.dart';

class ReportProgressBloc extends Bloc<ReportProgressEvent, ReportProgressState> {
  ReportProgressBloc() : super(ReportProgressInitial()) {}
}
