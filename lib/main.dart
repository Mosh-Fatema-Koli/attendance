
import 'package:attendance/view/all/Onboard/SplashPage.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';


void main() {
  // We need to call it manually,
  // because we going to call setPreferredOrientations()
  // before the runApp() call
  WidgetsFlutterBinding.ensureInitialized();
  // This for system status bar setup
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
    designSize: const Size(393, 830),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, child) => MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      locale: const Locale('en', 'US'),
      home: SplashPage(),
      title: 'OnDesk',
      debugShowCheckedModeBanner: false,
    ));
  }
}

//Native Splash :: https://medium.com/flutter-community/flutter-2019-real-splash-screens-tutorial-16078660c7a1
