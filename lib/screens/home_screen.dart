import 'dart:convert';
import 'dart:developer';

import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/widgets/user_chat_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  _signOut() async {
    await APIs.auth.signOut();
    await GoogleSignIn().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          Image.asset(
            "images/AppIcon.png",
            height: 40,
            fit: BoxFit.cover,
          ),
          Text(
            'ChatBizz',
            style: GoogleFonts.robotoCondensed(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
        ]),
        actions: [
          //search user button
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),

          //more features button
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
        child: const Icon(Icons.add_comment_sharp),
      ),
      body: Container(
        height: sz.height,
        width: sz.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"), fit: BoxFit.cover),
        ),
        child: StreamBuilder(
          stream: APIs.firestore.collection('users').snapshots(),
          builder: (context, snapshots) {
            switch (snapshots.connectionState) {
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator());

              case ConnectionState.active:
              case ConnectionState.done:
                final data = snapshots.data?.docs;
                list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                    [];
                if (!list.isEmpty) {
                  return ListView.builder(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    physics: BouncingScrollPhysics(),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return ChatUserCard(
                        user: list[index],
                      );
                    },
                  );
                } else {
                  return Center(
                    child: Text(
                      "No Chat found",
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}
