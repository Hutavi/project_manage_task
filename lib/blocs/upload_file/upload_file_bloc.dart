import 'package:bloc/bloc.dart';
import 'package:management_app/blocs/upload_file/upload_file_event.dart';
import 'package:management_app/blocs/upload_file/upload_file_state.dart';
import 'package:file_picker/file_picker.dart';

import '../../models/upload_file/PickedFileData.dart';

class UploadFileBloc extends Bloc<UploadEvent, UploadFileState> {
  List<PickedFileData> PickedFileDatas = [];
  UploadFileBloc() : super(UploadFileInitial()) {
    on<PressUploadButton>(uploadFile);
    on<PressDeleteButton>(deleteFile);
  }
  Future<void> deleteFile(
      PressDeleteButton event, Emitter<UploadFileState> emit) async {
    emit(UploadFileLoading());
    PickedFileDatas.removeAt(event.index);
    if (PickedFileDatas.isEmpty) {
      emit(UploadFileNoData());
    } else
      emit(UploadFileSuccess(pickedFileDatas: PickedFileDatas));
  }

  Future<void> uploadFile(
      PressUploadButton event, Emitter<UploadFileState> emit) async {
    emit(UploadFileLoading());
    //  await Future.delayed(Duration(seconds: 3));

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx'
      ],
    );

    if (result != null) {
      PickedFileDatas = result.files
          .map((e) => PickedFileData(
                name: e.name,
                bytes: e.bytes,
                size: e.size,
                extension: e.extension,
                path: e.path,
              ))
          .toList();

      // 3
      emit(UploadFileSuccess(pickedFileDatas: PickedFileDatas));
    } else {
      // User canceled the picker
      emit(UploadFileInitial());
    }
  }
}
