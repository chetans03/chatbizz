import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/firebase_options.dart';
import 'package:chatbizz/screens/auth/auth_screen.dart';
import 'package:chatbizz/screens/auth/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';

late Size sz;
final navigatorKey = GlobalKey<NavigatorState>();
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) {
    _initializeFirebase();
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        navigatorKey: navigatorKey,
        title: 'ChatBizz',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: backgroundcolor,
            centerTitle: true,
            elevation: 10,
          ),
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 253, 252, 255)),
          useMaterial3: true,
        ),
        home: SplashScreen());
  }
}

_initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
