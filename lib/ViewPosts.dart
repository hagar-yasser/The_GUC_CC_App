import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddNormalPostForm.dart';
import 'authorization/Auth.dart';

class ViewPosts extends StatefulWidget {
  const ViewPosts({Key? key}) : super(key: key);
  static const String ViewPostsRoute = "/viewposts";

  @override
  _ViewPostsState createState() => _ViewPostsState();
}

class _ViewPostsState extends State<ViewPosts> {
  User? currentUser;
  List<Map<String, dynamic>> postData = [];
  List<String> postIds = [];
  List<String> postsAuthors = [];
  bool hasValues = false;
  Map<String, dynamic> options = {};
  Provider<Auth>? authProvider;
  String postAuthorName = "Anomynous";
  String optionsSelected = "";

  Future<void> readAllPosts() {
    return FirebaseFirestore.instance
        .collection('posts')
        .get()
        .then((QuerySnapshot qs) {
      setState(() {
        qs.docs.forEach((doc) {
          postIds.add(doc.id);
          postData.add(doc.data() as Map<String, dynamic>);
          hasValues = true;
        });
      });
    }).catchError((error) => print(error));
  }

  Future<void> savePostForLater(String postId, BuildContext context) {
    return FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: currentUser!.email)
        .get()
        .then((QuerySnapshot qs) {
      setState(() {
        qs.docs.forEach((doc) {
          List<String> newPostsId = doc.data() as List<String>;
          newPostsId.add(postId);
          FirebaseFirestore.instance
              .collection('Users')
              .doc(doc.id)
              .update({'savesPostsIDs': newPostsId}).then((value) {
            final snackbar =
                SnackBar(content: Text("Added to 'Saved for Later'"));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          });
        });
      });
    }).catchError((error) => print(error));
  }

  @override
  void initState() {
    final authProvider = Provider.of<Auth>(context, listen: false);
    currentUser = authProvider.getCurrentUser();
    print(currentUser);
    readAllPosts();
    // TODO: implement initState
    super.initState();
  }

  //For the post author's name and pic
  Widget authorDataUI(BuildContext context, String postId, DateTime postDate,
      String postAuthor) {
    const double avatarDiameter = 44;
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return GestureDetector(
            child: Row(
              children: [
                Expanded(
                    child: Row(children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Container(
                      width: avatarDiameter,
                      height: avatarDiameter,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(avatarDiameter / 2),
                          child: Image.network(
                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7v5zeGFeNpO89fHd0XbafbNcilJVqTe8aUA&usqp=CAU') //TODO: Should be changed with the user pic
                          ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        postAuthor,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        calculatePostDate(postDate),
                        style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.grey),
                      ),
                    ],
                  )
                ])),
                IconButton(
                    onPressed: () => savePostForLater(postId, context),
                    icon: Icon(Icons.bookmark))
              ],
            ),
          );
        });
  }

  Widget PostContentContainer(BuildContext context, Map<String, dynamic> post) {
    // return Container(child: Column(children: [Text(post['title'] as String),Text(post['body'] as String), post['vote'] as bool?Column(children: post['options'],):Container(height:0)],),);
    return Container(
      margin: EdgeInsets.all(MediaQuery.of(context).size.width / 18),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            post['title'] as String,
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          Text(
            post['body'] as String,
            style: TextStyle(fontWeight: FontWeight.w200, fontSize: 15),
          )
        ],
      ),
    );
  }

  Future<void> getPostAuthor(String postUserId) {
    return FirebaseFirestore.instance
        .collection('Users')
        .get()
        .then((QuerySnapshot qs) {
      // String postAuthorName = "Anomynous";
      qs.docs.forEach((doc) {
        Map<String, dynamic> usersDataTemp = doc.data() as Map<String, dynamic>;
        String currUserID = usersDataTemp["userID"] as String;
        if (currUserID == postUserId) {
          postAuthorName = usersDataTemp["name"] as String;
        }
      });
      // return postAuthorName;
    }).catchError((error) => print(error));
  }

  String calculatePostDate(DateTime postDate) {
    Duration duration = DateTime.now().difference(postDate);
    if (duration.inDays >= 1) {
      return '${duration.inDays}d ago';
    } else if (duration.inHours >= 1) {
      return '${duration.inHours}h ago';
    } else if (duration.inMinutes >= 1) {
      return '${duration.inHours}min ago';
    }
    return "Just now";
  }

  Widget readOptions(Map<String, dynamic> options, String postId) {
    return Container(
      height: 100,
      child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(options.keys.elementAt(index)),
              leading: Radio<dynamic>(
                value: options.values.elementAt(index),
                groupValue: null,
                onChanged: ((val) => changeVote(val as String, postId)),
              ),
              trailing: Text('${options.length}'),
            );
          }),
    );
  }

  Future<void> changeVote(String newOption, String postId) async {
    setState(() {
      optionsSelected = newOption;
      Map<String, dynamic> postOptions = new Map();
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .get()
          .then((DocumentSnapshot qs) {
        print(qs.id);
        Map<String, dynamic> postData = qs.data() as Map<String, dynamic>;
        print(postData);
        postOptions = postData['options'] as Map<String, dynamic>;
        print(postOptions);
        postOptions.forEach((key, value) {
          if ((value as List<String>).contains(currentUser!.uid)) {
            (value as List<String>).remove(currentUser!.uid);
          }
          if (key == newOption) {
            (value as List<String>).add(currentUser!.uid);
          }
        });
      }).catchError((error) => print(error));
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({'options': postOptions});
    });
  }

  @override
  Widget build(BuildContext context) {
    var postData = FirebaseFirestore.instance
        .collection("posts")
        .orderBy("date", descending: true);
    var postDataStream = postData.snapshots();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .pushNamed(NormalPostForm.NormalPostFormRoute),
        ),
        body: hasValues
            ? StreamBuilder<QuerySnapshot>(
                stream: postDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  var postDataDoc = snapshot.data!.docs;
                  return ListView.builder(
                      itemCount: postDataDoc.length,
                      itemBuilder: (context, index) {
                        var postDocAccessible =
                            postDataDoc[index].data() as Map<String, dynamic>;
                        var postDocID = postDataDoc[index].id;
                        // print(postDocAccessible["userID:"]);
                        // getPostAuthor(postDocAccessible["userID:"] as String);
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                          margin: EdgeInsets.all(5),
                          child: Column(
                            children: [
                              // authorDataUI(
                              //     context,
                              //     postDocID,
                              //     (postDocAccessible["date"] as Timestamp)
                              //         .toDate(),
                              //     postDocAccessible["userName"]),
                              authorDataUI(
                                  context,
                                  postDocID,
                                  (postDocAccessible["date"] as Timestamp)
                                      .toDate(),
                                  "Ano."),
                              PostContentContainer(context, postDocAccessible),
                              (postDocAccessible['vote'] as bool)
                                  ? readOptions(
                                      (postDocAccessible["options"]
                                          as Map<String, dynamic>),
                                      postDocID)
                                  : Container(
                                      height: 0,
                                    )
                            ],
                          ),
                        );
                      });
                })
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
