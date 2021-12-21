import 'package:flutter/material.dart';
import './drawer.dart';
import 'dart:io';
import './image_from_gallery.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';
//import 'package:firebase_storage/firebase_storage.dart';


class ViewProfile extends StatefulWidget {
  @override
  State<ViewProfile> createState() => _ViewProfileState();
}

class _ViewProfileState extends State<ViewProfile> {

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My profile'),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [
         Container(
        padding: EdgeInsets.all(16),
        child:
      SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage("assets/images/Profile Image.png"),
          ),
          Positioned(
              bottom: 0,
              right: -25,
              child: RawMaterialButton(
                onPressed: () {},
                elevation: 2.0,
                fillColor: Color(0xFFF5F6F9),
                child: Icon(Icons.camera_alt_outlined, color: Colors.blue,),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              )),
        ],
      ),
    ),
      ),
           Text("Name"),
         
          Text("Type"),
         
          Text("Major"),
         
          Text("43_XXXX"),
          
        ],
      ),
    );
  }
}
