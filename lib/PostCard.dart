import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PostCard extends StatefulWidget {
  const PostCard({Key? key}) : super(key: key);
  static const String PostCardRoute = "/PostCard";

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  Map<String, dynamic> postData = {};
  bool hasValues = false;
  Map<String, String> options = {};

  readOptions(Map<String, String> options) {
    // for (var key in options.keys)
    // {
    //   for (var i = 0; i < count; i++) {
        
    //   }

    // }
    // return ListView.builder(itemCount: options.length,itemBuilder: (context,index){
    //    ListTile(
    //       title: Text(options.keys.elementAt(index)),
    //       leading: Radio(
    //         value: options.values.elementAt(index),
    //         groupValue: null,
    //         onChanged: (int? value) {
    //           setState(() {
    //             //  = value;
    //           });
    //         },
    //       ),
    //     );
   
  }
  Future<void> readPost() {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc('Ntk292c8AaPDMNVEYsPH')
        .get()
        .then((value) {
      setState(() {
        postData = value.data() as Map<String, dynamic>;
        options = postData["options"] as Map<String, String>;
        hasValues = true;
      });
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    print(postData['vote']);
    return Scaffold(
        appBar: AppBar(
          title: const Text("The GUC CC App"),
          actions: [
            IconButton(
                onPressed: () {
                  readPost();
                },
                icon: Icon(Icons.read_more_sharp))
          ],
        ),
        body: hasValues
            ? ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    margin: EdgeInsets.all(10),
                    child: postData["vote"] as bool
                        ? Column(
                            children: [
                              Text(postData["title"]),
                              Text((postData["date"] as Timestamp)
                                  .toDate()
                                  .toString()),
                              Text((postData["vote"] as bool).toString()),
                              // readOptions(postData['options'])
                              Text(options.keys.elementAt(1))
                            ],
                          )
                        : Column(
                            children: [
                              Text(postData["title"]),
                              Text((postData["date"] as Timestamp)
                                  .toDate()
                                  .toString()),
                              Text((postData["vote"] as bool).toString()),
                            ],
                          ),
                  );
                })
            : Container(
                child: CircularProgressIndicator(),
              ));
  }
}
