//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_guc_cc_app/view_profile.dart';
import './profile_photo.dart';

class MainDrawer extends StatefulWidget {
  @override
  State<MainDrawer> createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  navigateToProfile(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/profileRoute',
    );
    // arguments: {'category': cat};
  }

  navigateToSaved(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/savedRoute',
    );
    // arguments: {'category': cat});
  }

  navigateToMyPosts(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/myPostsRoute',
    );
    // arguments: {'category': cat});
  }

  navigateToSigning(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/signing',
    );
    // arguments: {'category': cat});
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    navigateToProfile(BuildContext myContext) {
      Navigator.of(myContext)
          .pushNamed('/profileRoute', arguments: {'user': "${user!.uid}"});
    }

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Drawer(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print("${data['type']}");
          var x = 0;
          print("length");
          print("${data['type']}".compareTo("Normal Student"));
          if ("${data['type']}".compareTo("Normal Student") == 0) {
            print("normaaaal");
            return Drawer(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    color: Colors.blue,
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),

                  ProfilePhoto(),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      child: Text("View Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400])),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                      ),
                      onPressed: () => navigateToProfile(context), //function
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      child: Text("View Saved Posts",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400])),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                      ),
                      onPressed: () => navigateToSaved(context), //function
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                        child: Text("Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.blue[400])),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                        ),
                        onPressed: () async {
                          await auth.signOut();
                          //navigateToSigning(context);
                        }),
                  ),
                ],
              ),
            );
          } else {
            return Drawer(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.centerLeft,
                    color: Colors.blue,
                    child: Text(
                      'My Profile',
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 30,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: SizedBox(
                      height: 115,
                      width: 115,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          CircleAvatar(
                              // backgroundImage: AssetImage(""),
                              ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      child: Text("View Profile",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400])),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                      ),
                      onPressed: () => navigateToProfile(context), //function
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      child: Text("View My Posts",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400])),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                      ),
                      onPressed: () => navigateToMyPosts(context), //function
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                      child: Text("View Saved Posts",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                              color: Colors.blue[400])),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.grey[200]),
                      ),
                      onPressed: () => navigateToSaved(context), //function
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(11),
                    child: ElevatedButton(
                        child: Text("Logout",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 15,
                                color: Colors.blue[400])),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey[200]),
                        ),
                        onPressed: ()  {
                           auth.signOut();
                          //navigateToSigning(context);
                        }),
                  ),
                ],
              ),
            );
          }
          // return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        // return Scaffold(
        //     drawer: MainDrawer(),
        //     body: Center(
        //       child: CircularProgressIndicator(),
        //     ));

        return Text("rokayaaa");
      },
    );

    // return Drawer(
    //   child: Column(
    //     children: [
    //       Container(
    //         height: 100,
    //         width: double.infinity,
    //         padding: EdgeInsets.all(20),
    //         alignment: Alignment.centerLeft,
    //         color: Colors.blue,
    //         child: Text(
    //           'My Profile',
    //           style: TextStyle(
    //               fontWeight: FontWeight.w500,
    //               fontSize: 30,
    //               color: Colors.white),
    //         ),
    //       ),
    //       Container(
    //         padding: EdgeInsets.all(16),
    //         child: SizedBox(
    //           height: 115,
    //           width: 115,
    //           child: Stack(
    //             clipBehavior: Clip.none,
    //             fit: StackFit.expand,
    //             children: [
    //               CircleAvatar(
    //                   // backgroundImage: AssetImage(""),
    //                   ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(11),
    //         child: ElevatedButton(
    //           child: Text("View Profile",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: 15,
    //                   color: Colors.blue[400])),
    //           style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
    //           ),
    //           onPressed: () => navigateToProfile(context), //function
    //         ),
    //       ),
    //       Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(11),
    //         child: ElevatedButton(
    //           child: Text("View My Posts",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: 15,
    //                   color: Colors.blue[400])),
    //           style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
    //           ),
    //           onPressed: () => navigateToMyPosts(context), //function
    //         ),
    //       ),
    //       Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(11),
    //         child: ElevatedButton(
    //           child: Text("View Saved Posts",
    //               style: TextStyle(
    //                   fontWeight: FontWeight.w500,
    //                   fontSize: 15,
    //                   color: Colors.blue[400])),
    //           style: ButtonStyle(
    //             backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
    //           ),
    //           onPressed: () => navigateToSaved(context), //function
    //         ),
    //       ),
    //       Container(
    //         width: double.infinity,
    //         padding: const EdgeInsets.all(11),
    //         child: ElevatedButton(
    //             child: Text("Logout",
    //                 style: TextStyle(
    //                     fontWeight: FontWeight.w500,
    //                     fontSize: 15,
    //                     color: Colors.blue[400])),
    //             style: ButtonStyle(
    //               backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
    //             ),
    //             onPressed: () async {
    //               await auth.signOut();
    //               navigateToSigning(context);
    //             }),
    //       ),
    //     ],
    //   ),
    // );
  }
}
