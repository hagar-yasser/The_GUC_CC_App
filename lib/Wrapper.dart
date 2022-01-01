import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/Signing.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';
import './drawer.dart';

class Wrapper extends StatefulWidget {
  static const routeName = '/wrapper';
  const Wrapper({Key? key}) : super(key: key);

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  late final myUserAuthStream;
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<Auth>(context, listen: false);
    myUserAuthStream = authProvider.user;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<Auth>(context);
    authProvider.printCurrentUserEmail();
    // authProvider.reloadUserData();
    // authProvider.printCurrentUserEmail();
    return StreamBuilder<MyUser?>(
        stream: myUserAuthStream,
        builder: (_, AsyncSnapshot<MyUser?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final MyUser? user = snapshot.data;
            if (user != null) {
              // print("trsttttesttt");
              // print(user.name);
              //ADD HOME PAGE HERE YOU CAN ACCESS THE FULL USER PROFILE FROM THE DATABASE BY
              //GETTING THE USER AUTHENTICATION INFO FROM THE PROVIDER THEN
              //QUERY THE DATABASE FOR THE USER DOCUMENT THAT HAS THIS EMAIL WHERE
              //YOU WILL KNOW THE USER TYPE AND OTHER INFO SUCH AS THE SAVED POSTS IDS SUPPOSEDLY
              return Scaffold(
                appBar: AppBar(
        title: Text('Wrapper'),
      ),
                  drawer: MainDrawer(),
                  body: Center(
                    child: ElevatedButton(
                      child: Text("Log Out"),
                      onPressed: () {
                        authProvider.signOut();
                      },
                    ),
                  ));
            } else {
              print("user from wrapper " + user.toString());
              return Signing();
            }
          }
          //WHILE LOADING
          print('circular from wrapper');
          return Scaffold(
              drawer: MainDrawer(),
              body: Center(
                child: CircularProgressIndicator(),
              ));
        });
  }
}
