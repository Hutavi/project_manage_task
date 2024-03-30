import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:management_app/constants/color.dart';
import 'package:management_app/constants/font.dart';
import 'package:management_app/widgets/text_custom.dart';

import '../../../../../models/comment/comment_model.dart';

class CommentWidget extends StatefulWidget {
  final CommentModel comment;
  final void Function(String content, String parrentComment) onReply;
  final void Function(String content, String commentId) onUpdate;

  const CommentWidget(
      {required this.comment, required this.onReply, required this.onUpdate});

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final commentController = TextEditingController();
  final editController = TextEditingController();
  bool showRely = false;
  bool showEdit = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: 32,
                height: 32,
                // padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    color: COLOR_DONE),
                child: const Icon(
                  Icons.person,
                  color: COLOR_WHITE,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vô danh',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    !showEdit
                        ? Text(
                            widget.comment.commentcontent!,
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  maxLines: 2,
                                  controller: editController,
                                  cursorColor: COLOR_TEXT_MAIN,
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontSize: FONT_SIZE_TEXT_BUTTON,
                                    color: COLOR_TEXT_MAIN,
                                  ),
                                  onChanged: (value) {
                                    // project.description = value;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Nhập bình luận...',
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 8, horizontal: 5),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: COLOR_GRAY),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: COLOR_GRAY),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: COLOR_GRAY),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    if (!showEdit) {
                      setState(() {
                        showEdit = true;
                        editController.text = widget.comment.commentcontent!;
                      });
                    } else {
                      if (editController.text.isNotEmpty) {
                        setState(() {
                          widget.comment.commentcontent = editController.text;
                          showEdit = false;
                          widget.onUpdate(editController.text,
                              widget.comment.modcommentsid!);
                        });
                      }
                    }
                  },
                  child: TextCustom(
                      text: showEdit ? "Cập nhật" : "Chỉnh sửa",
                      color: COLOR_TEXT_MAIN,
                      fontSize: FONT_SIZE_NORMAL,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            "Bình luận vào lúc ${widget.comment.createdtime}",
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                showRely = !showRely;
              });
              // widget.onReply();
            },
            child: const TextCustom(
                text: "Trả lời",
                color: COLOR_TEXT_MAIN,
                fontSize: FONT_SIZE_NORMAL,
                fontWeight: FontWeight.bold),
          ),
          showRely
              ? Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        maxLines: 2,
                        controller: commentController,
                        cursorColor: COLOR_TEXT_MAIN,
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w500,
                          fontSize: FONT_SIZE_TEXT_BUTTON,
                          color: COLOR_TEXT_MAIN,
                        ),
                        onChanged: (value) {
                          // project.description = value;
                        },
                        decoration: const InputDecoration(
                          hintText: 'Nhập bình luận...',
                          isDense: true,
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: COLOR_GRAY),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    InkWell(
                      onTap: () {
                        if (commentController.text.isNotEmpty) {
                          setState(() {
                            showRely = !showRely;
                          });
                          widget.onReply(commentController.text,
                              widget.comment.modcommentsid!);
                          commentController.text = '';
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 46,
                        height: 46,
                        decoration: const BoxDecoration(
                          color: COLOR_DONE,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: const Row(
                          children: [
                            SizedBox(
                              width: 13,
                            ),
                            Icon(
                              Icons.send,
                              size: 24,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              : Container(),
          for (var reply in widget.comment.replies)
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: CommentWidget(
                comment: reply,
                onReply: (String comment, String parrentComment) {
                  widget.onReply(comment, widget.comment.modcommentsid!);
                },
                onUpdate: (content, commentId) {},
              ),
            ),
        ],
      ),
    );
  }
}
