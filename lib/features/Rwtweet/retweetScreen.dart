import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:uuid/uuid.dart';

class Retweet extends ConsumerStatefulWidget {
  final TweetModel tweettModel;
  final String currentUid;
  Retweet({required this.currentUid, required this.tweettModel, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _Retweet();
  }
}

class _Retweet extends ConsumerState<Retweet> {
  void sendTofirebase({required String username,required String photoUrl,required String USerPhotoUrl,required String UserId,required String type}){
    ref.watch(authContollerProvider.notifier).RetweetMessage(username: username, photoUrl: photoUrl, USerPhotoUrl: USerPhotoUrl, UserId: UserId, type: type);
  }
  @override
  Widget build(BuildContext context) {
    final isLoding=ref.watch(authContollerProvider);
    return  isLoding?LoderScreen(): StreamBuilder(
      stream: ref
          .watch(authContollerProvider.notifier)
          .getUserModel(uid: widget.currentUid),
      builder: (context, snapshot) {
        if(widget.tweettModel.type=='photo'){
          sendTofirebase(username: snapshot.data!.name, photoUrl: widget.tweettModel.photoUrl, USerPhotoUrl: snapshot.data!.USerPhotoUrl, UserId: snapshot.data!.UserID, type: widget.tweettModel.type);

        }
        else if(widget.tweettModel.type=='gif'){
          String gifUrl=widget.tweettModel.photoUrl;
          int gifUrlPartIndex = gifUrl.lastIndexOf('-') + 1;
      String gifUrlPart = gifUrl.substring(gifUrlPartIndex);
      String newgifUrl = 'https://i.giphy.com/media/$gifUrlPart/200.gif';

          sendTofirebase(username: snapshot.data!.name, photoUrl: newgifUrl, USerPhotoUrl: snapshot.data!.USerPhotoUrl, UserId: snapshot.data!.UserID, type: widget.tweettModel.type);


        }
        else{
           sendTofirebase(username: snapshot.data!.name, photoUrl: widget.tweettModel.photoUrl, USerPhotoUrl: snapshot.data!.USerPhotoUrl, UserId: snapshot.data!.UserID, type: widget.tweettModel.type);

        }
        return Scaffold(body: Center(child: ElevatedButton(onPressed: (){
          Navigator.of(context).pop();
        }, child: Text("Retweeted Sucessfully"))),);

      },
      
    );
  }
}
