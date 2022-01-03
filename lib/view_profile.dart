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

class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var _image;
  var imagePicker;
  // var i;

  void initState() {
    //i = 0;
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

  Future<String> getPic(String path) async {
    print("getting picture");
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    String url2 = "";
    var file;
    Reference ref = storage.ref().child(path);
    Reference ref2 = storage.ref().child("avatar.png");
    url = ref.getDownloadURL() as String;
    url2 = ref2.getDownloadURL() as String;
    // final name = ref.name;
    print(url);
    if (url == "") {
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

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(user!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        print("ViewProfile snapshot");
        print(snapshot);
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
                  EditProfilePhoto(),
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
          );
        }

        return  Center(
              child: CircularProgressIndicator(),
            );
      },
    );
  }
}
