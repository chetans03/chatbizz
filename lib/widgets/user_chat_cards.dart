import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
        onTap: () {
          Navigator.push(
            context,
            PageTransition(
                child: ChatScreen(
                  user: widget.user,
                ),
                type: PageTransitionType.leftToRight),
          );
        },
        child: ListTile(
          title: Text(widget.user.name),
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              height: MediaQuery.of(context).size.height * .09,
              width: MediaQuery.of(context).size.width * .09,
              imageUrl: widget.user.image,
              // placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          subtitle: Text(
            widget.user.about,
            maxLines: 1,
          ),
          trailing: Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: dotcolor),
          ),
        ),
      ),
    );
  }
}
