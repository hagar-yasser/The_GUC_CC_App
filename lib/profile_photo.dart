import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePhoto extends StatefulWidget {
  const ProfilePhoto({Key? key}) : super(key: key);

  @override
  _ProfilePhotoState createState() => _ProfilePhotoState();
}

class _ProfilePhotoState extends State<ProfilePhoto> {
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
    String url = "";
    try {
      Reference ref = storage.ref().child(path);
      url = await ref.getDownloadURL();
    } on Exception catch (e) {
      url =
          "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344";
    }
    return url;
  }

  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    return FutureBuilder<String>(
        future: getPic("${user!.uid}"),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          print("photo");
          print("snapshot");
          print(snapshot);
          // print(snapshot.data);
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        // backgroundImage: NetworkImage(
                        //     "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344"),
                        backgroundImage: AssetImage('assets/images/avatar.png'),
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (snapshot.connectionState == ConnectionState.done) {
            String data = snapshot.data as String;
            return Container(
              alignment: Alignment.center,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(data),
                        backgroundColor: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return Container(
            alignment: Alignment.center,
            child: Container(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 100,
                width: 100,
                child: Stack(
                  clipBehavior: Clip.none,
                  fit: StackFit.expand,
                  children: [
                    CircleAvatar(
                      // backgroundImage: NetworkImage(
                      //     "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344"),
                      backgroundImage: AssetImage('assets/images/avatar.png'),
                      backgroundColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
