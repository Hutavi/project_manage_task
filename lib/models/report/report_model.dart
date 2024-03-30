// import '../upload_file/PickedFileData.dart';

import '../upload_file/PickedFileData.dart';
import 'item_task_report.dart';

class Report {
  String? nameReport;
  String? timeType;
  String? description;

  List<String> assignment = [];
  List<ItemTaskReport> taskListReport = [];
  List<PickedFileData> PickedFileDatas = [];

  Report();

  bool checkNullValue() {
    return (timeType != null && timeType!.isNotEmpty) ||
        (nameReport != null && nameReport!.isNotEmpty) ||
        assignment.isNotEmpty ||
        taskListReport.isNotEmpty;
  }
}
