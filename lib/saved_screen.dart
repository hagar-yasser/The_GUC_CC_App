import 'package:flutter/material.dart';
import './drawer.dart';


class Saved extends StatefulWidget {
  @override
  State<Saved> createState() => _SavedState();
}

class _SavedState extends State<Saved> {
  @override

  Widget build(BuildContext context) {
    //File _image;
    WidgetsFlutterBinding.ensureInitialized();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Posts'),
      ),
      drawer: MainDrawer(),
      body: Center(
        child: Text('Saved page'),
      ),
    );
  }
}
