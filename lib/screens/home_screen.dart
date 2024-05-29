import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/screens/profile_screen.dart';
import 'package:chatbizz/widgets/user_chat_cards.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> _list = [];
  List<ChatUser> _searchList = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    APIs.getSelfUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: const Icon(CupertinoIcons.home),
          title: isSearching
              ? TextField(
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: "Name , Email",
                  ),
                  autofocus: true,
                  onChanged: (value) {
                    _searchList.clear();

                    for (var i in _list) {
                      if (i.name.toLowerCase().contains(value.toLowerCase()) ||
                          i.email.toLowerCase().contains(value.toLowerCase())) {
                        _searchList.add(i);
                      }
                      setState(() {
                        _searchList;
                      });
                    }
                  },
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                      Image.asset(
                        "images/AppIcon.png",
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        'ChatBizz',
                        style: GoogleFonts.robotoCondensed(
                            textStyle: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 30)),
                      ),
                    ]),
          actions: [
            //search user button
            IconButton(
                onPressed: () {
                  setState(() {
                    isSearching = !isSearching;
                  });
                },
                icon: Icon(isSearching
                    ? CupertinoIcons.clear_circled_solid
                    : Icons.search)),

            //more features button
            IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageTransition(
                        child: ProfileScreen(user: APIs.chatUser),
                        type: PageTransitionType.leftToRight),
                  );
                },
                icon: const Icon(Icons.more_vert))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
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
            stream: APIs.getAllUsers(),
            builder: (context, snapshots) {
              switch (snapshots.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return const Center(child: CircularProgressIndicator());

                case ConnectionState.active:
                case ConnectionState.done:
                  final data = snapshots.data?.docs;
                  _list =
                      data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                          [];
                  if (!_list.isEmpty) {
                    return ListView.builder(
                      padding: EdgeInsets.only(top: 20, bottom: 20),
                      physics: BouncingScrollPhysics(),
                      itemCount:
                          isSearching ? _searchList.length : _list.length,
                      itemBuilder: (context, index) {
                        return ChatUserCard(
                          user: isSearching ? _searchList[index] : _list[index],
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
      ),
    );
  }
}
