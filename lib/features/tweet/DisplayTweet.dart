import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:twitter/features/Rwtweet/retweetScreen.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/comments/commentsScreen.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class TweetDisplayScreen extends ConsumerStatefulWidget {
  final String currentUserId;
  final TweetModel tweetModel;
  TweetDisplayScreen(
      {required this.currentUserId, required this.tweetModel, super.key});

  @override
  ConsumerState<TweetDisplayScreen> createState() => _TweetDisplayScreenState();
}

class _TweetDisplayScreenState extends ConsumerState<TweetDisplayScreen> {
  void sendFiles({required String send}) async {
    await Share.share(send);
  }

  // void sendLikes({required String uid}) async {
  //   await ref.watch(authContollerProvider.notifier).addRemoveLike(
  //       uid: uid, tweetModel: widget.tweetModel);
  // }

  @override
  Widget build(BuildContext context) {
    String name = widget.tweetModel.username;

    return widget.tweetModel.type == "photo"
        ? Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            child: CachedNetworkImage(
                                imageUrl: widget.tweetModel.USerPhotoUrl),
                            radius: 20,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            widget.tweetModel.username,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "@$name",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            widget.tweetModel.tweetTitle,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          )),
                    ],
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 13 / 9,
                child: CachedNetworkImage(imageUrl: widget.tweetModel.photoUrl),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(children: [
                        IconButton.filled(
                            onPressed: () {}, icon: Icon(Icons.bar_chart)),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => CommentsScreen(
                                        currentUid: widget.currentUserId,
                                        tweetModel: widget.tweetModel,
                                      )));
                            },
                            icon: Icon(Icons.message_outlined)),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                            onPressed: () =>
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (ctx) => Retweet(
                                      currentUid: widget.currentUserId,
                                      tweettModel: widget.tweetModel),
                                )),
                            icon: Icon(Icons.restart_alt_sharp)),
                        SizedBox(
                          width: 5,
                        ),

                        //  IconButton(
                        //               onPressed: () {
                        //                 sendLikes(uid: widget.currentUserId);
                        //               },
                        //               icon:
                        //                Icon(Icons.heart_broken_sharp,)
                        //                ),

                        IconButton(
                            onPressed: () {
                              sendFiles(send: widget.tweetModel.photoUrl);
                            },
                            icon: Icon(Icons.share))
                      ])))
            ],
          )
        : widget.tweetModel.type == "gif"
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                child: CachedNetworkImage(
                                    imageUrl: widget.tweetModel.USerPhotoUrl),
                                radius: 20,
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Text(
                                widget.tweetModel.username,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                              Text(
                                "@$name",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                          Align(
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                widget.tweetModel.tweetTitle,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  ),
                  AspectRatio(
                      aspectRatio: 13 / 9,
                      child: CachedNetworkImage(
                          imageUrl: widget.tweetModel.photoUrl)),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            IconButton.filled(
                                onPressed: () {}, icon: Icon(Icons.bar_chart)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => CommentsScreen(
                                            currentUid: widget.currentUserId,
                                            tweetModel: widget.tweetModel,
                                          )));
                                },
                                icon: Icon(Icons.message_outlined)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () => Retweet(
                                    currentUid: widget.currentUserId,
                                    tweettModel: widget.tweetModel),
                                icon: Icon(Icons.restart_alt_sharp)),
                            SizedBox(
                              width: 5,
                            ),
                            // IconButton(
                            //     onPressed: () {
                            //       sendLikes(uid: widget.currentUserId);
                            //     },
                            // icon: Icon(Icons.heart_broken_sharp)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  sendFiles(send: widget.tweetModel.photoUrl);
                                },
                                icon: Icon(Icons.share))
                          ],
                        )),
                  )
                ],
              )
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: CachedNetworkImage(
                                      imageUrl: widget.tweetModel.USerPhotoUrl),
                                  radius: 20,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  widget.tweetModel.username,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(
                                  "@$name",
                                  style: TextStyle(color: Colors.grey),
                                )
                              ],
                            ),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  widget.tweetModel.tweetTitle,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                )),
                          ],
                        )),
                  ),
                  ListTile(
                    title: Text(widget.tweetModel.photoUrl),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          children: [
                            IconButton.filled(
                                onPressed: () {}, icon: Icon(Icons.bar_chart)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => CommentsScreen(
                                            currentUid: widget.currentUserId,
                                            tweetModel: widget.tweetModel,
                                          )));
                                },
                                icon: Icon(Icons.message_outlined)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                      builder: (ctx) => Retweet(
                                          currentUid: widget.currentUserId,
                                          tweettModel: widget.tweetModel),
                                    )),
                                icon: Icon(Icons.restart_alt_sharp)),
                            SizedBox(
                              width: 5,
                            ),
                            // IconButton(
                            //     onPressed: () {
                            //       sendLikes(uid: widget.currentUserId);
                            //     },
                            //     icon: Icon(Icons.heart_broken_sharp)),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                                onPressed: () {
                                  sendFiles(send: widget.tweetModel.photoUrl);
                                },
                                icon: Icon(Icons.share))
                          ],
                        )),
                  )
                ],
              );
  }
}
