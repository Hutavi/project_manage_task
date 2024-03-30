import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProjectTaskModel {
  String? label;
  String? projecttaskname;
  String? projecttasktype;
  String? projecttaskpriority;
  String? projectid;
  String? projectid_label;
  String? assigned_user_id;
  String? projecttaskprogress;
  String? projecttaskhours;
  String? startdate;
  String? enddate;
  String? createdtime;
  String? modifiedtime;
  String? description;
  String? categoryname;
  String? projecttaskstatus;
  String? main_owner_id;
  String? users_department;
  String? related_cpprojectitem;
  String? related_cpprojectitem_label;
  String? start_date_plan;
  String? end_date_plan;
  String? leadtime;
  String? category_name;
  String? projecttask_dependency_task;
  String? related_projecttask;
  String? estimated_processing_time;
  String? checklist;
  String? progressreport;
  String? id;
  String? main_owner_name;
  String? projecttaskid;
  String? crmid;
  List<dynamic> assigned_owners = [];

  ProjectTaskModel({
    this.label,
    this.projecttaskname,
    this.projecttasktype,
    this.projecttaskpriority,
    this.projectid,
    this.projectid_label,
    this.assigned_user_id,
    this.projecttaskprogress,
    this.projecttaskhours,
    this.startdate,
    this.enddate,
    this.createdtime,
    this.modifiedtime,
    this.description,
    this.categoryname,
    this.projecttaskstatus,
    this.main_owner_id,
    this.users_department,
    this.related_cpprojectitem,
    this.related_cpprojectitem_label,
    this.start_date_plan,
    this.end_date_plan,
    this.leadtime,
    this.progressreport,
    this.category_name,
    this.projecttask_dependency_task,
    this.related_projecttask,
    this.estimated_processing_time,
    this.id,
    this.main_owner_name,
    this.projecttaskid,
    this.crmid,
    this.checklist,
    required this.assigned_owners,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'label': label,
      'projecttaskname': projecttaskname,
      'projecttasktype': projecttasktype,
      'projecttaskpriority': projecttaskpriority,
      'projectid': projectid,
      'projectid_label': projectid_label,
      'assigned_user_id': assigned_user_id,
      'projecttaskprogress': projecttaskprogress,
      'projecttaskhours': projecttaskhours,
      'startdate': startdate,
      'enddate': enddate,
      'createdtime': createdtime,
      'modifiedtime': modifiedtime,
      'description': description,
      'projecttaskstatus': projecttaskstatus,
      'main_owner_id': main_owner_id,
      'users_department': users_department,
      'related_cpprojectitem': related_cpprojectitem,
      'related_cpprojectitem_label': related_cpprojectitem_label,
      'start_date_plan': start_date_plan,
      'end_date_plan': end_date_plan,
      'leadtime': leadtime,
      'categoryname': categoryname,
      'category_name': category_name,
      'projecttask_dependency_task': projecttask_dependency_task,
      'related_projecttask': related_projecttask,
      'estimated_processing_time': estimated_processing_time,
      'id': id,
      'checklist': checklist,
      'main_owner_name': main_owner_name,
      'projecttaskid': projecttaskid,
      'crmid': crmid,
      'assigned_owners': assigned_owners,
      'progressreport': progressreport,
    };
  }

  factory ProjectTaskModel.fromMap(Map<String, dynamic> map) {
    return ProjectTaskModel(
      label: map['label'] != null ? map['label'] as String : null,
      projecttaskname: map['projecttaskname'] != null
          ? map['projecttaskname'] as String
          : null,
      projecttasktype: map['projecttasktype'] != null
          ? map['projecttasktype'] as String
          : null,
      projecttaskpriority: map['projecttaskpriority'] != null
          ? map['projecttaskpriority'] as String
          : null,
      projectid: map['projectid'] != null ? map['projectid'] as String : null,
      projectid_label: map['projectid_label'] != null
          ? map['projectid_label'] as String
          : null,
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      projecttaskprogress: map['projecttaskprogress'] != null
          ? map['projecttaskprogress'] as String
          : null,
      projecttaskhours: map['projecttaskhours'] != null
          ? map['projecttaskhours'] as String
          : null,
      categoryname:
          map['categoryname'] != null ? map['categoryname'] as String : null,
      progressreport: map['progressreport'] != null
          ? map['progressreport'] as String
          : null,
      startdate: map['startdate'] != null ? map['startdate'] as String : null,
      enddate: map['enddate'] != null ? map['enddate'] as String : null,
      createdtime:
          map['createdtime'] != null ? map['createdtime'] as String : null,
      modifiedtime:
          map['modifiedtime'] != null ? map['modifiedtime'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      projecttaskstatus: map['projecttaskstatus'] != null
          ? map['projecttaskstatus'] as String
          : null,
      main_owner_id:
          map['main_owner_id'] != null ? map['main_owner_id'] as String : null,
      users_department: map['users_department'] != null
          ? map['users_department'] as String
          : null,
      related_cpprojectitem: map['related_cpprojectitem'] != null
          ? map['related_cpprojectitem'] as String
          : null,
      related_cpprojectitem_label: map['related_cpprojectitem_label'] != null
          ? map['related_cpprojectitem_label'] as String
          : null,
      start_date_plan: map['start_date_plan'] != null
          ? map['start_date_plan'] as String
          : null,
      end_date_plan:
          map['end_date_plan'] != null ? map['end_date_plan'] as String : null,
      leadtime: map['leadtime'] != null ? map['leadtime'] as String : null,
      projecttask_dependency_task: map['projecttask_dependency_task'] != null
          ? map['projecttask_dependency_task'] as String
          : null,
      related_projecttask: map['related_projecttask'] != null
          ? map['related_projecttask'] as String
          : null,
      estimated_processing_time: map['estimated_processing_time'] != null
          ? map['estimated_processing_time'] as String
          : null,
      id: map['id'] != null ? map['id'] as String : null,
      checklist: map['checklist'] != null ? map['checklist'] as String : null,
      category_name:
          map['category_name'] != null ? map['category_name'] as String : null,
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : null,
      projecttaskid:
          map['projecttaskid'] != null ? map['projecttaskid'] as String : null,
      crmid: map['crmid'] != null ? map['crmid'] as String : null,
      assigned_owners: map['assigned_owners'] != null
          ? List<dynamic>.from((map['assigned_owners'] as List<dynamic>))
          : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectTaskModel.fromJson(String source) =>
      ProjectTaskModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectTask(\nlabel: $label,\n checklist: $checklist, \n projecttaskname: $projecttaskname,\n projecttasktype: $projecttasktype,\n projecttaskpriority: $projecttaskpriority,\n projectid: $projectid,\n projectid_label: $projectid_label,\n assigned_user_id: $assigned_user_id,\n projecttaskprogress: $projecttaskprogress,\n projecttaskhours: $projecttaskhours,\n startdate: $startdate,\n enddate: $enddate,\n createdtime: $createdtime,\n modifiedtime: $modifiedtime,\n description: $description,\n projecttaskstatus: $projecttaskstatus,\n main_owner_id: $main_owner_id,\n users_department: $users_department,\n related_cpprojectitem: $related_cpprojectitem,\n related_cpprojectitem_label: $related_cpprojectitem_label,\n start_date_plan: $start_date_plan,\n end_date_plan: $end_date_plan,\n leadtime: $leadtime,\n projecttask_dependency_task: $projecttask_dependency_task,\n related_projecttask: $related_projecttask,\n estimated_processing_time: $estimated_processing_time,\n id: $id, main_owner_name: $main_owner_name,\n projecttaskid: $projecttaskid,\n crmid: $crmid,\n assigned_owners: $assigned_owners)';
  }
}
