import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/comments/CommentsMdoel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  final UserModel user;
  final String PostId;
  NotificationScreen({required this.user, required this.PostId, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NotificationScreen();
  }
}

class _NotificationScreen extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ref
          .watch(authContollerProvider.notifier)
          .getCommnetsDetaislInNotificcation(
              PostId:widget.PostId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LoderScreen();
        }
        return ListView.builder(
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final list = snapshot.data![index];
            String text = list.Comment;
            return ListTile(
                leading: CircleAvatar(
                  radius: 20,
                  child: CachedNetworkImage(imageUrl: widget.user.USerPhotoUrl),
                ),
                title: Text(
                  "Comment on Post  ==:== $text",
                ));
          },
        );
      },
    );
  }
}
