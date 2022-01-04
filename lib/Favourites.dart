// hasValues
//     ?
//     ?
// StreamBuilder<QuerySnapshot>(
//     stream:
//         FirebaseFirestore.instance.collection("Users").snapshots(),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting
//           // ||
//           //     !hasValues
//           )
//         return Center(
//           child: CircularProgressIndicator(),
//         );

//       var usersDocs = snapshot.data!.docs;
//       QueryDocumentSnapshot<Object?> currUserDoc = usersDocs
//           .firstWhere((doc) => (doc.id == currentUser!.uid));
//       List<dynamic> fav = (currUserDoc.data()
//               as Map<String, dynamic>)['savedPostsIDs']
//           as List<dynamic>;
//       print(fav);
//       return StreamBuilder<QuerySnapshot>(
//           stream: FirebaseFirestore.instance
//               .collection("posts")
//               .where(FieldPath.documentId, whereIn: fav)
//               // .orderBy("date", descending: true)
//               .snapshots(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting)
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             // if (snapshot.connectionState == ConnectionState.waiting)
//             //   return Center(
//             //     child: CircularProgressIndicator(),
//             //   );
//             var postDataDoc = snapshot.data!.docs;
//             return ListView.builder(
//                 itemCount: postDataDoc.length,
//                 itemBuilder: (context, index) {
//                   var postDocAccessible = postDataDoc[index].data()
//                       as Map<String, dynamic>;
//                   var postDocID = postDataDoc[index].id;
//                   // print(postDocAccessible["userID:"]);
//                   getPostAuthor(
//                       postDocAccessible["userID"] as String);
//                   return Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5)),
//                     margin: EdgeInsets.all(5),
//                     child: Column(
//                       children: [
//                         authorDataUI(
//                             context,
//                             postDocID,
//                             (postDocAccessible["date"] as Timestamp)
//                                 .toDate(),
//                             postDocAccessible["userName"]),
//                         // authorDataUI(
//                         //     context,
//                         //     postDocID,
//                         //     (postDocAccessible["date"] as Timestamp)
//                         //         .toDate(),
//                         //     "Ano."),
//                         PostContentContainer(
//                             context, postDocAccessible),
//                         (postDocAccessible['vote'] as bool)
//                             ? readOptions(
//                                 (postDocAccessible["options"]
//                                     as Map<String, dynamic>),
//                                 postDocID)
//                             : Container(
//                                 height: 0,
//                               )
//                       ],
//                     ),
//                   );
//                   // return SinglePost(
//                   //     postDocAccessible: postDocAccessible,
//                   //     postDocID: postDocID,
//                   //     PostContentContainer: PostContentContainer,
//                   //     authorDataUI: authorDataUI,
//                   //     readOptions: readOptions);
//                 });
//           });
// });
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'AddNormalPostForm.dart';
import 'SinglePost.dart';
import 'authorization/Auth.dart';

class Favourites extends StatefulWidget {
  const Favourites({Key? key}) : super(key: key);
  static const String FavourtiesRoute = "/favourites";

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  User? currentUser;
  List<Map<String, dynamic>> postData = [];
  List<String> postIds = [];
  List<String> postsAuthors = [];
  bool hasValues = false;
  Map<String, dynamic> options = {};
  Provider<Auth>? authProvider;
  String postAuthorName = "Anomynous";
  String optionsSelected = "";
  List<dynamic> savedPosts = [];
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

  Future<void> savePostForLater(String postId, BuildContext context) {
    String msgText = "";
    if (!savedPosts.contains(postId)) {
      setState(() {
        savedPosts.add(postId);
      });
      msgText = "Succssfully added to 'Save for later'";
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"savedPostsIDs": savedPosts}).then((value) {
        final snackbar = SnackBar(content: Text(msgText));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }).catchError((error) => print(error));
    } else {
      setState(() {
        savedPosts.remove(postId);
      });
      msgText = "Succssfully removed to 'Save for later'";
      return FirebaseFirestore.instance
          .collection('Users')
          .doc(currentUser!.uid)
          .update({"savedPostsIDs": savedPosts}).then((value) {
        final snackbar = SnackBar(content: Text(msgText));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }).catchError((error) => print(error));
    }
  }

  Future<void> getSavedPosts() {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot ds) {
      Map<String, dynamic> userData = ds.data() as Map<String, dynamic>;
      // print(userData);
      savedPosts = userData['savedPostsIDs'] as List<dynamic>;
    });
  }

  @override
  void initState() {
    final authProvider = Provider.of<Auth>(context, listen: false);
    currentUser = authProvider.getCurrentUser();
    imageURL = (currentUser?.photoURL ??
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS7v5zeGFeNpO89fHd0XbafbNcilJVqTe8aUA&usqp=CAU');
    // print(currentUser);
    // setState(() {
    // getSavedPosts();
    // });
    // readAllPosts();
    readAllSavedPosts();
    // TODO: implement initState
    super.initState();
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

  //For the post author's name and pic
  Widget authorDataUI(BuildContext context, String postId, DateTime postDate,
      String postAuthor, String postAuthorId) {
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
                          })),
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
                    icon: Icon(
                      Icons.bookmark,
                      color: Colors.red[900],
                    ))
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
      return '${duration.inMinutes}min ago';
    }
    return "Just now";
  }

  Widget readOptions(Map<String, dynamic> options, String postId) {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return Container(
              padding: EdgeInsets.all(8),
              child: ListTile(
                title: Text(options.keys.elementAt(index)),
                leading: Radio<dynamic>(
                  value: options.values.elementAt(index),
                  groupValue: null,
                  onChanged: ((val) => changeVote(val as String, postId)),
                ),
                trailing: Text('${options.length}'),
              ),
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
        // print(qs.id);
        Map<String, dynamic> postData = qs.data() as Map<String, dynamic>;
        // print(postData);
        postOptions = postData['options'] as Map<String, dynamic>;
        // print(postOptions);
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

  Future<void> readAllSavedPosts() async {
    return FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUser!.uid)
        .get()
        .then((DocumentSnapshot ds) {
      // print(ds.data());
      setState(() {
        savedPosts = (ds.data() as Map<String, dynamic>)['savedPostsIDs']
            as List<dynamic>;
      });
    }).catchError((error) => print(error));
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<Auth>(context);
    User? user = auth.getCurrentUser();

    CollectionReference users = FirebaseFirestore.instance.collection('Users');

    return Scaffold(
        appBar: AppBar(
          title: const Text("Saved Posts"),
        ),
        body: FutureBuilder<DocumentSnapshot>(
            future: users.doc(user!.uid).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data!.exists) {
                return Text("Document does not exist");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                print("saved posts: ${data['savedPostsIDs'].length} ");
                if (data['savedPostsIDs'].length == 0) {
                  return Center(
                    child: Text("No Favourite Posts"),
                  );
                } else {
                  return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("posts")
                          .where(FieldPath.documentId,
                              whereIn: data['savedPostsIDs'])
                          // .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        // if (snapshot.connectionState == ConnectionState.waiting)
                        //   return Center(
                        //     child: CircularProgressIndicator(),
                        //   );
                        var postDataDoc = snapshot.data!.docs;
                        return ListView.builder(
                            itemCount: postDataDoc.length,
                            itemBuilder: (context, index) {
                              var postDocAccessible = postDataDoc[index].data()
                                  as Map<String, dynamic>;
                              var postDocID = postDataDoc[index].id;
                              // print(postDocAccessible["userID:"]);
                              getPostAuthor(
                                  postDocAccessible["userID"] as String);
                              return Card(
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    authorDataUI(
                                        context,
                                        postDocID,
                                        (postDocAccessible["date"] as Timestamp)
                                            .toDate(),
                                        postDocAccessible["userName"],
                                        postDocAccessible["userID"] as String),
                                    // authorDataUI(
                                    //     context,
                                    //     postDocID,
                                    //     (postDocAccessible["date"] as Timestamp)
                                    //         .toDate(),
                                    //     "Ano."),
                                    PostContentContainer(
                                        context, postDocAccessible),
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
                      });
                }
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            })

        // return (Text("done"));

        // : Center(
        //     child: Text("No Favourite Posts"),
        //   )
        // : Center(child: Text("No Posts added to Favorites"))
        );
  }
}
