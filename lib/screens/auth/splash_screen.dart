import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/screens/auth/auth_screen.dart';
import 'package:chatbizz/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(milliseconds: 2000),
      () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(
            const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

        if (APIs.auth.currentUser != null) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const LoginScreen()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    sz = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: sz.height,
        width: sz.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Image(
            image: AssetImage("images/AppIcon.png"),
            height: 150,
          ),
          Text(
            "ChatBizz",
            style: GoogleFonts.robotoCondensed(
                textStyle: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 50, color: white)),
          )
        ]),
      ),
    );
  }
}
