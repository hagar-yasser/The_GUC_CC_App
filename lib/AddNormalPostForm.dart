import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NormalPostForm extends StatefulWidget {
  const NormalPostForm({Key? key}) : super(key: key);
  static const NormalPostFormRoute = "/NormalPostForm";

  @override
  _NormalPostFormState createState() => _NormalPostFormState();
}

// class PostArguments {
//   final String? title;
//   final String? body;
//   final String? id;
//   final String? username;
//   final String? userId;
//   final Timestamp? date;
//   final bool? vote;
//   final Map<String, dynamic>? options;

//   PostArguments(this.title, this.body, this.id, this.username, this.userId,
//       this.date, this.options, this.vote);
// }

class _NormalPostFormState extends State<NormalPostForm> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  var isloading = false;
  String? myID = Auth().getCurrentUser()?.uid;
  String? userName = Auth().getCurrentUser()?.displayName;

  Future<void> AddPost(
      String t, String b, bool v, Map<String, List<String>> options) {
    return posts.add({
      'title': t,
      'body': b,
      'date': Timestamp.now(),
      'vote': v,
      'options': options,
      'userID': myID,
      'userName': userName
    }).then((value) {
      print(value);
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<void> EditPost(String t, String b, bool v,
      Map<String, List<String>> options, String? id) {
    return posts.doc(id).set({
      'title': t,
      'body': b,
      'date': Timestamp.now(),
      'vote': v,
      'options': options,
      'userID': myID,
      'userName': userName
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map? args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      if (args['title'] != null) {
        title.text = args['title'] as String;
      }

      if (args['body'] != null) {
        body.text = args['body'] as String;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("The GUC CC App"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isloading = true;
                  });

                  if (args != null && args['id'] != null) {
                    var response =
                        EditPost(title.text, body.text, false, {}, args['id'])
                            .then((_) {
                      setState(() {
                        title.clear();
                        body.clear();
                        isloading = false;
                        Navigator.of(context).pop();
                      });
                    }).catchError((onError) {
                      return showDialog<Null>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("An error occurred !"),
                                content: Text(onError.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Okay'))
                                ],
                              ));
                    });
                  } else {
                    var response =
                        AddPost(title.text, body.text, false, {}).then((_) {
                      setState(() {
                        title.clear();
                        body.clear();
                        isloading = false;
                        Navigator.of(context).pop();
                      });
                    }).catchError((onError) {
                      return showDialog<Null>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text("An error occurred !"),
                                content: Text(onError.toString()),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(ctx).pop();
                                      },
                                      child: const Text('Okay'))
                                ],
                              ));
                    });
                  }
                },
                icon: Icon(Icons.check))
          ],
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                margin: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(labelText: "Title"),
                      controller: title,
                    ),
                    TextField(
                      decoration: InputDecoration(labelText: "Body"),
                      controller: body,
                    ),
                  ],
                ),
              ));
  }
}
