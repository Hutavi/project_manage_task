// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DetailCalendarData {
  String? id;
  String? label;
  String? subject;
  String? date_start;
  String? due_date;
  String? time_start;
  String? time_end;
  String? visibility;
  bool? visibilityTemp;
  String? eventstatus;
  String? assigned_user_id;
  String? taskstatus;
  String? description;
  String? main_owner_name;
  List<dynamic>? assigned_owners;

  DetailCalendarData({
    this.id,
    this.label,
    this.subject,
    this.date_start,
    this.due_date,
    this.time_start,
    this.time_end,
    this.visibility,
    this.visibilityTemp,
    this.eventstatus,
    this.assigned_user_id,
    this.taskstatus,
    this.description,
    this.main_owner_name,
    this.assigned_owners,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'label': label,
      'subject': subject,
      'date_start': date_start,
      'due_date': due_date,
      'time_start': time_start,
      'time_end': time_end,
      'visibility': visibility,
      'visibilityTemp': visibilityTemp,
      'eventstatus': eventstatus,
      'assigned_user_id': assigned_user_id,
      'taskstatus': taskstatus,
      'description': description,
      'main_owner_name': main_owner_name,
      'assigned_owners': assigned_owners,
    };
  }

  factory DetailCalendarData.fromMap(Map<String, dynamic> map) {
    return DetailCalendarData(
      id: map['id'] != null ? map['id'] as String : null,
      label: map['label'] != null ? map['label'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      date_start:
          map['date_start'] != null ? map['date_start'] as String : null,
      due_date: map['due_date'] != null ? map['due_date'] as String : null,
      time_start:
          map['time_start'] != null ? map['time_start'] as String : null,
      time_end: map['time_end'] != null ? map['time_end'] as String : null,
      visibility:
          map['visibility'] != null ? map['visibility'] as String : null,
      visibilityTemp:
          map['visibilityTemp'] != null ? map['visibilityTemp'] as bool : null,
      eventstatus:
          map['eventstatus'] != null ? map['eventstatus'] as String : null,
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      taskstatus:
          map['taskstatus'] != null ? map['taskstatus'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : null,
      assigned_owners: map['assigned_owners'] != null
          ? map['assigned_owners'] as List<dynamic>
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DetailCalendarData.fromJson(String source) =>
      DetailCalendarData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DetailCalendarData(id: $id, label: $label, subject: $subject, date_start: $date_start, due_date: $due_date, time_start: $time_start, time_end: $time_end, visibility: $visibility, visibilityTemp: $visibilityTemp, eventstatus: $eventstatus, assigned_user_id: $assigned_user_id, taskstatus: $taskstatus, description: $description, main_owner_name: $main_owner_name, assigned_owners: $assigned_owners)';
  }
}
