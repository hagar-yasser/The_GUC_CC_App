import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import './dummy_page.dart';
import './my_post_screen.dart';
import './saved_screen.dart';
import './view_profile.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/Signing.dart';
import 'package:the_guc_cc_app/authorization/Auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Auth>(
          create: (_) => Auth(),
        ),
      ],
      child: MaterialApp(routes: {
        Signing.routeName: (context) => Signing(),
       '/': (dummyCtx) => Dummy(),
        '/profileRoute': (dummyCtx) => ViewProfile(),
        '/savedRoute': (dummyCtx) => Saved(),
        '/myPostsRoute': (dummyCtx) => MyPosts(),
      }, 
      title: 'The GUC CC App',
      // home: Wrapper()
       ),
    );
  }
}
