// ignore_for_file: avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:road_accident_safety_system/pages/home_page/home_page.dart';
import 'package:road_accident_safety_system/pages/intro_page.dart';

import 'global_data.dart';
import 'mk_theme_provider.dart';

Future<void> main() async {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('google_fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });


  WidgetsFlutterBinding.ensureInitialized();
  print("Widgets Initialized!!");
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: 'AIzaSyA8u-jdYStxqhFO5rdVHHtlFiwKFz1y9jk', // "current_key" from google-services.json
        appId: '1:411710465996:android:bbcf01e0e7ff8b0a869f69', // "mobilesdk_app_id" from google-services.json
        messagingSenderId: '411710465996', // "project_number" from google-services.json
        projectId: 'roadsafety-app-69dbc' // "project_id" from google-services.json
    )
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (_) => MkThemeProvider(),
            ),
          ],
          builder: (context, child) {
            SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
              systemNavigationBarColor: Watchers.gcfct(
                  context, MkColor.navBar), // navigation bar color
              statusBarColor: Watchers.gcfct(
                  context, MkColor.statusBar), // status bar color
            ));
            return const RoadAccidentSafetyApp();
          }
      ),
    );
  });
}

class RoadAccidentSafetyApp extends StatelessWidget {
  const RoadAccidentSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return (snapshot.hasData) ? HomePage(userId: snapshot.data!.uid): const IntroPage();          }
      ),
    );
  }
}