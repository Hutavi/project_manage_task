import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class DataCalendarModel {
  String? id;
  String? subject;
  String? date_start;
  String? due_date;
  String? time_start;
  String? time_end;
  String? eventstatus;
  String? assigned_user_id;
  bool? visibility;
  String? visibilityTemp;
  String? main_owner_name;
  String? description;
  List<dynamic>? assigned_owners;

  DataCalendarModel({
    this.id,
    this.subject,
    this.date_start,
    this.due_date,
    this.time_start,
    this.time_end,
    this.eventstatus,
    this.assigned_user_id,
    this.visibility,
    this.visibilityTemp,
    this.main_owner_name,
    this.description,
    this.assigned_owners,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'subject': subject,
      'date_start': date_start,
      'due_date': due_date,
      'time_start': time_start,
      'time_end': time_end,
      'eventstatus': eventstatus,
      'assigned_user_id': assigned_user_id,
      'visibility': visibility,
      'visibilityTemp': visibilityTemp,
      'main_owner_name': main_owner_name,
      'description': description,
      'assigned_owners': assigned_owners,
    };
  }

  factory DataCalendarModel.fromMap(Map<String, dynamic> map) {
    return DataCalendarModel(
      id: map['id'] != null ? map['id'] as String : null,
      subject: map['subject'] != null ? map['subject'] as String : null,
      date_start:
          map['date_start'] != null ? map['date_start'] as String : null,
      due_date: map['due_date'] != null ? map['due_date'] as String : null,
      time_start:
          map['time_start'] != null ? map['time_start'] as String : null,
      time_end: map['time_end'] != null ? map['time_end'] as String : null,
      eventstatus:
          map['eventstatus'] != null ? map['eventstatus'] as String : null,
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      visibility: map['visibility'] != null ? map['visibility'] as bool : null,
      visibilityTemp: map['visibilityTemp'] != null
          ? map['visibilityTemp'] as String
          : null,
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      assigned_owners: map['assigned_owners'] != null
          ? map['assigned_owners'] as List<dynamic>
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory DataCalendarModel.fromJson(String source) =>
      DataCalendarModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DataCalendarModel(id: $id, subject: $subject, date_start: $date_start, due_date: $due_date, time_start: $time_start, time_end: $time_end, eventstatus: $eventstatus, assigned_user_id: $assigned_user_id, visibility: $visibility, visibilityTemp: $visibilityTemp, main_owner_name: $main_owner_name, description: $description, assigned_owners: $assigned_owners)';
  }
}
