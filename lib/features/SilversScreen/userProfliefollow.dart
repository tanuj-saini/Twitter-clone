import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/tweet/DisplayTweet.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class UserFollowProfile extends ConsumerStatefulWidget {
  // final TweetModel tweetModel;
  final UserModel userModel;
  final String currentUserId;

  UserFollowProfile(
      {required this.currentUserId, required this.userModel, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends ConsumerState<UserFollowProfile> {
  void addRemoveFollow(
      {required String uid, required UserModel userModel}) async {
    await ref
        .watch(authContollerProvider.notifier)
        .addRemoveFollowers(uid: uid, userModel: userModel);
  }

  @override
  Widget build(BuildContext context) {
    var Searchname = widget.userModel.name;
    var following = widget.userModel.following.length;
    var followers = widget.userModel.followers.length;
    return Scaffold(
        body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 150,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          widget.userModel.bannerUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                SliverPadding(
                    padding: EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate([
                      Align(
                        alignment: Alignment.topLeft,
                        child: CircleAvatar(
                          backgroundImage: CachedNetworkImageProvider(
                              widget.userModel.USerPhotoUrl),
                          // NetworkImage(widget.userModel.USerPhotoUrl),
                          radius: 30,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      StreamBuilder(
                        stream: ref
                            .watch(authContollerProvider.notifier)
                            .getUserModel(uid: widget.currentUserId),
                        builder: (context, snapshot) {
                          int followerslength = snapshot.data!.followers.length;
                          return Column(children: [
                            widget.currentUserId == widget.userModel.UserID
                                ? TextButton(
                                    onPressed: () {}, child: Text("ME"))
                                : TextButton(
                                    onPressed: () => addRemoveFollow(
                                        uid: widget.currentUserId,
                                        userModel: snapshot.data!),
                                    child: Text(snapshot.data!.followers
                                            .contains(widget.currentUserId)
                                        ? "Following"
                                        : "Follow"),
                                  ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(widget.userModel.name,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 15)),
                                SizedBox(
                                  height: 2,
                                ),
                                Text("@$Searchname",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 10)),
                                SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text("$followerslength Followers"),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Text("$following Following")
                                  ],
                                ),
                              ],
                            )
                          ]);
                        },
                      ),
                    ])))
              ];
            },
            body: ref.watch(getUserTweetForProfile(widget.userModel)).when(
                data: (tweetModel) {
                  return ListView.builder(
                    itemCount: tweetModel.length,
                    itemBuilder: (context, index) {
                      final tweettModel = tweetModel[index];

                      return TweetDisplayScreen(
                          currentUserId: widget.currentUserId,
                          tweetModel: tweettModel);
                    },
                  );
                },
                error: (e, trace) {
                  print(e.toString());
                  return Text("");
                  // showSnackBar(e.toString(), context);
                },
                loading: () => LoderScreen())));
  }
}
