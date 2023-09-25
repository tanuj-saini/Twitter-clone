import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/features/SilversScreen/userEditProfile.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/userMdoel.dart';

class UserProfile extends ConsumerStatefulWidget{
  final UserModel userModel;


  UserProfile({required this.userModel,super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserProfile();
  }
}
class _UserProfile extends ConsumerState<UserProfile>{
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: ref.watch(authContollerProvider.notifier).
    GetUsserDetails(), builder: (context, snapshot) {
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
                      child: Image.network(snapshot.data!.bannerUrl==""?
                         "https://pixlok.com/wp-content/uploads/2021/03/default-user-profile-picture.jpg":snapshot.data!.bannerUrl,
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
                      backgroundImage: CachedNetworkImageProvider(snapshot.data!.USerPhotoUrl),
                      radius: 30,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextButton(onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=> userProfile(userModel: widget.userModel)));
                   }, child: Text("Edit Profile")),
                
                  SizedBox(
                    height: 10,
                  ),
                  
                ])),
              ),
            ];
          }, body: Text(''),));
  });
}
    }
  