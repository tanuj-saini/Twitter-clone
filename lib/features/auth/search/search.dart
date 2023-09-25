import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/search/searchScreen.dart';
import 'package:twitter/features/auth/signUpScreen.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/tweet/tweetModel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class SearchScreen extends ConsumerStatefulWidget {
  final String currUesrId;
  
  SearchScreen({required this.currUesrId, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SearchScreen();
  }
}

class _SearchScreen extends ConsumerState<SearchScreen> {
  @override
  Widget build(BuildContext context) {

    
         
        return Scaffold(
            body: AppBar(
              title: Text("Search Screen"),
              actions: [
                IconButton(
                    onPressed: () {
                      showSearch(
                          context: context,
                          delegate: SearchUserTweet(
                             
                              currUesrId: widget.currUesrId,
                              ref: ref));
                    },
                    icon: Icon(Icons.search))
              ],
            ),
          );
        }
          
        
       
  }