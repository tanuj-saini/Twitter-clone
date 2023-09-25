import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/SilversScreen/userProfile.dart';
import 'package:twitter/features/SilversScreen/userProfliefollow.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class SearchUserTweet extends SearchDelegate {
  final WidgetRef ref;
  final String currUesrId;

  SearchUserTweet({required this.currUesrId, required this.ref});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: Icon(Icons.close))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    return const SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ref.watch(listOfUsers(query)).when(
        data: (userModel) {
          return ListView.builder(
            itemCount: userModel.length,
            itemBuilder: (context, index) {
              final community = userModel[index];
              // return ref.watch(getUserTweetForProfile(community)).when(data: (data){
              //   final TweetModel tweetModel=data[index];
              return ListTile(
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.USerPhotoUrl)),
                title: Text(community.name),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => UserFollowProfile(
                            // tweetModel: tweetModel,
                            currentUserId: currUesrId,
                            userModel: community,
                          )));
                },
              );
            }, // error: (e,trace){print(e.toString()) ;return showSnackBar(e.toString(), context);}, loading: ()=>LoderScreen());

            // },
          );
        },
        error: (e, trace) {
          print(e.toString());
          return Text('');
          //showSnackBar(e.toString(), context);
        },
        loading: () => LoderScreen());
  }
}
