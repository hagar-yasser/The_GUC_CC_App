import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/Signing.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:the_guc_cc_app/objects/MyNames.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';

class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  _homepageState createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var pressed = false;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              pressed = !pressed;
            });

            // Add your onPressed code here!
          },
          label: const Text('Add Post'),
          icon: const Icon(Icons.post_add),
          backgroundColor: Colors.amber,
        ),
        body: Container(
          margin: EdgeInsets.all(15),
          child: pressed
              ? Column( children: [
                  ElevatedButton(
                    child: Text("Log Out"),
                    onPressed: () {
                      authProvider.signOut();
                    },
                  ),
                  Column(
                    children: [
                    ElevatedButton(
                   
                      child: Text("Voting"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/VotingPostForm");
                      },
                    ),
                    ElevatedButton(
                      child: Text("Normal"),
                      onPressed: () {
                        Navigator.of(context).pushNamed("/NormalPostForm");
                      },
                    )
                  ]),
                  ElevatedButton(
                    child: Text("post card"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/PostCard");
                    },
                  ),
                ])
              : Column( children: [
                  ElevatedButton(
                    child: Text("Log Out"),
                    onPressed: () {
                      authProvider.signOut();
                    },
                  ),
                  ElevatedButton(
                    child: Text("post card"),
                    onPressed: () {
                      Navigator.of(context).pushNamed("/PostCard");
                    },
                  ),
                ]),
        ));
  }
}
