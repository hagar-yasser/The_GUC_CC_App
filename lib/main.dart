import 'package:flutter/material.dart';
import './dummy_page.dart';
import './image_from_gallery.dart';
import './my_post_screen.dart';
import './saved_screen.dart';
import './view_profile.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: ImageFromGallery(),
      initialRoute: '/',
      routes: {
        '/': (dummyCtx) => Dummy(),
        '/profileRoute': (dummyCtx) => ViewProfile(),
        '/savedRoute': (dummyCtx) => Saved(),
        '/myPostsRoute': (dummyCtx) => MyPosts(),
      },
    );
  }
}
