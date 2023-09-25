import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/comman/pick.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class HomeFlotingAction extends ConsumerStatefulWidget {
  final UserModel userModel;
  HomeFlotingAction({required this.userModel, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeFloting();
  }
}

class _HomeFloting extends ConsumerState<HomeFlotingAction> {
  File? bannerFile;
  final TextEditingController tweetContoller = TextEditingController();

  void sendGif() async {
    final gif = await pickGIF(context);
    if (gif != null) {
      ref.watch(authContollerProvider.notifier).sendTwetGif(
          GifUrl: gif.url,
          context: context,
          tweetTitle: tweetContoller.text,
          userModel: widget.userModel);
      setState(() {
        tweetContoller.text = '';
      });
    }
  }

  void selectedbannerImage() async {
    final res = await pickkImage();
    print(res);
    if (res != null) {
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tweetContoller.dispose();
  }

  void sendTweetTofirebase() async {
    ref.watch(authContollerProvider.notifier).sendTweetPhoto(
        tweetTitle: tweetContoller.text,
        PhotoUrl: bannerFile,
        context: context,
        userModel: widget.userModel);
    setState(() {
      tweetContoller.text = '';
    });
  }

  void sendTextMessageToFirebase() async {
    ref.watch(authContollerProvider.notifier).sendTextMessageTofirebase(
        message: tweetContoller.text,
        context: context,
        tweetTitle: '',
        userModel: widget.userModel);
  }
  // Image.NetworkImage

  @override
  Widget build(BuildContext context) {
    final isLoding = ref.watch(authContollerProvider);

    return StreamBuilder(
        stream: ref.watch(authContollerProvider.notifier).GetUsserDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoderScreen();
          }
          return Scaffold(
            appBar: AppBar(actions: [
              ElevatedButton(
                  onPressed: () {
                    sendTweetTofirebase();
                  },
                  child: Text('Tweet'))
            ]),
            body: isLoding
                ? LoderScreen()
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                child:
                                    Image.network(snapshot.data!.USerPhotoUrl),
                                radius: 30,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: isLoding
                              ? LoderScreen()
                              : Column(
                                  children: [
                                    bannerFile == null
                                        ? Align(
                                            alignment: Alignment.topRight,
                                            child: IconButton(
                                                onPressed: () {
                                                  sendTextMessageToFirebase();
                                                },
                                                icon: Icon(Icons.send)))
                                        : SizedBox(),
                                    TextField(
                                      controller: tweetContoller,
                                      decoration: InputDecoration(
                                          hintText: "What's happeing?",
                                          border: InputBorder.none),
                                    ),
                                  ],
                                ),
                        ),
                        GestureDetector(
                          child: AspectRatio(
                              aspectRatio: 10 / 9,
                              child: bannerFile != null
                                  ? Image.file(bannerFile!)
                                  : Image.network(
                                      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsZlQZfQdzLu4FDubq5dmk3hB41mR2XWR8OQ&usqp=CAU')),
                          onTap: () => selectedbannerImage(),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    selectedbannerImage();
                                  },
                                  icon: Icon(Icons.photo)),
                              SizedBox(
                                width: 3,
                              ),
                              IconButton(
                                  onPressed: () {
                                    sendGif();
                                  },
                                  icon: Icon(Icons.gif)),
                              SizedBox(
                                width: 3,
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.emoji_emotions))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
          );
        });
  }
}
