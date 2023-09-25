import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/comman/pick.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/utils/LoderScreen.dart';

class UserInfoScreen extends ConsumerStatefulWidget {
  UserInfoScreen({super.key});
  @override
  ConsumerState<UserInfoScreen> createState() {
    return _UserInfoScreen();
  }
}

class _UserInfoScreen extends ConsumerState<UserInfoScreen> {
  final TextEditingController Namecontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  File? bannerFile;

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
    biocontroller.dispose();
    Namecontroller.dispose();
  }

  void sendDetailsToFireBase({required String bio, required String name})async {
    ref.watch(authContollerProvider.notifier).sendToFirebase(
        image: bannerFile, context: context, name: name, bio: bio);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLOding=ref.watch(authContollerProvider);
    return Scaffold(
      body: Center(
        child:isLOding?LoderScreen(): Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            Stack(children: [
              bannerFile == null
                  ? const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN_O2hyzHQi-0hFB8z-4rbSzCwMPKruXrDBQ&usqp=CAU'),
                    )
                  : CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(bannerFile!),
                    ),
              Positioned(
                  child: IconButton(
                      onPressed: selectedbannerImage,
                      icon: const Icon(Icons.add)))
            ]),
            Row(
              children: [
                Container(
                  width: size.width * 0.85,
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: Namecontroller,
                    decoration: const InputDecoration(
                      hintText: "Enter Your  Name",
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                IconButton(
                    onPressed: () => sendDetailsToFireBase(
                        bio: biocontroller.text, name: Namecontroller.text),
                    icon: const Icon(Icons.done)),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: biocontroller,
                decoration: InputDecoration(
                  hintText: "Write a Bio",
                ),
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
