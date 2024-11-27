// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:outpassify/Studentpages/Studentdashboard.dart';
// import 'package:outpassify/pages/auth_page.dart';
// import 'package:outpassify/pages/login_page.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'firebase_options.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(debugShowCheckedModeBanner: false, home: AuthPage());
//   }
// }

// import 'package:camera/camera.dart';
//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:hive_flutter/adapters.dart';
import 'package:outpassify/Studentpages/Studentdashboard.dart';
import 'package:outpassify/components/export.dart';

import 'package:outpassify/pages/auth_page.dart';
import 'package:outpassify/pages/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:outpassify/routes/app_route_config.dart';
import 'package:workmanager/workmanager.dart';
import 'firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SheetsFlutter.init();
  print(
      "DOWN     OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // await AndroidAlarmManager.initialize();
  // exportAndDelete();
  runApp(const MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(), // Wrap your app
  //   ),
  // );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      //  routeInformationParser:MyApprouter().router.routeInformationParser,
      //  routerDelegate:MyApprouter().router.routerDelegate,
      routerConfig: MyApprouter().router,
    );
  }
}
