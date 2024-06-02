import 'dart:io';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/helper/dialoge.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:page_transition/page_transition.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginScreen> {
  bool _isanimate = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isanimate = true;
      });
    });
  }

  _handleGoogleSignIn() {
    Dialogs.showProgressIndicator(context);
    _signInWithGoogle().then((user) async {
      Navigator.pop(context);
      Dialogs.showsnackbar(context, "Logged in successfully");
      if (user != null) {
        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
            context,
            PageTransition(
                child: const HomeScreen(),
                type: PageTransitionType.rightToLeft),
          );
        } else {
          APIs.createUser().then(
            (value) => {
              Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomeScreen(),
                    type: PageTransitionType.rightToLeft),
              )
            },
          );
        }
      }
      // log("User: ${user.user}" as num);
    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    // Trigger the authentication flow
    try {
      await InternetAddress.lookup("google.com");
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      print(e.toString());
      Dialogs.showsnackbar(context, e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    sz = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: sz.height,
        width: sz.width,
        decoration: const BoxDecoration(color: Colors.black),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(seconds: 1),
              width: sz.width * .5,
              top: _isanimate ? sz.height * .15 : -sz.height * .5,
              left: sz.width * .25,
              child: Column(
                children: [
                  Image.asset("images/AppIcon.png"),
                  Text(
                    "ChatBizz",
                    style: GoogleFonts.robotoCondensed(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 50,
                          color: white),
                    ),
                  ),
                  Text(
                    'Welcome to ChatBizz',
                    style: GoogleFonts.kanit(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 20)),
                  ),
                ],
              ),
            ),
            Positioned(
              width: sz.width * .9,
              bottom: sz.height * .15,
              left: sz.width * .05,
              height: sz.height * .07,
              child: ElevatedButton.icon(
                onPressed: _handleGoogleSignIn,
                style: ElevatedButton.styleFrom(
                  elevation: 20,
                ),
                icon: Image.asset(
                  "images/google.png",
                  height: sz.height * .03,
                ),
                label: const Text("Login with Google"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
