import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:twitter/features/Home/HomeScreen.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/search/search.dart';
import 'package:twitter/features/auth/search/searchScreen.dart';
import 'package:twitter/features/auth/userMdoel.dart';
import 'package:twitter/features/notification/NotificationScreen.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:twitter/utils/colors.dart';

class BottomScreen extends ConsumerStatefulWidget {
  final String userID;
  BottomScreen({required this.userID, super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends ConsumerState<BottomScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().isNotificationAllowed().then((value) {
      if (!value) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  int _page = 0;
  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref
            .watch(authContollerProvider.notifier)
            .getUserModel(uid: widget.userID),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoderScreen();
          }
          return Scaffold(
            body: IndexedStack(index: _page, children: [
              HomeScreen(UserMdel: snapshot.data!),
              SearchScreen(currUesrId: widget.userID),
              NotificationScreen(
                user: snapshot.data!,
                PostId: "93056fa0-b1a5-1d03-ba55-f5960dab57b9",
              ),
            ]),
            bottomNavigationBar: CupertinoTabBar(
                currentIndex: _page,
                onTap: onPageChange,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      _page == 0 ? Icons.home : Icons.home_filled,
                      color: Pallete.whiteColor,
                    ),
                  ),
                  BottomNavigationBarItem(
                      icon: Icon(
                    _page == 1 ? Icons.search_off : Icons.search,
                    color: Pallete.whiteColor,
                  )),
                  BottomNavigationBarItem(
                      icon: Icon(
                    _page == 2
                        ? Icons.notification_add_outlined
                        : Icons.notifications,
                    color: Pallete.whiteColor,
                  )),
                ]),
          );
        });
  }
}
