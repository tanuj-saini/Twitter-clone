import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/comments/CommentsMdoel.dart';
import 'package:twitter/features/comments/commentsContainerScreen.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:uuid/uuid.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String currentUid;
  final TweetModel tweetModel;
  CommentsScreen(
      {required this.tweetModel, required this.currentUid, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _CommentsScreen();
  }
}

class _CommentsScreen extends ConsumerState<CommentsScreen> {
  final TextEditingController commentsCOntoller = TextEditingController();

  // void sendTwitterNotifictionToFirebase() {
  //  ref.watch(authContollerProvider.notifier).gerateNotification(
  //       Useruid: widget.currentUid, commment: commentsCOntoller.text);
  // }

  void SendDetailsOFComments({
    required CommetsModel commetsModel,
  }) async {
    ref.watch(authContollerProvider.notifier).sendCommentsDetailsToFirebase(
        context: context,
        commetsModel: commetsModel,
        tweetModel: widget.tweetModel,
        currUserId: widget.currentUid);
    setState(() {
      commentsCOntoller.text == '';
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentsCOntoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoder = ref.watch(authContollerProvider);
    return ref.watch(getUserTwiitProfile(widget.currentUid)).when(
        data: (userModel) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Comments"),
              centerTitle: true,
              actions: [
                TextButton(
                    onPressed: () {
                      SendDetailsOFComments(
                          commetsModel: CommetsModel(
                              PostId: widget.tweetModel.postId,
                              CommentsId: Uuid().v1(),
                              Comment: commentsCOntoller.text,
                              USerProfile: userModel.USerPhotoUrl,
                              usserId: widget.currentUid,
                              createdAt: DateTime.now(),
                              SendToUserName: widget.tweetModel.username));
                    },
                    child: Text("Send"))
              ],
            ),
            body: isLoder
                ? LoderScreen()
                : Column(
                    children: [
                      Expanded(
                        child: ref
                            .watch(getCommentsDetails(widget.tweetModel.postId))
                            .when(
                                data: (commetsModel) {
                                  return ListView.builder(
                                    itemCount: commetsModel.length,
                                    itemBuilder: (context, index) {
                                      final commettsModel = commetsModel[index];
                                      return CommentsContainer(
                                          commetsModel: commettsModel);
                                    },
                                  );
                                },
                                error: (e, trace) {
                                  print(e.toString());
                                  return showSnackBar(e.toString(), context);
                                },
                                loading: () => LoderScreen()),
                      ),
                      Container(
                          padding:
                              EdgeInsets.all(16.0), // Adjust padding as needed
                          color: Colors.black12, // Set the background color
                          child: TextField(
                            controller: commentsCOntoller,
                            decoration: InputDecoration(
                              hintText: 'Comments',
                              border: OutlineInputBorder(),
                            ),
                          ))
                    ],
                  ),
          );
        },
        error: (e, trace) {
          print(e.toString());
          return showSnackBar(e.toString(), context);
        },
        loading: () => LoderScreen());
  }
}
