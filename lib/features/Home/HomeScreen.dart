import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/tweet/DisplayTweet.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/features/tweet/tweetScreeen.dart';
import 'package:twitter/features/SilversScreen/userProfile.dart';
import 'package:twitter/features/SilversScreen/userProfliefollow.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/authRepo.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:twitter/utils/colors.dart';
//Image.NetworkImage

class HomeScreen extends ConsumerStatefulWidget {
  final UserModel UserMdel;
  HomeScreen({required this.UserMdel, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<HomeScreen> {
  void signOutUSer() async {
    await ref.watch(authContollerProvider.notifier).signOut(context);
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (cxt) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CircleAvatar(
            radius: 10,
            child: Icon(Icons.animation),
          ),
        ),
        drawer: Drawer(
          child: Column(
            children: [
              SizedBox(
                height: 40,
              ),
              ListTile(
                  title: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => UserProfile(
                            userModel: widget.UserMdel,
                          )));
                },
                icon: Icon(Icons.group),
                label: Text("Edit Profile"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              )),
              SizedBox(
                height: 8,
              ),
              ListTile(
                title: ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.monitor),
                  label: Text("Twitter Blue"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              ListTile(
                title: ElevatedButton.icon(
                  onPressed: () {
                    signOutUSer();
                  },
                  icon: Icon(Icons.logout),
                  label: Text("LogOut"),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.black),
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Pallete.blueColor,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => HomeFlotingAction(
                      userModel: widget.UserMdel,
                    )));
          },
          child: Icon(Icons.add),
        ),
        body:
            // ref.watch(getUserTweetForProfile(widget.UserMdel)).when(
            //     data: (tweetModel) {
            //       return ListView.builder(
            //         itemCount: tweetModel.length,
            //         itemBuilder: (context, index) {
            //           final tweettModel = tweetModel[index];

            //           return TweetDisplayScreen(
            //               currentUserId: widget.UserMdel.UserID,
            //               tweetModel: tweettModel);
            //         },
            //       );
            //     },
            //     error: (e, trace) {
            //       print(e.toString());
            //       return Text('bhgmdklglkdfslkj');
            //       //showSnackBar(e.toString(), context);
            //     },
            //     loading: () => LoderScreen()));
            StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Tweet').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoderScreen();
            }
            if (snapshot.data!.docs.isEmpty) return Text("empty");
            // print(snapshot.data!.docs.length);
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                List<DocumentSnapshot> data = snapshot.data!.docs;
                print(data[index]['UserId']);
                // return Container();
                return TweetDisplayScreen(
                    currentUserId: widget.UserMdel.UserID,
                    tweetModel: TweetModel(
                        postId: data[index]['postId'],
                        username: data[index]['username'],
                        photoUrl: data[index]['photoUrl'],
                        USerPhotoUrl: data[index]['USerPhotoUrl'],
                        // retweet: data[index]['retweet'],
                        // likes: data[index]['likes'],
                        //comments: data[index]['comments'],
                        UserId: data[index]['UserId'],
                        type: data[index]['type'],
                        tweetTitle: data[index]['tweetTitle'],
                        time: data[index]['time']));
              },
            );
          },
        ));
  }
}
