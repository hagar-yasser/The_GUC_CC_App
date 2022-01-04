import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SinglePost extends StatefulWidget {
  String postDocID = "";
  Map<String, dynamic> postDocAccessible = new Map();
  Function PostContentContainer;
  Function authorDataUI;
  Function readOptions;
  String postUserId = "";
  bool vote = false;
  Map<String, dynamic> postBody = new Map();

  SinglePost(
      {required this.postDocAccessible,
      required this.postDocID,
      required this.PostContentContainer,
      required this.authorDataUI,
      required this.readOptions,
      required this.postUserId,
      required this.vote,
      required this.postBody});

  @override
  _SinglePostState createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      margin: EdgeInsets.all(5),
      child: Column(
        children: [
          widget.authorDataUI(
              context,
              widget.postDocID,
              (widget.postDocAccessible["date"] as Timestamp).toDate(),
              widget.postDocAccessible["userName"],
              widget.postUserId,
              widget.vote,
              widget.postBody),
          // authorDataUI(
          //     context,
          //     postDocID,
          //     (postDocAccessible["date"] as Timestamp)
          //         .toDate(),
          //     "Ano."),
          widget.PostContentContainer(context, widget.postDocAccessible),
          (widget.postDocAccessible['vote'] as bool)
              ? widget.readOptions(
                  (widget.postDocAccessible["options"] as Map<String, dynamic>),
                  widget.postDocID)
              : Container(
                  height: 0,
                )
        ],
      ),
    );
  }
}
