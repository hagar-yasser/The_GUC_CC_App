import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';

class VotingPostForm extends StatefulWidget {
  const VotingPostForm({Key? key}) : super(key: key);
  static const VotingPostFormRoute = "/VotingPostForm";

  @override
  _VotingPostFormState createState() => _VotingPostFormState();
}

class _VotingPostFormState extends State<VotingPostForm> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();
  String? myID=Auth().getCurrentUser()?.uid;
  String? userName=Auth().getCurrentUser()?.displayName;
  // TextEditingController option1 = TextEditingController();
  // TextEditingController option2 = TextEditingController();
  var moreOptions = false;
  List<TextField> TextFields = [
    TextField(
      decoration: InputDecoration(labelText: "Option 1"),
      controller: TextEditingController(),
    ),
    TextField(
      decoration: InputDecoration(labelText: "Option 2"),
      controller: TextEditingController(),
    ),
  ];

  CollectionReference posts = FirebaseFirestore.instance.collection("posts");
  var isloading = false;
  Map<String, String> addOptions() {
    return {for (var option in TextFields) option.controller!.text: ""};
  }

  Future<void> AddPost(String t, String b, bool v, Map<String, String> options) {
    return posts.add({
      'title': t,
      'body': b,
      'date': Timestamp.now(),
      'vote': v,
      'options': options,
      'userID' :myID,
      'userName':userName
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
                      AddPost(title.text, body.text, true, addOptions())
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
                },
                icon: Icon(Icons.check,),)
          ],
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
              padding: EdgeInsets.all(10),
              
                physics: ScrollPhysics(),
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
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: TextFields.length,
                        itemBuilder: (context, indx) {
                          return TextFields[indx];
                        }),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            var c = TextFields.length + 1;
                            var o = "Option " + c.toString();
                            TextFields.add(TextField(
                              decoration: InputDecoration(labelText: o),
                              controller: TextEditingController(),
                            ));
                          });
                        },
                        child: Text("Add Option...")),
                  ],
                ),
              ));
  }
}
