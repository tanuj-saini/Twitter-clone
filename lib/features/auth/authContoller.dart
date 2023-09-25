import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/bottomNevigationBar.dart';
import 'package:twitter/comman/StorageMethod.dart';
import 'package:twitter/features/Home/HomeScreen.dart';
import 'package:twitter/features/auth/authRepo.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/signUpScreen.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/comments/CommentsMdoel.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/userInfo.dart';
import 'package:uuid/uuid.dart';

final authContollerProvider = StateNotifierProvider<AuthContoller, bool>((ref) {
  final authRepo = ref.watch(authRepositry);
  final Storage = ref.watch(StorageMethodProvider);

  return AuthContoller(
      authRepositry: authRepo, ref: ref, storageMethod: Storage);
});
final listOfUsers = StreamProvider.family((ref, String queue) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.UserName(queue);
});

final USerDetailsFormain = FutureProvider((ref) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserDetails();
});

final getUserTweetForProfile =
    StreamProvider.family((ref, UserModel userModel) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserProfileTweet(userModel: userModel);
});
final getUserTwiitProfile = StreamProvider.family((ref, String uid) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserModel(uid);
});
final getUserModelBottomScreeen = StreamProvider.family((ref, String uid) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getUserModel(uid);
});
final getdetailofTweetDisplay = StreamProvider.family((ref, String PostID) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getForDisplayTweetDetails(PostID: PostID);
});
// final getUSerModeNotifications =
//     StreamProvider.family((ref, UserModel userodel) {
//   final authRepo = ref.watch(authRepositry);
//   return authRepo.getTweetNotificationDetals(Userodel: userodel);
// });

final getCommentsDetails = StreamProvider.family((ref, String PostId) {
  final authRepo = ref.watch(authRepositry);
  return authRepo.getCommentsDetails(PostId: PostId);
});

class AuthContoller extends StateNotifier<bool> {
  final AuthRepositry authRepositry;
  final StorageMethod storageMethod;
  final Ref ref;

  AuthContoller(
      {required this.storageMethod,
      required this.authRepositry,
      required this.ref})
      : super(false);

  void loginInUser(String email, String password, BuildContext context) async {
    state = true;
    authRepositry.LoginUser(email, password, context);

    state = false;
  }

  Stream<List<CommetsModel>> getCommnetsDetaislInNotificcation(
      {required String PostId}) {
    return authRepositry.getCommentsDetails(PostId: PostId);
  }

  void editUserProfile({
    required File? bannerFile,
    required File? profilePhoto,
    required String bio,
    required String name,
    required UserModel userModel,
    required BuildContext context,
  }) async {
    try {
      state = true;
      if (profilePhoto != null) {
        var prof = await storageMethod.uploadFile(
            uid: authRepositry.firebaseAuth.currentUser!.uid,
            context: context,
            childname: "Profile/",
            file: profilePhoto);
        userModel = userModel.copyWith(USerPhotoUrl: prof);
      }
      if (bannerFile != null) {
        var banner = await storageMethod.uploadFile(
            uid: authRepositry.firebaseAuth.currentUser!.uid,
            context: context,
            childname: "Profile/",
            file: bannerFile);
        userModel = userModel.copyWith(bannerUrl: banner);
      }
      if (bio.isNotEmpty) {
        userModel = userModel.copyWith(bio: bio);
      }
      if (name.isNotEmpty) {
        userModel = userModel.copyWith(name: name);
      }
      authRepositry.editUserProfile(userModel);
      state = false;

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('error');
    }
  }

  Stream<List<TweetModel>> getAllTweet() {
    return authRepositry.getAllTweet();
  }

  void sendTweetPhoto(
      {required File? PhotoUrl,
      required BuildContext context,
      required String tweetTitle,
      required UserModel userModel}) async {
    try {
      state = true;
      String Tweetid = Uuid().v1();
      if (PhotoUrl != null) {
        var prof = await storageMethod.uploadFile(
            uid: Tweetid,
            context: context,
            childname: "Profile/tweet",
            file: PhotoUrl);

        TweetModel tweetModel = TweetModel(
            time: DateTime.now().toString(),
            type: "photo",
            USerPhotoUrl: userModel.USerPhotoUrl,
            tweetTitle: tweetTitle,
            postId: Tweetid,
            username: userModel.name,
            photoUrl: prof,
            // retweet: [],
            // likes: [],
            // comments: [],
            UserId: userModel.UserID);
        authRepositry.sendToFirebaseTweet(
            tweetModel: tweetModel, tweetId: Tweetid);
        state = false;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => BottomScreen(userID: userModel.UserID)));
      }
    } on FirebaseException catch (e) {
      print(e.message!);
    }
  }

  void sendTextMessageTofirebase(
      {required String message,
      required BuildContext context,
      required String tweetTitle,
      required UserModel userModel}) async {
    try {
      state = true;

      String Tweetid = Uuid().v1();
      TweetModel tweetModel = TweetModel(
          time: DateTime.now().toString(),
          type: "text",
          USerPhotoUrl: userModel.USerPhotoUrl,
          tweetTitle: tweetTitle,
          postId: Tweetid,
          username: userModel.name,
          photoUrl: message,
          // retweet: [],
          // likes: [],
          // comments: [],
          UserId: userModel.UserID);
      authRepositry.sendToFirebaseTweet(
          tweetId: Tweetid, tweetModel: tweetModel);
      state = false;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => BottomScreen(userID: userModel.UserID)));
    } on FirebaseAuthException catch (e) {
      print(e.message!);
    }
  }

  void sendTwetGif(
      {required String GifUrl,
      required BuildContext context,
      required String tweetTitle,
      required UserModel userModel}) async {
    try {
      state = true;

      String Tweetid = Uuid().v1();
      int gifUrlPartIndex = GifUrl.lastIndexOf('-') + 1;
      String gifUrlPart = GifUrl.substring(gifUrlPartIndex);
      String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

      TweetModel tweetModel = TweetModel(
          time: DateTime.now().toString(),
          type: "gif",
          USerPhotoUrl: userModel.USerPhotoUrl,
          tweetTitle: tweetTitle,
          postId: Tweetid,
          username: userModel.name,
          photoUrl: newgifUrl,
          // retweet: [],
          // likes: [],
          // comments: [],
          UserId: userModel.UserID);
      authRepositry.sendToFirebaseTweet(
          tweetId: Tweetid, tweetModel: tweetModel);
      state = false;
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => BottomScreen(userID: userModel.UserID)));
    } on FirebaseException catch (e) {
      print(e.message!);
    }
  }

  Future addRemoveFollowers(
      {required String uid, required UserModel userModel}) async {
    if (userModel.followers.contains(uid)) {
      await authRepositry.removeUnionFollow(uid: uid, userModel: userModel);
    } else if (!userModel.followers.contains(uid)) {
      await authRepositry.addUnionFollow(uid: uid, userModel: userModel);
    }
  }

  // Future addRemoveLike(
  //     {required String uid, required TweetModel tweetModel}) async {
  //   if (tweetModel.likes.contains(uid)) {
  //     await authRepositry.removeUnionLikes(uid: uid, tweetModel: tweetModel);
  //   } else if (!tweetModel.likes.contains(uid)) {
  //     await authRepositry.adUnionLikes(uid: uid, tweetModel: tweetModel);
  //   }
  // }

  Stream<TweetModel> getDiplayTweetModel({required TweetModel tweetModel}) {
    return authRepositry.getForDisplayTweetDetails(PostID: tweetModel.postId);
  }

  void signInWithEmail(
      String email, String password, BuildContext context) async {
    state = true;
    authRepositry.SignInUser(email, password, context);

    state = false;
  }

  Future<UserModel?> getUserDetails() async {
    UserModel? user = await authRepositry.getUserDetails();

    return user;
  }

  Stream<UserModel> getUserModel({required String uid}) {
    return authRepositry.getUserModel(uid);
  }

  Stream<UserModel> GetUsserDetails() {
    return authRepositry.GetCureentUsserDetails();
  }

  Stream<List<UserModel>> listOfUser(String queue) {
    return authRepositry.UserName(queue);
  }

  Future signOut(BuildContext context) async {
    state = true;

    await authRepositry.logOutUSer(context);
    state = false;
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
  }

  void RetweetMessage(
      {required String username,
      required String photoUrl,
      required String USerPhotoUrl,
      required String UserId,
      required String type}) async {
    String Uuiid = Uuid().v1();
    TweetModel tweetModel = TweetModel(
        time: DateTime.now().toString(),
        postId: Uuiid,
        username: username,
        photoUrl: photoUrl,
        USerPhotoUrl: USerPhotoUrl,
        // retweet: [],
        // likes: [],
        // comments: [],
        UserId: UserId,
        type: type,
        tweetTitle: '');

    authRepositry.sendToFirebaseTweet(tweetModel: tweetModel, tweetId: Uuiid);
  }

  void gerateNotification(
      {required String Useruid, required String commment}) async {
    authRepositry.triggerNotification(Useruid: Useruid, commment: commment);
  }

  void sendCommentsDetailsToFirebase(
      {required CommetsModel commetsModel,
      required TweetModel tweetModel,
      required BuildContext context,
      required String currUserId}) async {
    state = true;
    String uuid = Uuid().v1();
    authRepositry.sendCommentsDetailsToFirebase(
        Postid: tweetModel.postId, docId: uuid, commetsModel: commetsModel);
    state = false;
    gerateNotification(
        Useruid: tweetModel.UserId, commment: commetsModel.Comment);
  }

  void sendToFirebase(
      {required File? image,
      required BuildContext context,
      required String name,
      required String bio}) async {
    if (image != null) {
      state = true;
      var res = await storageMethod.uploadFile(
          uid: name,
          context: context,
          childname: "UserProfilePhoto",
          file: image);

      UserModel userModel = UserModel(
          bannerUrl: '',
          USerPhotoUrl: res,
          UserID: authRepositry.firebaseAuth.currentUser!.uid,
          Email: authRepositry.firebaseAuth.currentUser!.email!,
          name: name,
          following: [],
          followers: [],
          bio: bio,
          isTwitterBlue: false);

      authRepositry.setDeetailsToFirebase(userModel, context);

      state = false;
    }
  }
}
