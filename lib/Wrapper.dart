import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/Signing.dart';
import 'package:the_guc_cc_app/ViewPosts.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:the_guc_cc_app/homepagefaks.dart';
import 'package:the_guc_cc_app/objects/MyNames.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';

class Wrapper extends StatefulWidget {
  static const routeName = '/wrapper';
  Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final myUserAuthStream;
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.subscribeToTopic("CC");
    final authProvider = Provider.of<Auth>(context, listen: false);
    myUserAuthStream = authProvider.user;

    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    var pressed = false;
    // authProvider.reloadUserData();
    // authProvider.printCurrentUserEmail();
    return StreamBuilder<MyUser?>(
        stream: myUserAuthStream,
        builder: (_, AsyncSnapshot<MyUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final MyUser? user = snapshot.data;
            if (user != null) {
              print(user.email);
              //ADD HOME PAGE HERE YOU CAN ACCESS THE FULL USER PROFILE FROM THE DATABASE BY
              //GETTING THE USER AUTHENTICATION INFO FROM THE PROVIDER THEN
              //QUERY THE DATABASE FOR THE USER DOCUMENT THAT HAS THIS EMAIL WHERE
              //YOU WILL KNOW THE USER TYPE AND OTHER INFO SUCH AS THE SAVED POSTS IDS SUPPOSEDLY
              return homepage();
              // this is the one that will be used !!!!
              // return ViewPosts();
            } else {
              print("user from wrapper " + user.toString());
              return Signing();
            }
          }
          //WHILE LOADING
          print('circular from wrapper');
          return Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        });
  }
}
