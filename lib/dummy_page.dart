import 'package:flutter/material.dart';
import './drawer.dart';
import 'dart:io';


class Dummy extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    //File _image;
    WidgetsFlutterBinding.ensureInitialized();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Dummy page'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('This page is to test the drawer c'),
      ),
    );
  }
}
