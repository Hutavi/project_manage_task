import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class LeavingModelList {
  String? name;
  String? cpleaving_status;
  String? description;
  String? assigned_user_id;
  String? cpleaving_type;
  String? createdtime;
  String? cpleavingid;
  String? starred;
  String? id;
  String? main_owner_name;
  List<Map<String, String>> assigned_owners = [];

  LeavingModelList({
    this.name,
    this.cpleaving_status,
    this.description,
    this.assigned_user_id,
    this.cpleaving_type,
    this.createdtime,
    this.cpleavingid,
    this.starred,
    this.id,
    this.main_owner_name,
    required this.assigned_owners,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'cpleaving_status': cpleaving_status,
      'description': description,
      'assigned_user_id': assigned_user_id,
      'createdtime': createdtime,
      'cpleavingid': cpleavingid,
      'starred': starred,
      'id': id,
      'main_owner_name': main_owner_name,
      'assigned_owners': assigned_owners,
    };
  }

  factory LeavingModelList.fromMap(Map<String, dynamic> map) {
    return LeavingModelList(
      name: map['name'] != null ? map['name'] as String : null,
      cpleaving_status: map['cpleaving_status'] != null
          ? map['cpleaving_status'] as String
          : null,
      description:
          map['description'] != null ? map['description'] as String : null,
      assigned_user_id: map['assigned_user_id'] != null
          ? map['assigned_user_id'] as String
          : null,
      createdtime:
          map['createdtime'] != null ? map['createdtime'] as String : null,
      cpleaving_type: map['cpleaving_type'] != null
          ? map['cpleaving_type'] as String
          : "Không xác định",
      cpleavingid:
          map['cpleavingid'] != null ? map['cpleavingid'] as String : null,
      starred: map['starred'] != null ? map['starred'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
      main_owner_name: map['main_owner_name'] != null
          ? map['main_owner_name'] as String
          : null,
      assigned_owners: List<Map<String, String>>.from(
        (map['assigned_owners'] as List<dynamic>).map(
          (item) => {
            'id': item['id'] as String,
            'name': item['name'] as String,
          },
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory LeavingModelList.fromJson(String source) =>
      LeavingModelList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'LeavingModelList(name: $name, cpleaving_status: $cpleaving_status, description: $description, assigned_user_id: $assigned_user_id, cpleaving_type: $cpleaving_type, createdtime: $createdtime, cpleavingid: $cpleavingid, starred: $starred, id: $id, main_owner_name: $main_owner_name, assigned_owners: $assigned_owners)';
  }
}
