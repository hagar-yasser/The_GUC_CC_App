import 'package:flutter/material.dart';
import './image_from_gallery.dart';

class MainDrawer extends StatelessWidget {
  @override
  navigateToProfile(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/profileRoute',
    );
    // arguments: {'category': cat});
  }

  navigateToSaved(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/savedRoute',
    );
    // arguments: {'category': cat});
  }

  navigateToMyPosts(BuildContext myContext) {
    Navigator.of(myContext).pushNamed(
      '/myPostsRoute',
    );
    // arguments: {'category': cat});
  }


  
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            padding: EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Colors.blue,
            child: Text(
              'My Profile',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                  color: Colors.white),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              height: 115,
              width: 115,
              child: Stack(
                clipBehavior: Clip.none,
                fit: StackFit.expand,
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/Profile Image.png"),
                  ),
                  // Positioned(
                  //     bottom: 0,
                  //     right: -25,
                  //     child: RawMaterialButton(
                  //       onPressed: () {},
                  //       elevation: 2.0,
                  //       fillColor: Color(0xFFF5F6F9),
                  //       child: Icon(
                  //         Icons.camera_alt_outlined,
                  //         color: Colors.blue,
                  //       ),
                  //       padding: EdgeInsets.all(15.0),
                  //       shape: CircleBorder(),
                  //     )),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            child: ElevatedButton(
              child: Text("View Profile",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.blue[400])),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
              onPressed: () => navigateToProfile(context), //function
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            child: ElevatedButton(
              child: Text("View My Posts",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.blue[400])),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
              onPressed:() => navigateToMyPosts(context), //function
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            child: ElevatedButton(
              child: Text("View Saved Posts",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.blue[400])),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
              onPressed: () => navigateToSaved(context), //function
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            child: ElevatedButton(
              child: Text("Logout",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15,
                      color: Colors.blue[400])),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.grey[200]),
              ),
              onPressed: () {}, //function
            ),
          ),
        ],
      ),
    );
  }
}
