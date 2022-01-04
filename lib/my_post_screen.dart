import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_guc_cc_app/SinglePost.dart';
import 'package:the_guc_cc_app/addPostButton.dart';
import 'package:the_guc_cc_app/drawer.dart';
import 'AddNormalPostForm.dart';
import 'authorization/Auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class MyPosts extends StatefulWidget {
  const MyPosts({Key? key}) : super(key: key);
  static const String ViewPostsRoute = "/viewposts";

  @override
  _MyPostsState createState() => _MyPostsState();
}

class _MyPostsState extends State<MyPosts> {
  String URL = "";
  User? currentUser;
  List<Map<String, dynamic>> postData = [];
  List<String> postIds = [];
  List<String> postsAuthors = [];
  bool hasValues = false;
  Map<String, dynamic> options = {};
  Provider<Auth>? authProvider;
  String postAuthorName = "Anomynous";
  String optionsSelected = "";
  var pressed = false;
  List<dynamic> savedPostsIDs = [];
  String imageURL = "";

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

  Future<void> readAllSavedPosts() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot ds) {
      print(ds.data());
      setState(() {
        savedPostsIDs = (ds.data() as Map<String, dynamic>)['savedPostsIDs']
            as List<dynamic>;
      });
    }).catchError((error) => print(error));
  }

  Future<void> savePostForLater(String postId, BuildContext context) {
    String msgText = "";
    if (!savedPostsIDs.contains(postId)) {
      setState(() {
        savedPostsIDs.add(postId);
      });
      msgText = "Succssfully added to 'Save for later'";
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"savedPostsIDs": savedPostsIDs}).then((value) {
        final snackbar = SnackBar(content: Text(msgText));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }).catchError((error) => print(error));
    } else {
      setState(() {
        savedPostsIDs.remove(postId);
      });
      msgText = "Succssfully removed to 'Save for later'";
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"savedPostsIDs": savedPostsIDs}).then((value) {
        final snackbar = SnackBar(content: Text(msgText));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }).catchError((error) => print(error));
    }
  }

  Future<String> getPic(String path) async {
    print("getting picture");
    FirebaseStorage storage = FirebaseStorage.instance;
    String url = "";
    try {
      Reference ref = storage.ref().child(path);
      url = await ref.getDownloadURL();
    } on Exception catch (e) {
      url =
          "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344";
    }
    return url;
  }

  @override
  void initState() {
    final authProvider = Provider.of<Auth>(context, listen: false);
    currentUser = authProvider.getCurrentUser();
    print(currentUser);
    readAllPosts();
    readAllSavedPosts();
    imageURL = (currentUser?.photoURL ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7v5zeGFeNpO89fHd0XbafbNcilJVqTe8aUA&usqp=CAU');
    // TODO: implement initState
    super.initState();
  }

  //For the post author's name and pic
  Widget authorDataUI(
      BuildContext context,
      String postId,
      DateTime postDate,
      String postAuthor,
      String postAuthorId,
      bool vote,
      Map<String, dynamic> postBody) {
    const double avatarDiameter = 44;
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return FutureBuilder(
        future: users.doc(user!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }
          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            String type = data['type'];

            return GestureDetector(
              child: Row(
                children: [
                  Expanded(
                      child: Row(children: [
                    Padding(
                        padding: const EdgeInsets.all(8),
                        child: FutureBuilder<String>(
                            future: getPic(postAuthorId),
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              print("photo");
                              print("snapshot");
                              print(snapshot);
                              // print(snapshot.data);
                              if (snapshot.hasError) {
                                return Text("Something went wrong");
                              }
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          CircleAvatar(
                                            // backgroundImage: NetworkImage(
                                            //     "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344"),
                                            backgroundImage: AssetImage(
                                                'assets/images/avatar.png'),
                                            backgroundColor: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                String data = snapshot.data as String;
                                return Container(
                                  alignment: Alignment.center,
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    child: SizedBox(
                                      height: 50,
                                      width: 50,
                                      child: Stack(
                                        clipBehavior: Clip.none,
                                        fit: StackFit.expand,
                                        children: [
                                          CircleAvatar(
                                            backgroundImage: NetworkImage(data),
                                            backgroundColor: Colors.grey[300],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return Container(
                                alignment: Alignment.center,
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  child: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      fit: StackFit.expand,
                                      children: [
                                        CircleAvatar(
                                          // backgroundImage: NetworkImage(
                                          //     "https://firebasestorage.googleapis.com/v0/b/the-guc-cc-app.appspot.com/o/avatar.png?alt=media&token=d41dedeb-8632-4ff1-b4d3-65dc9ec2a344"),
                                          backgroundImage: AssetImage(
                                              'assets/images/avatar.png'),
                                          backgroundColor: Colors.grey[300],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            })
                        //  Container(
                        //   width: avatarDiameter,
                        //   height: avatarDiameter,
                        //   decoration: BoxDecoration(
                        //     color: Colors.blue,
                        //     shape: BoxShape.circle,
                        //   ),
                        //   child: ClipRRect(
                        //       borderRadius:
                        //           BorderRadius.circular(avatarDiameter / 2),
                        //       child: Image.network(imageURL)),
                        // ),

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
                  (type.compareTo("Normal Student") == 0)
                      ? Container()
                      : IconButton(
                          onPressed:
                              // () => vote
                              //     ? Navigator.of(context)
                              //         .pushNamed("/NormalPostForm", arguments: postBody)
                              //     : Navigator.of(context)
                              //         .pushNamed("/VotingPostForm", arguments: postBody),
                              () {
                            var fire = FirebaseFirestore.instance
                                .collection('posts')
                                .doc(postId)
                                .delete()
                                .catchError((error) {
                              return showDialog<Null>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                        title:
                                            const Text("An error occurred !"),
                                        content: Text(error.toString()),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: const Text('Okay'))
                                        ],
                                      ));
                            });
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          )),
                  IconButton(
                      onPressed: () => savePostForLater(postId, context),
                      icon: Icon(
                        savedPostsIDs.contains(postId)
                            ? Icons.bookmark
                            : Icons.bookmark_border_outlined,
                        color: Colors.red[900],
                      )),
                  (type.compareTo("Normal Student") == 0)
                      ? Container()
                      : !vote
                          ? IconButton(
                              onPressed: () {
                                if (!vote) {
                                  postBody['id'] = postId;
                                  Navigator.of(context).pushNamed(
                                      "/NormalPostForm",
                                      arguments: postBody);
                                }
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Colors.black,
                              ))
                          : Container()
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
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
      return '${duration.inMinutes}min ago';
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
                value: options.keys.elementAt(index),
                groupValue: null,
                onChanged: ((val) =>
                    changeVote(val as String, postId, options)),
              ),
              trailing: Text((options.values.elementAt(index).length == 0)
                  ? '0'
                  : '${(options.values.elementAt(index) as List<dynamic>).length}'),
            );
          }),
    );
  }

  Future<void> changeVote(
      String newOption, String postId, Map<String, dynamic> options) async {
    // setState(() {
    //   optionsSelected = newOption;
    //   Map<String, List<dynamic>> postOptions = new Map();
    //   FirebaseFirestore.instance
    //       .collection('posts')
    //       .doc(postId)
    //       .get()
    //       .then((DocumentSnapshot qs) {
    //     print(qs.data());
    //     Map<String, dynamic> postData = qs.data() as Map<String, dynamic>;
    //     // print(postData);
    //     postOptions = postData['options'] as Map<String, List<dynamic>>;
    //     // print(postOptions);
    //     postOptions.forEach((key, value) {
    //       if ((value as List<dynamic>).contains(currentUser!.uid)) {
    //         (value as List<dynamic>).remove(currentUser!.uid);
    //       }
    //       if (key == newOption) {
    //         (value as List<dynamic>).add(currentUser!.uid);
    //       }
    //     });
    //   }).catchError((error) => print(error));
    //   FirebaseFirestore.instance
    //       .collection('posts')
    //       .doc(postId)
    //       .update({'options': postOptions});
    // });

    setState(() {
      options.forEach((key, value) {
        if ((value as List<dynamic>).contains(currentUser!.uid)) {
          (value as List<dynamic>).remove(currentUser!.uid);
        }
        if (key == newOption) {
          (value as List<dynamic>).add(currentUser!.uid);
        }
      });
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .update({'options': options});
    });
  }

  @override
  Widget build(BuildContext context) {
    // readAllSavedPosts();
    print(savedPostsIDs);
    var postData = FirebaseFirestore.instance
        .collection("posts")
        .orderBy("date", descending: true);
    var postDataStream = postData.snapshots();
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();
    CollectionReference users = FirebaseFirestore.instance.collection('Users');
    return Scaffold(
        drawer: MainDrawer(),
        appBar: AppBar(
          title: const Text("Home Page"),
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //   onPressed: () {
        //     setState(() {
        //       pressed = !pressed;
        //     });

        //     // Add your onPressed code here!
        //   },
        //   label: const Text('Add Post'),
        //   icon: const Icon(Icons.post_add),
        //   backgroundColor: Colors.amber,
        // ),
        body: hasValues
            ? StreamBuilder<QuerySnapshot>(
                stream: postDataStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  var postDataDoc = snapshot.data!.docs;
                  return Stack(children: [
                    ListView.builder(
                        itemCount: postDataDoc.length,
                        itemBuilder: (context, index) {
                          var postDocAccessible =
                              postDataDoc[index].data() as Map<String, dynamic>;
                          var postDocID = postDataDoc[index].id;
                          String postOwner =
                              postDocAccessible["userID"] as String;
                          if (postOwner.compareTo(user!.uid) != 0) {
                            return Container();
                          }
                          // print(postDocAccessible["userID:"]);
                          getPostAuthor(postDocAccessible["userID"] as String);
                          // return Card(
                          //   elevation: 2,
                          //   shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(5)),
                          //   margin: EdgeInsets.all(5),
                          //   child: Column(
                          //     children: [
                          //       authorDataUI(
                          //           context,
                          //           postDocID,
                          //           (postDocAccessible["date"] as Timestamp)
                          //               .toDate(),
                          //           postDocAccessible["userName"]),
                          //       // authorDataUI(
                          //       //     context,
                          //       //     postDocID,
                          //       //     (postDocAccessible["date"] as Timestamp)
                          //       //         .toDate(),
                          //       //     "Ano."),
                          //       PostContentContainer(
                          //           context, postDocAccessible),
                          //       (postDocAccessible['vote'] as bool)
                          //           ? readOptions(
                          //               (postDocAccessible["options"]
                          //                   as Map<String, dynamic>),
                          //               postDocID)
                          //           : Container(
                          //               height: 0,
                          //             )
                          //     ],
                          //   ),
                          // );
                          return SinglePost(
                            postDocAccessible: postDocAccessible,
                            postDocID: postDocID,
                            PostContentContainer: PostContentContainer,
                            authorDataUI: authorDataUI,
                            readOptions: readOptions,
                            postUserId: postDocAccessible["userID"],
                            vote: postDocAccessible["vote"],
                            postBody: postDocAccessible,
                          );
                        }),

                    // AnimatedPositioned(
                    //     top: pressed
                    //         ? 3 * MediaQuery.of(context).size.height / 5
                    //         : 3.85 * MediaQuery.of(context).size.height / 5,
                    //     left: 3.45 * MediaQuery.of(context).size.width / 5,
                    //     child: ElevatedButton(
                    //       child: Text("Normal"),
                    //       onPressed: () {
                    //         Navigator.of(context).pushNamed("/NormalPostForm");
                    //       },
                    //     ),
                    //     duration: Duration(seconds: 2),
                    //     curve: Curves.fastOutSlowIn),
                    // AnimatedPositioned(
                    //     top: pressed
                    //         ? 3.35 * MediaQuery.of(context).size.height / 5
                    //         : 3.85 * MediaQuery.of(context).size.height / 5,
                    //     left: 3.5 * MediaQuery.of(context).size.width / 5,
                    //     child: ElevatedButton(
                    //       child: Text("Voting"),
                    //       onPressed: () {
                    //         Navigator.of(context).pushNamed("/VotingPostForm");
                    //       },
                    //     ),
                    //     duration: Duration(seconds: 2),
                    //     curve: Curves.fastOutSlowIn),
                  ]);
                })
            : Center(
                child: CircularProgressIndicator(),
              ));
  }
}
