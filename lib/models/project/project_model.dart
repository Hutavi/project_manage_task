// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProjectModel {
  String? projectname;
  String? startdate;
  String? targetenddate;
  String? actualenddate;
  String? projectstatus;
  String? projecttype;
  String? assigned_user_id;
  String? projectpriority;
  String? progress;
  String? description;
  String? project_category;
  String? project_sales;
  String? project_salesmans;
  String? tasklist;
  String? issue_list;
  String? id;
  String? projectid;
  String? main_owner_name;
  String? completed_tasks;
  String? total_tasks;
  List<dynamic>? assigned_owners;
  List<dynamic>? statistic;

  ProjectModel({
    this.projectname,
    this.startdate,
    this.targetenddate,
    this.actualenddate,
    this.projectstatus,
    this.projecttype,
    this.assigned_user_id,
    this.projectpriority,
    this.progress,
    this.description,
    this.project_category,
    this.project_sales,
    this.project_salesmans,
    this.tasklist,
    this.issue_list,
    this.id,
    this.projectid,
    this.main_owner_name,
    this.completed_tasks,
    this.total_tasks,
    this.assigned_owners,
    this.statistic,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'projectname': projectname,
      'startdate': startdate,
      'targetenddate': targetenddate,
      'actualenddate': actualenddate,
      'projectstatus': projectstatus,
      'projecttype': projecttype,
      'assigned_user_id': assigned_user_id,
      'projectpriority': projectpriority,
      'progress': progress,
      'description': description,
      'project_category': project_category,
      'project_sales': project_sales,
      'project_salesmans': project_salesmans,
      'tasklist': tasklist,
      'issue_list': issue_list,
      'id': id,
      'projectid': projectid,
      'main_owner_name': main_owner_name,
      'completed_tasks': completed_tasks,
      'total_tasks': total_tasks,
      'assigned_owners': assigned_owners,
      'statistic': statistic,
    };
  }

  factory ProjectModel.fromMap(Map<String, dynamic> map) {
    return ProjectModel(
      projectname: map['projectname'] != null
          ? map['projectname'] as String
          : 'Không xác định',
      startdate: map['startdate'] != null
          ? map['startdate'] as String
          : 'Không xác định',
      targetenddate: map['targetenddate'] != null
          ? map['targetenddate'] as String
          : 'Không xác định',
      actualenddate: map['actualenddate'] != null
          ? map['actualenddate'] as String
          : 'Không xác định',
      projectstatus: map['projectstatus'] != null
          ? map['projectstatus'] as String
          : 'Không xác định',
      projecttype: map['projecttype'] != null
          ? map['projecttype'] as String
          : 'Không xác định',
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : 'Không xác định',
      projectpriority: map['projectpriority'] != null
          ? map['projectpriority'] as String
          : 'Không xác định',
      progress: map['progress'] != null
          ? map['progress'] as String
          : 'Không xác định',
      description: map['description'] != null
          ? map['description'] as String
          : 'Không xác định',
      project_category: map['project_category'] != null
          ? map['project_category'] as String
          : 'Không xác định',
      project_sales: map['project_sales'] != null
          ? map['project_sales'] as String
          : 'Không xác định',
      project_salesmans: map['project_salesmans'] != null
          ? map['project_salesmans'] as String
          : 'Không xác định',
      tasklist: map['tasklist'] != null
          ? map['tasklist'] as String
          : 'Không xác định',
      issue_list: map['issue_list'] != null
          ? map['issue_list'] as String
          : 'Không xác định',
      id: map['id'] != null ? map['id'] as String : 'Không xác định',
      projectid: map['projectid'] != null
          ? map['projectid'] as String
          : 'Không xác định',
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : 'Không xác định',
      completed_tasks: map['completed_tasks'] != null
          ? map['completed_tasks'] as String
          : 'Không xác định',
      total_tasks: map['total_tasks'] != null
          ? map['total_tasks'] as String
          : 'Không xác định',
      assigned_owners: map['assigned_owners'] != null
          ? map['assigned_owners'] as List<dynamic>
          : [],
      statistic:
          map['statistic'] != null ? map['statistic'] as List<dynamic> : [],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProjectModel.fromJson(String source) =>
      ProjectModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProjectModel(\nprojectname: $projectname,\n startdate: $startdate,\n targetenddate: $targetenddate,\n actualenddate: $actualenddate,\n projectstatus: $projectstatus,\n projecttype: $projecttype,\n assigned_user_id: $assigned_user_id,\n projectpriority: $projectpriority,\n progress: $progress,\n description: $description,\n project_category: $project_category,\n project_sales: $project_sales,\n project_salesmans: $project_salesmans,\n tasklist: $tasklist,\n issue_list: $issue_list, id: $id,\n main_owner_name: $main_owner_name,\n assigned_owners: $assigned_owners)';
  }
}
