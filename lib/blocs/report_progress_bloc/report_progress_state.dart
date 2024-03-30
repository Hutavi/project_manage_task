import 'package:equatable/equatable.dart';

class ReportProgressState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class ReportProgressInitial extends ReportProgressState {}
class ReportProgressLoading extends ReportProgressState {}
class ReportProgressSuccess extends ReportProgressState {}
class ReportProgressFailure extends ReportProgressState {}
class ReportProgressNoData extends ReportProgressState {}
class ReportProgressNoInternet extends ReportProgressState {}
class ReportProgressGetAll extends ReportProgressState {}