import '../upload_file/PickedFileData.dart';

class LeavingModel {
  String? fromDate;
  String? toDate;
  String? selectedTypeLeaving;
  String? selectedTypeDateTime;
  String? selectedTypeTime;
  String? title;
  String? description;

  List<String> assignment = [];
  List<PickedFileData> PickedFileDatas = [];

  LeavingModel({
    this.fromDate,
    this.toDate,
    this.selectedTypeLeaving,
    this.selectedTypeDateTime,
    this.selectedTypeTime,
    this.title,
    this.description,
  });

  @override
  String toString() {
    return 'LeavingModel(fromDate: $fromDate, toDate: $toDate, selectedTypeLeaving: $selectedTypeLeaving, selectedTypeDateTime: $selectedTypeDateTime, selectedTypeTime: $selectedTypeTime, title: $title, description: $description, assignment: $assignment, PickedFileDatas: $PickedFileDatas)';
  }
}
