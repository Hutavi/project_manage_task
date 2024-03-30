import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class CategoryProjectModel {
  String? name;
  String? description;
  String? assigned_user_id;
  String? main_owner_id;
  String? createdtime;
  String? modifiedtime;
  String? modifiedby;
  String? related_project;
  String? related_project_label;
  String? record_id;
  String? crmid;
  String? id;
  String? total_tasks;
  String? total_completed_tasks;
  String? main_owner_name;
  String? progress;
  List<dynamic>? assigned_owners;

  CategoryProjectModel({
    this.name,
    this.description,
    this.assigned_user_id,
    this.main_owner_id,
    this.createdtime,
    this.modifiedtime,
    this.modifiedby,
    this.related_project,
    this.related_project_label,
    this.record_id,
    this.crmid,
    this.id,
    this.progress,
    this.total_tasks,
    this.main_owner_name,
    this.assigned_owners,
    this.total_completed_tasks,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'description': description,
      'assigned_user_id': assigned_user_id,
      'main_owner_id': main_owner_id,
      'createdtime': createdtime,
      'modifiedtime': modifiedtime,
      'modifiedby': modifiedby,
      'related_project': related_project,
      'related_project_label': related_project_label,
      'record_id': record_id,
      'id': crmid,
      'progress': progress,
      'total_tasks': total_tasks,
      'main_owner_name': main_owner_name,
      'assigned_owners': assigned_owners,
      'total_completed_tasks': total_completed_tasks,
    };
  }

  factory CategoryProjectModel.fromMap(Map<String, dynamic> map) {
    return CategoryProjectModel(
      name: map['name'] != null ? map['name'] as String : 'Không xác định',
      description: map['description'] != null
          ? map['description'] as String
          : 'Không xác định',
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      main_owner_id: map['main_owner_id'] != null
          ? map['main_owner_id'] as String
          : 'Không xác định',
      createdtime: map['createdtime'] != null
          ? map['createdtime'] as String
          : 'Không xác định',
      modifiedtime: map['modifiedtime'] != null
          ? map['modifiedtime'] as String
          : 'Không xác định',
      modifiedby: map['modifiedby'] != null
          ? map['modifiedby'] as String
          : 'Không xác định',
      related_project: map['related_project'] != null
          ? map['related_project'] as String
          : 'Không xác định',
      related_project_label: map['related_project_label'] != null
          ? map['related_project_label'] as String
          : 'Không xác định',
      record_id: map['record_id'] != null
          ? map['record_id'] as String
          : 'Không xác định',
      total_completed_tasks: map['total_completed_tasks'] != null
          ? map['total_completed_tasks'] as String
          : 'Không xác định',
      id: map['id'] != null ? map['id'] as String : 'Không xác định',
      total_tasks: map['total_tasks'] != null
          ? map['total_tasks'] as String
          : 'Không xác định',
      progress: map['progress'] != null
          ? map['progress'] as String
          : 'Không xác định',
      crmid: map['crmid'] != null ? map['crmid'] as String : 'Không xác định',
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : 'Không xác định',
      assigned_owners: map['assigned_owners'] != null
          ? map['assigned_owners'] as List<dynamic>
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory CategoryProjectModel.fromJson(String source) =>
      CategoryProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  // @override
  // String toString() {
  //   return 'CategoryProjectModel(\nname: $name,\n description: $description,\n assigned_user_id: $assigned_user_id,\n main_owner_id: $main_owner_id,\n createdtime: $createdtime,\n modifiedtime: $modifiedtime,\n modifiedby: $modifiedby,\n related_project: $related_project,\n related_project_label: $related_project_label,\n record_id: $record_id,\n id: $id,\n crmid: $crmid,\n main_owner_name: $main_owner_name,\n assigned_owners: $assigned_owners)';
  // }
  @override
  String toString() {
    return this.name!;
  }
}
