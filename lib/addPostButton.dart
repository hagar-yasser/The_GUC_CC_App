import 'package:flutter/material.dart';

class addPostButton extends StatefulWidget {
  const addPostButton({Key? key}) : super(key: key);

  @override
  _addPostButtonState createState() => _addPostButtonState();
}

class _addPostButtonState extends State<addPostButton> {
  bool pressed = false;
  @override
  Widget build(BuildContext context) {
    double left = 0.5 * MediaQuery.of(context).size.width;
    double top = 0.7 * (MediaQuery.of(context).size.height);
    return Stack(children: [
      AnimatedPositioned(
          top: pressed
              ? 3 * MediaQuery.of(context).size.height / 5
              : 3.85 * MediaQuery.of(context).size.height / 5,
          left: 3.45 * MediaQuery.of(context).size.width / 5,
          child: ElevatedButton(
            child: Text("Normal"),
            onPressed: () {
              Navigator.of(context).pushNamed("/NormalPostForm");
            },
          ),
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn),
      AnimatedPositioned(
          top: pressed
              ? 3.35 * MediaQuery.of(context).size.height / 5
              : 3.85 * MediaQuery.of(context).size.height / 5,
          left: 3.5 * MediaQuery.of(context).size.width / 5,
          child: ElevatedButton(
            child: Text("Voting"),
            onPressed: () {
              Navigator.of(context).pushNamed("/VotingPostForm");
            },
          ),
          duration: Duration(seconds: 2),
          curve: Curves.fastOutSlowIn),
      Positioned(
        top: 3.85 * MediaQuery.of(context).size.height / 5,
        left: 3 * MediaQuery.of(context).size.width / 5,
        child: FloatingActionButton.extended(
          onPressed: () {
            setState(() {
              pressed = !pressed;
            });

            // Add your onPressed code here!
          },
          label: const Text('Add Post'),
          icon: const Icon(Icons.post_add),
          backgroundColor: Colors.amber,
        ),
      ),
    ]);
  }
}
