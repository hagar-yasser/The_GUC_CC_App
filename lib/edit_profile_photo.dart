// ignore_for_file: argument_type_not_assignable_to_error_handler

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

class EditProfilePhoto extends StatefulWidget {
  const EditProfilePhoto({Key? key}) : super(key: key);

  @override
  _EditProfilePhotoState createState() => _EditProfilePhotoState();
}

class _EditProfilePhotoState extends State<EditProfilePhoto> {
  var _image;
  var imagePicker;
  var URL;

  void initState() {
    //_image = File(getPic("avatar.png") as String);
    // _image = File(URL);
    super.initState();
    imagePicker = new ImagePicker();
  }

  Future<String> uploadPic2(File _image1, String path) async {
    print("uploading2");
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    Reference ref = storage.ref().child(path);
    UploadTask uploadTask = ref.putFile(_image1);
    uploadTask.whenComplete(() async {
      print("task completed");
      url = await ref.getDownloadURL();
      print("url");
      print(url);
      getPic(path);
    }).catchError((onError) {
      print(onError);
    });
    return url;
  }

  // Future<Widget> _getImage(BuildContext context,String image)async {
  //     await FirestorgeService.loadImage(context, image).then((value){})
  // }

  Future<String> getPic(String path) async {
    print("getting picture");
    FirebaseStorage storage = FirebaseStorage.instance;
    // Future<String> url;
    // Future<String> url2;

    String url = "";
    //String url2 = "";
    // var url;
    // var url2;
    // var file;
    try {
      Reference ref = storage.ref().child(path);
      url = await ref.getDownloadURL();
      URL = url;
      setState(() {
        
      });
    } on Exception catch (e) {
      url =
          "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344";
      URL = url;
    }

    return url;
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    print("buildingggg");
    return FutureBuilder<String>(
        future: getPic("${user!.uid}"),
        // future: URL,
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          print("snapshot");
          print(snapshot);
          // print(snapshot.error);
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          // if (snapshot.hasData && !snapshot.data!.exists) {
          //   return Text("Document does not exist");
          // }

          if (snapshot.connectionState == ConnectionState.waiting) {
            //  print("waiting");
            // setState(() {
            // _image = File(snapshot.data);
            // });
            return Container(
              alignment: Alignment.center,
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
                        backgroundImage: NetworkImage(URL??
                            "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344"),
                        //  backgroundImage: FileImage(_image ?? File("")),
                        // backgroundImage: FileImage(_image),
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
                                  preferredCameraDevice: CameraDevice.front);
                              await uploadPic2(File(image.path), "${user.uid}");
                              setState(() {});
                              await getPic("${user.uid}");
                              String temp = await getPic("${user.uid}");
                              setState(() {
                                URL = temp;
                              });
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
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            String data = snapshot.data as String;
            //   print("TYPE: ${data['type']} ");
            // setState(() {
            //   _image = File(getPic("${user!.uid}") as String);
            // });
            print("Done");
            print(URL);
            return Container(
              alignment: Alignment.center,
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
                        backgroundImage: NetworkImage(URL ),
                        //  backgroundImage: FileImage(_image ?? File("")),
                        // backgroundImage: FileImage(_image),
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
                                  preferredCameraDevice: CameraDevice.front);
                              print("before upload");
                              await uploadPic2(File(image.path), "${user.uid}");
                              print("after upload");
                              print("before download");
                              await getPic("${user.uid}");
                              print("after download");
                              String temp = await getPic("${user.uid}");
                              setState(() {
                                URL = temp;
                              });
                              //  setState(() {
                              //   URL = temp;
                              // });
                              // await getPic("${user.uid}");
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
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}

// class FirestorgeService extends ChangeNotifier {
//   FirestorgeService();
//   static Future<dynamic> loadImage(BuildContext context, String Image) async {
//     return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
//   }
// }
