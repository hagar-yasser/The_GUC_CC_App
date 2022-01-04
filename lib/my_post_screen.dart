import 'package:flutter/material.dart';
import './drawer.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';
import 'package:the_guc_cc_app/objects/MyNames.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'edit_profile_photo.dart';

class MyPosts extends StatefulWidget {
  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  // var i;
  void initState() {
    //i = 0;
    super.initState();
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();

    CollectionReference posts =
        FirebaseFirestore.instance.collection(myNames.postsTable);

    return FutureBuilder<QuerySnapshot>(
      future: posts.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && snapshot.data!.size != 0) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          var posts = snapshot.data!.docs;
          print("posts table" + snapshot.data!.docs.toString());
          return Text('done');
          // print(posts);
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
