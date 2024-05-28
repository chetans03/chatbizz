import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:flutter/material.dart';

class ChatUserCard extends StatefulWidget {
  ChatUserCard({super.key, required this.user});

  final ChatUser user;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Card(
      elevation: 10,
      color: backgroundcolor,
      shadowColor: black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin:
          EdgeInsets.symmetric(horizontal: width * .03, vertical: height * .01),
      child: InkWell(
        onTap: () {},
        child: ListTile(
          title: Text(widget.user.name),
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Text("12:00"),
        ),
      ),
    );
  }
}
