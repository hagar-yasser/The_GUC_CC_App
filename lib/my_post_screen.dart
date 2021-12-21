import 'package:flutter/material.dart';
import './drawer.dart';
import 'dart:io';


class MyPosts extends StatefulWidget {
  @override
  State<MyPosts> createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  @override

  Widget build(BuildContext context) {
    //File _image;
    WidgetsFlutterBinding.ensureInitialized();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('My posts'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('MY POSTS PAGE'),
      ),
    );
  }
}
