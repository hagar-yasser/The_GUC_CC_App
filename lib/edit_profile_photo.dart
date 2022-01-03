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
    var file;
    Reference ref = storage.ref().child(path);
    // Reference ref2 = storage.ref().child("avatar.png");
    url = await ref.getDownloadURL();
    //  url2 = await ref2.getDownloadURL();
    final name = ref.name;
    // print("url");
    // print(url);
    // if (url == "") {
    //   file = File(url2);
    // } else {
    file = File(url);
    //  }
    // setState(() {
    //   _image = file;
    //   URL = url;
    // });
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
          print(snapshot.data);
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
                        backgroundImage: NetworkImage(snapshot.data ??
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
                              uploadPic2(File(image.path), "${user.uid}");
                              getPic("${user.uid}");
                              setState(() {
                                _image = File(image.path);
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
                        backgroundImage: NetworkImage(snapshot.data ??
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
                              uploadPic2(File(image.path), "${user.uid}");
                              //getPic("${user.uid}");
                              setState(() {
                                _image = File(image.path);
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
