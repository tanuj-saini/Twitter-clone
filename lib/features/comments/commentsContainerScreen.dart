import 'package:flutter/material.dart';
import 'package:twitter/features/comments/CommentsMdoel.dart';

class CommentsContainer extends StatelessWidget{
  final CommetsModel commetsModel;
  CommentsContainer({required this.commetsModel,super.key});
  @override
  Widget build(BuildContext context) {
   return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListTile(title: Text(commetsModel.Comment,style: TextStyle(fontSize: 18),),leading: CircleAvatar(child: Image.network(commetsModel.USerProfile),radius: 20,),),
      ),
    );
   
  }
}