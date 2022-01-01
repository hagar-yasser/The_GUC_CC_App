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

class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var _image;
  var imagePicker;
  var i;

  void initState() {
    i = 0;
    super.initState();
    imagePicker = new ImagePicker();
  }

  // Future<String> uploadPic(File _image1) async {
  //   print("uploading");
  //   FirebaseStorage storage = FirebaseStorage.instance;
  //   String url = "";
  //   Reference ref = storage.ref().child("image1" + DateTime.now().toString());
  //   UploadTask uploadTask = ref.putFile(_image1);
  //   uploadTask.whenComplete(() {
  //     url = ref.getDownloadURL() as String;
  //     print("url");
  //     print(url);
  //   }).catchError((onError) {
  //     print(onError);
  //   });
  //   return url;
  // }

  Future<String> uploadPic2(File _image1, String path) async {
    print("uploading2");
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    // final auth = Provider.of<Auth>(context);
    // User? user = auth.getCurrentUser();
    Reference ref = storage.ref().child(path);
    // Reference ref = storage.ref().child("tada");
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.whenComplete(() {
      print("task completed");
      url = ref.getDownloadURL() as String;
      print("url");
      print(url);
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

 Future<String>
   getPic(String path) async {
    print("getting picture");
    FirebaseStorage storage = FirebaseStorage.instance;
    String url ="";
    String url2 ="";
    var file;
    Reference ref = storage.ref().child(path);
    Reference ref2 = storage.ref().child("avatar.png");
   url = ref.getDownloadURL() as String ;
    url2 = ref2.getDownloadURL() as String;
   // final name = ref.name;
    print(url);
    if (url=="") {
      file = File(url2);
    } else {
      file = File(url);
    }
    setState(() {
      _image = file;
    });
    return url;
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    //var x= await getPic("${user!.uid}");
    // if (i == 0) {
    //   //i++;
    //   FirebaseStorage storage = FirebaseStorage.instance;
    //   String url2 = "";
    //   // var file;
    //   Reference ref2 = storage.ref().child("avatar.png");
    //   url2 = ref2.getDownloadURL() as String;
    //   setState(() {
    //     i = i + 1;
    //     _image = File(url2);
    //   });
    // }
    CollectionReference users = FirebaseFirestore.instance.collection('Users');

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

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          print("TYPE: ${data['type']} ");

          return Scaffold(
            appBar: AppBar(
              title: Text('My profile'),
            ),
            drawer: MainDrawer(),
            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  GestureDetector(
                    child: Container(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        height: 170,
                        width: 170,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                                //  backgroundImage: FileImage(_image ?? File("")),
                                //  backgroundImage: FileImage(_image),
                                ),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () async {
                                    print("gallery");
                                    var source = ImageSource.gallery;
                                    XFile image = await imagePicker.pickImage(
                                        source: source,
                                        imageQuality: 50,
                                        preferredCameraDevice:
                                            CameraDevice.front);
                                    uploadPic2(File(image.path), "${user.uid}");
                                    getPic("${user.uid}");
                                    // setState(() {
                                    //   _image = File(image.path);
                                    // });
                                  },
                                  elevation: 2.0,
                                  fillColor: Color(0xFFF5F6F9),
                                  child: Icon(
                                    Icons.camera_alt_outlined,
                                    color: Colors.blue,
                                  ),
                                  padding: EdgeInsets.all(15.0),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Text(" ${user.displayName}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blue[400])),

                  SizedBox(height: 10),
                  Text(" ${data['type']} ",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blue[400])),

                  SizedBox(height: 10),

                  Text("${data['email']}",
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: Colors.blue[400])),

                  SizedBox(height: 10),
                  // Text("Major",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 20,
                  //         color: Colors.blue[400])),

                  SizedBox(height: 10),
                  // Text("43-XXXX",
                  //     style: TextStyle(
                  //         fontWeight: FontWeight.w500,
                  //         fontSize: 20,
                  //         color: Colors.blue[400])),

                  SizedBox(height: 10),
                ],
              ),
            ),
            //  ),
          );
        }

        return Scaffold(
            drawer: MainDrawer(),
            body: Center(
              child: CircularProgressIndicator(),
            ));
      },
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('My profile'),
    //   ),
    //   drawer: MainDrawer(),
    //   body: Container(
    //     alignment: Alignment.center,
    //     child: Column(
    //       children: [
    //         GestureDetector(
    //           child: Container(
    //             padding: EdgeInsets.all(20),
    //             child: SizedBox(
    //               height: 170,
    //               width: 170,
    //               child: Stack(
    //                 clipBehavior: Clip.none,
    //                 fit: StackFit.expand,
    //                 children: [
    //                   CircleAvatar(
    //                       //  backgroundImage: AssetImage(""),
    //                       ),
    //                   Positioned(
    //                       bottom: 0,
    //                       right: -25,
    //                       child: RawMaterialButton(
    //                         onPressed: () async {
    //                           var source = ImageSource.gallery;
    //                           XFile image = await imagePicker.pickImage(
    //                               source: source,
    //                               imageQuality: 50,
    //                               preferredCameraDevice: CameraDevice.front);

    //                           setState(() {
    //                             _image = File(image.path);
    //                           });
    //                         },
    //                         elevation: 2.0,
    //                         fillColor: Color(0xFFF5F6F9),
    //                         child: Icon(
    //                           Icons.camera_alt_outlined,
    //                           color: Colors.blue,
    //                         ),
    //                         padding: EdgeInsets.all(15.0),
    //                         shape: CircleBorder(),
    //                       )),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ),
    //         Text("Name: ${user!.displayName}",
    //             style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: 20,
    //                 color: Colors.blue[400])),

    //         SizedBox(height: 10),
    //         Text("Type",
    //             style: TextStyle(
    //                 fontWeight: FontWeight.w500,
    //                 fontSize: 20,
    //                 color: Colors.blue[400])),

    //         SizedBox(height: 10),
    //         // Text("Major",
    //         //     style: TextStyle(
    //         //         fontWeight: FontWeight.w500,
    //         //         fontSize: 20,
    //         //         color: Colors.blue[400])),

    //         SizedBox(height: 10),
    //         // Text("43-XXXX",
    //         //     style: TextStyle(
    //         //         fontWeight: FontWeight.w500,
    //         //         fontSize: 20,
    //         //         color: Colors.blue[400])),

    //         SizedBox(height: 10),
    //       ],
    //     ),
    //   ),
    //   //  ),
    // );
  }
}
