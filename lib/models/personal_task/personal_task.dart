// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class PersonalTaskModel {
  String? subject;
  String? assigned_user_id;
  String? date_start;
  String? time_start;
  String? due_date;
  String? taskstatus;
  String? eventstatus;
  String? activitytype;
  String? duration_hours;
  String? duration_minutes;
  String? activityid;
  String? taskpriority;

  PersonalTaskModel({
    this.subject,
    this.assigned_user_id,
    this.date_start,
    this.time_start,
    this.due_date,
    this.taskstatus,
    this.eventstatus,
    this.activitytype,
    this.duration_hours,
    this.duration_minutes,
    this.activityid,
    this.taskpriority,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'subject': subject,
      'assigned_user_id': assigned_user_id,
      'date_start': date_start,
      'time_start': time_start,
      'due_date': due_date,
      'taskstatus': taskstatus,
      'eventstatus': eventstatus,
      'activitytype': activitytype,
      'duration_hours': duration_hours,
      'duration_minutes': duration_minutes,
      'activityid': activityid,
      'taskpriority': taskpriority,
    };
  }

  factory PersonalTaskModel.fromMap(Map<String, dynamic> map) {
    return PersonalTaskModel(
      subject: map['subject'] != null ? map['subject'] as String : null,
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      date_start:
          map['date_start'] != null ? map['date_start'] as String : null,
      time_start:
          map['time_start'] != null ? map['time_start'] as String : null,
      due_date: map['due_date'] != null ? map['due_date'] as String : null,
      taskstatus:
          map['taskstatus'] != null ? map['taskstatus'] as String : null,
      eventstatus:
          map['eventstatus'] != null ? map['eventstatus'] as String : null,
      activitytype:
          map['activitytype'] != null ? map['activitytype'] as String : null,
      duration_hours: map['duration_hours'] != null
          ? map['duration_hours'] as String
          : null,
      duration_minutes: map['duration_minutes'] != null
          ? map['duration_minutes'] as String
          : null,
      activityid:
          map['activityid'] != null ? map['activityid'] as String : null,
      taskpriority:
          map['taskpriority'] != null ? map['taskpriority'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalTaskModel.fromJson(String source) =>
      PersonalTaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PersonalTaskModel(subject: $subject, assigned_user_id: $assigned_user_id, date_start: $date_start, time_start: $time_start, due_date: $due_date, taskstatus: $taskstatus, eventstatus: $eventstatus, activitytype: $activitytype, duration_hours: $duration_hours, duration_minutes: $duration_minutes, activityid: $activityid, taskpriority: $taskpriority)';
  }
}
