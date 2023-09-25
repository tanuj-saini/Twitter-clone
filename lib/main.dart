import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter/bottomNevigationBar.dart';
import 'package:twitter/features/auth/authContoller.dart';
import 'package:twitter/features/auth/login.dart';
import 'package:twitter/features/auth/search/search.dart';
import 'package:twitter/utils/LoderScreen.dart';
import 'package:twitter/utils/appTheme.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
          channelKey: "notification",
          channelName: "Twitter",
          channelDescription: "Hello checking notification"),
    ],
    debug: true,
  );
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Twitter',
        theme: AppTheme.theme,
        home: ref.watch(USerDetailsFormain).when(
            data: (data) {
              if (data != null) {
                return BottomScreen(userID: data.UserID);
              }
              return LoginScreen();
            },
            error: (e, trace) {
              print(e.toString());
              return SizedBox();
            },
            loading: () => LoderScreen()));
  }
}
