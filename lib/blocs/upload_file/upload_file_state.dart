import 'package:equatable/equatable.dart';

import '../../models/upload_file/PickedFileData.dart';

class UploadFileState extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UploadFileSuccess extends UploadFileState {
  final List<PickedFileData> pickedFileDatas;

  UploadFileSuccess({this.pickedFileDatas = const []});

  @override
  List<Object?> get props => [pickedFileDatas];
}
 class UploadFileNoData extends UploadFileState {}
class UploadFileFailure extends UploadFileState {}

class UploadFileLoading extends UploadFileState {
}

class UploadFileInitial extends UploadFileState {}
