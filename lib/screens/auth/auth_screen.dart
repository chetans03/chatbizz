import 'package:chatbizz/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    sz = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 213, 226, 238),
        automaticallyImplyLeading: false,
        title: Text(
          'Welcome to ChatBizz',
          style: GoogleFonts.kanit(
              textStyle: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ),
      body: Container(
        height: sz.height,
        width: sz.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: Stack(
          children: [
            Positioned(
              width: sz.width * .5,
              top: sz.height * .15,
              left: sz.width * .25,
              child: Image.asset("images/AppIcon.jpg"),
            ),
            Positioned(
              width: sz.width * .9,
              bottom: sz.height * .15,
              left: sz.width * .05,
              height: sz.height * .07,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: Image.asset(
                  "images/google.png",
                  height: sz.height * .03,
                ),
                label: Text("Login with Google"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
