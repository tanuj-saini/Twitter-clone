import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/bottomNevigationBar.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/comments/CommentsMdoel.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/userInfo.dart';
import 'package:uuid/uuid.dart';

final authRepositry = Provider((ref) => AuthRepositry(
    firebaseAuth: FirebaseAuth.instance,
    firebaseFirestore: FirebaseFirestore.instance));

class AuthRepositry {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;

  AuthRepositry({required this.firebaseAuth, required this.firebaseFirestore});

  void LoginUser(String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => UserInfoScreen()));
    } on FirebaseException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  Future<UserModel?> getUserDetails() async {
    var userData = await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser?.uid)
        .get();
    UserModel? user;
    if (userData.data() != null) {
      user = UserModel.fromMap(userData.data()!);
    }

    return user;
  }

  void SignInUser(String email, String password, BuildContext context) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => BottomScreen(
                userID: firebaseAuth.currentUser!.uid,
              )));
    } on FirebaseException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  Stream<UserModel> GetCureentUsserDetails() {
    return firebaseFirestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Stream<UserModel> getUserModel(String uid) {
    return firebaseFirestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((event) => UserModel.fromMap(event.data()!));
  }

  Stream<List<TweetModel>> getUserProfileTweet({required UserModel userModel}) {
    return firebaseFirestore
        .collection('Tweet')
        .where('UserId', isEqualTo: userModel.UserID)
        .snapshots()
        .map((event) {
      List<TweetModel> tweets = [];
      for (var document in event.docs) {
        TweetModel tweetss = TweetModel.fromMap(document.data());
        tweets.add(tweetss);
      }
      return tweets;
    });
  }

  Future addUnionFollow(
      {required String uid, required UserModel userModel}) async {
    await firebaseFirestore.collection("users").doc(userModel.UserID).update({
      "followers": FieldValue.arrayUnion([uid]),
    });
  }

  Future removeUnionFollow(
      {required String uid, required UserModel userModel}) async {
    await firebaseFirestore.collection("users").doc(userModel.UserID).update({
      "followers": FieldValue.arrayRemove([uid]),
    });
  }

  Future adUnionLikes(
      {required String uid, required TweetModel tweetModel}) async {
    await firebaseFirestore.collection("users").doc(tweetModel.UserId).update({
      "likes": FieldValue.arrayUnion([uid]),
    });
  }

  Future removeUnionLikes(
      {required String uid, required TweetModel tweetModel}) async {
    await firebaseFirestore.collection("users").doc(tweetModel.UserId).update({
      "likes": FieldValue.arrayRemove([uid]),
    });
  }

  Stream<TweetModel> getForDisplayTweetDetails({required String PostID}) {
    return firebaseFirestore
        .collection('Tweets')
        .doc(PostID)
        .snapshots()
        .map((event) => TweetModel.fromMap(event.data()!));
  }

  Stream<List<UserModel>> UserName(String queue) {
    return firebaseFirestore
        .collection('users')
        .where('name',
            isGreaterThanOrEqualTo: queue.isEmpty ? 0 : queue,
            isLessThan: queue.isEmpty
                ? null
                : queue.substring(0, queue.length - 1) +
                    String.fromCharCode(
                      queue.codeUnitAt(queue.length - 1) + 1,
                    ))
        .snapshots()
        .map((event) {
      List<UserModel> commuinties = [];
      for (var document in event.docs) {
        var commuinty = UserModel.fromMap(document.data());
        commuinties.add(commuinty);
      }
      return commuinties;
    });
  }

  Future logOutUSer(BuildContext context) async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      showSnackBar(e.message!, context);
    }
  }

  Future editUserProfile(UserModel userModel) async {
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .update(userModel.toMap());
  }

  void sendToFirebaseTweet(
      {required TweetModel tweetModel, required String tweetId}) async {
    await firebaseFirestore
        .collection('Tweet')
        .doc(tweetId)
        .set(tweetModel.toMap());
  }

  Stream<List<TweetModel>> getAllTweet() {
    return firebaseFirestore.collection('Tweet').snapshots().map((event) {
      final List<TweetModel> tweetModel = [];
      for (var document in event.docs) {
        tweetModel.add(TweetModel.fromMap(document.data()));
      }
      return tweetModel;
    });
  }

  // Stream<List<TweetModel>> getTweetNotificationDetals(
  //     {required UserModel Userodel}) {
  //   return firebaseFirestore
  //       .collection('Tweet')
  //       .doc("")
  //       .collection("Comments")
  //       .where("SendToUserName", isEqualTo: Userodel.name)
  //       .snapshots()
  //       .map((event) {
  //     List<TweetModel> tweet = [];
  //     for (var document in event.docs) {
  //       TweetModel teweet = TweetModel.fromMap(document.data());
  //       tweet.add(teweet);
  //     }
  //     return tweet;
  //   });
  // }

  void triggerNotification(
      {required String Useruid, required String commment}) async {
    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: "notification",
            wakeUpScreen: true,
            title: commment));
  }

  void sendCommentsDetailsToFirebase(
      {required String Postid,
      required String docId,
      required CommetsModel commetsModel}) async {
    await firebaseFirestore
        .collection("Tweet")
        .doc(Postid)
        .collection("Comments")
        .doc(docId)
        .set(commetsModel.toMap());
  }

  Stream<List<CommetsModel>> getCommentsDetails({required String PostId}) {
    return firebaseFirestore
        .collection("Tweet")
        .doc(PostId)
        .collection("Comments")
        .snapshots()
        .map((event) {
      List<CommetsModel> commet = [];
      for (var document in event.docs) {
        CommetsModel comme = CommetsModel.fromMap(document.data());
        commet.add(comme);
      }
      return commet;
    });
  }

  void setDeetailsToFirebase(UserModel user, BuildContext context) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .set(user.toMap());
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => BottomScreen(
                userID: firebaseAuth.currentUser!.uid,
              )));
    } on FirebaseException catch (e) {
      showSnackBar(e.message!, context);
    }
  }
}
