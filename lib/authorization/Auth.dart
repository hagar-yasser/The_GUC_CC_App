import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:the_guc_cc_app/objects/MyNames.dart';
import 'package:the_guc_cc_app/objects/MyUser.dart';

class Auth {
  final FirebaseAuth auth = FirebaseAuth.instance;
  MyUser? convertFirbaseUser(User? user) {
    if (user == null) {
      return null;
    }
    return MyUser(user.email, user.displayName);
  }

  Future<void> reloadUserData() async {
    print('current auth user is ' + auth.currentUser.toString());
    if (auth.currentUser != null) {
      try {
        await auth.currentUser!.reload();
      } on Exception catch (e) {
        print("couldn't reload currentUser " + e.toString());
      }
    }
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  Stream<MyUser?> get user {
    return auth.authStateChanges().map((User? user) {
      return convertFirbaseUser(user);
    });
  }

  Future<MyUser?> handleSignInEmail(String email, String password) async {
    UserCredential result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    final User user = result.user!;
    return convertFirbaseUser(user);
  }

  User? getCurrentUser() {
    return auth.currentUser;
  }

  Future<void> handleSignUp(email, password, name, userType) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserCredential result = await auth.createUserWithEmailAndPassword(
        email: email, password: password);

    await firestore.collection(myNames.usersTable).doc(result.user!.uid).set({
      myNames.email: email,
      myNames.name: name,
      myNames.savedPostsIDs: [], // Modified
      myNames.type: userType,
    });

    return await result.user!.updateDisplayName(name);
  }

  void printCurrentUserEmail() {
    if (auth.currentUser != null) {
      print(convertFirbaseUser(auth.currentUser)!.email);
    } else {
      print("no current user");
    }
  }

  Future<void> signOut() async {
    final fbm = FirebaseMessaging.instance;
    fbm.unsubscribeFromTopic("CC");
    return await auth.signOut();
  }
}
