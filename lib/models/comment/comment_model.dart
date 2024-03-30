// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CommentModel {
  String? username;
  String? avatarUrl;
  String? commentcontent;
  String? createdtime;
  String? modcommentsid;
  String? parent_comments;
  List<CommentModel> replies = [];

  CommentModel({
    this.username,
    this.avatarUrl,
    this.commentcontent,
    this.createdtime,
    this.modcommentsid,
    this.parent_comments,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'avatarUrl': avatarUrl,
      'commentcontent': commentcontent,
      'createdtime': createdtime,
      'modcommentsid': modcommentsid,
      'parent_comments': parent_comments,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      username: map['username'] != null ? map['username'] as String : null,
      avatarUrl: map['avatarUrl'] != null ? map['avatarUrl'] as String : null,
      commentcontent: map['commentcontent'] != null
          ? map['commentcontent'] as String
          : null,
      createdtime: map['createdtime'] ?? 'Không xác định',
      modcommentsid:
          map['modcommentsid'] != null ? map['modcommentsid'] as String : null,
      parent_comments: map['parent_comments'] != null
          ? map['parent_comments'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) =>
      CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
