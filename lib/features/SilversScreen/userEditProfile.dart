import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/comman/pick.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/utils/LoderScreen.dart';

class userProfile extends ConsumerStatefulWidget {
  final UserModel userModel;
  userProfile({required this.userModel, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _UserProfile();
  }
}

class _UserProfile extends ConsumerState<userProfile> {
  File? bannerFile;
  File? profilePhoto;
  final TextEditingController nameContoller = TextEditingController();
  final TextEditingController bioContoller = TextEditingController();

  void sendDetailsToFirebase({
    required String bio,
    required String name,
  }) async {
    ref.watch(authContollerProvider.notifier).editUserProfile(
        bannerFile: bannerFile,
        profilePhoto: profilePhoto,
        bio: bio,
        name: name,
        userModel: widget.userModel,
        context: context);
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

  void updateProfile(
      {required String bio,
      required String name,
      required UserModel userModel}) async {
    ref.watch(authContollerProvider.notifier).editUserProfile(
        bannerFile: bannerFile,
        profilePhoto: profilePhoto,
        bio: bio,
        name: name,
        userModel: userModel,
        context: context);
  }

  void selectedProfileImage() async {
    final res = await pickkImage();
    print(res);
    if (res != null) {
      setState(() {
        profilePhoto = File(res.files.first.path!);
      });
    }
  }

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
              appBar: AppBar(
                title: Text("EditProfile"),
                centerTitle: true,
                actions: [
                  TextButton(
                      onPressed: () {
                        updateProfile(
                            bio: bioContoller.text,
                            name: nameContoller.text,
                            userModel: widget.userModel);
                      },
                      child: Text("Save"))
                ],
              ),
              body: isLoding
                  ? LoderScreen()
                  : NestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
                        return [
                          SliverAppBar(
                            expandedHeight: 150,
                            floating: true,
                            snap: true,
                            flexibleSpace: GestureDetector(
                              onTap: () {
                                selectedbannerImage();
                              },
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                      child: bannerFile != null
                                          ? Image.file(bannerFile!)
                                          : Image.network(
                                              'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQsZlQZfQdzLu4FDubq5dmk3hB41mR2XWR8OQ&usqp=CAU')),
                                ],
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: EdgeInsets.all(16),
                            sliver: SliverList(
                                delegate: SliverChildListDelegate([
                              Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    selectedProfileImage();
                                  },
                                  child: CircleAvatar(
                                    child: ClipOval(
                                        child: profilePhoto != null
                                            ? Image.file(
                                                profilePhoto!,
                                                fit: BoxFit.cover,
                                                width: 20,
                                                height: 20,
                                              )
                                            : Image.network(
                                                widget.userModel.USerPhotoUrl)),
                                    radius: 30,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ])),
                          ),
                        ];
                      },
                      body: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(18.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: nameContoller,
                                maxLength: 30,
                                decoration: InputDecoration(
                                  hintText: "Write a name",
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              TextField(
                                maxLines: 4,
                                decoration: InputDecoration(
                                  hintText: "Warite a bio",
                                ),
                                controller: bioContoller,
                              ),
                            ],
                          ),
                        ),
                      )));
        });
  }
}
