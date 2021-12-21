import 'package:flutter/material.dart';
import './drawer.dart';
import 'dart:io';
import './image_from_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {
  var _image;
  var imagePicker;

  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My profile'),
      ),
      drawer: MainDrawer(),
      body: Container(
        alignment: Alignment.center,
        // child: GestureDetector(
        //    onTap: () async {
        //     var source = ImageSource.gallery;
        //     XFile image = await imagePicker.pickImage(
        //         source: source,
        //         imageQuality: 50,
        //         preferredCameraDevice: CameraDevice.front);
        //    },
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
                        backgroundImage:
                            AssetImage("assets/images/Profile Image.png"),
                      ),
                      Positioned(
                          bottom: 0,
                          right: -25,
                          child: RawMaterialButton(
                            onPressed: () async {
                              var source = ImageSource.gallery;
                              XFile image = await imagePicker.pickImage(
                                  source: source,
                                  imageQuality: 50,
                                  preferredCameraDevice: CameraDevice.front);

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
            ),
            Text("Name",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.blue[400])),

                    SizedBox(height: 10),
            Text("Type",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.blue[400])),

                    SizedBox(height: 10),
            Text("Major",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.blue[400])),


                    SizedBox(height: 10),
            Text("43-XXXX",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                    color: Colors.blue[400])),

                    SizedBox(height: 10),
          ],
        ),
      ),
      //  ),
    );
  }
}
