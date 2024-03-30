class ItemTaskReport {
  String? taskName;
  String? project;
  String? startDay;
  String? dueDay;
  String? priority;
  String? dayLefts;
  String? state;

  ItemTaskReport();

  bool checkNullValue() {
    return (taskName != null && taskName!.isNotEmpty) ||
        (project != null && project!.isNotEmpty) ||
        (startDay != null && startDay!.isNotEmpty) ||
        (dueDay != null && dueDay!.isNotEmpty) ||
        (priority != null && priority!.isNotEmpty) ||
        (dayLefts != null && dayLefts!.isNotEmpty) ||
        (state != null && state!.isNotEmpty);
  }
}
