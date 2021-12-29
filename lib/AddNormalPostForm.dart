import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NormalPostForm extends StatefulWidget {
  const NormalPostForm({Key? key}) : super(key: key);
  static const NormalPostFormRoute = "/NormalPostForm";

  @override
  _NormalPostFormState createState() => _NormalPostFormState();
}

class _NormalPostFormState extends State<NormalPostForm> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  var isloading = false;
  Future<void> AddPost(String t, String b, bool v, Map<String, int> options) {
    return posts.add({
      'title': t,
      'body': b,
      'date': Timestamp.now(),
      'vote': v,
      'options': options
    }).then((value) {
      print(value);
    }).catchError((onError) {
      print(onError);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("The GUC CC App"),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    isloading = true;
                  });
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
