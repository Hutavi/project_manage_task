import 'dart:convert';

class NotificationItemModel {
  String? message;
  NotificationData? data;
  NotificationItemModel({
    this.message,
    this.data,
  });

  @override
  String toString() => 'NotificationItemModel(message: $message, data: $data)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'data': data?.toMap(),
    };
  }

  factory NotificationItemModel.fromMap(Map<String, dynamic> map) {
    return NotificationItemModel(
      message: map['message'] != null ? map['message'] as String : null,
      data: map['data'] != null
          ? NotificationData.fromMap(map['data'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationItemModel.fromJson(String source) =>
      NotificationItemModel.fromMap(
          json.decode(source) as Map<String, dynamic>);
}

class NotificationData {
  String? id;
  String? type;
  String? subtype;
  String? image;
  String? relatedRecordId;
  String? relatedRecordName;
  String? relatedModuleName;
  String? createdTime;
  String? read;
  ExtraData? extraData;
  NotificationData({
    this.id,
    this.type,
    this.subtype,
    this.image,
    this.relatedRecordId,
    this.relatedRecordName,
    this.relatedModuleName,
    this.createdTime,
    this.read,
    this.extraData,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'subtype': subtype,
      'image': image,
      'relatedRecordId': relatedRecordId,
      'relatedRecordName': relatedRecordName,
      'relatedModuleName': relatedModuleName,
      'createdTime': createdTime,
      'read': read,
      'extraData': extraData?.toMap(),
    };
  }

  factory NotificationData.fromMap(Map<String, dynamic> map) {
    return NotificationData(
      id: map['id'] != null ? map['id'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      subtype: map['subtype'] != null ? map['subtype'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      relatedRecordId: map['relatedRecordId'] != null
          ? map['relatedRecordId'] as String
          : null,
      relatedRecordName: map['relatedRecordName'] != null
          ? map['relatedRecordName'] as String
          : null,
      relatedModuleName: map['relatedModuleName'] != null
          ? map['relatedModuleName'] as String
          : null,
      createdTime:
          map['createdTime'] != null ? map['createdTime'] as String : null,
      read: map['read'] != null ? map['read'] as String : null,
      extraData: map['extraData'] != null
          ? ExtraData.fromMap(map['extraData'] as Map<String, dynamic>)
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory NotificationData.fromJson(String source) =>
      NotificationData.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'NotificationData(id: $id, type: $type, subtype: $subtype, image: $image, relatedRecordId: $relatedRecordId, relatedRecordName: $relatedRecordName, relatedModuleName: $relatedModuleName, createdTime: $createdTime, read: $read, extraData: $extraData)';
  }
}

class ExtraData {
  String? activityType;
  String? startTime;
  String? dueTime;
  ExtraData({
    this.activityType,
    this.startTime,
    this.dueTime,
  });

  @override
  String toString() =>
      'ExtraData(activityType: $activityType, startTime: $startTime, dueTime: $dueTime)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'activityType': activityType,
      'startTime': startTime,
      'dueTime': dueTime,
    };
  }

  factory ExtraData.fromMap(Map<String, dynamic> map) {
    return ExtraData(
      activityType:
          map['activityType'] != null ? map['activityType'] as String : null,
      startTime: map['startTime'] != null ? map['startTime'] as String : null,
      dueTime: map['dueTime'] != null ? map['dueTime'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ExtraData.fromJson(String source) =>
      ExtraData.fromMap(json.decode(source) as Map<String, dynamic>);
}
