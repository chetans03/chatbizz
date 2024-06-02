import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/helper/my_date_util.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/models/messages.dart';
import 'package:chatbizz/screens/chat_screen.dart';
import 'package:chatbizz/widgets/profile_dialog.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class ChatUserCard extends StatefulWidget {
  ChatUserCard({super.key, required this.user});

  final ChatUser user;
  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  Message? _message;
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
        margin: EdgeInsets.symmetric(
            horizontal: width * .03, vertical: height * .01),
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
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              final data = snapshot.data?.docs;
              final _list =
                  data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
              if (_list.isNotEmpty) {
                _message = _list[0];
              }

              return ListTile(
                title: Text(
                  widget.user.name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => ProfileDialog(user: widget.user),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(sz.height * .3),
                    child: CachedNetworkImage(
                      width: sz.height * .06,
                      height: sz.height * .06,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      // placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => CircleAvatar(
                        child: Icon(Icons.person),
                      ),
                    ),
                  ),
                ),
                subtitle: Text(
                  _message != null
                      ? _message!.type == Type.image
                          ? 'Image'
                          : _message!.msg
                      : widget.user.about,
                  maxLines: 1,
                ),
                trailing: _message == null
                    ? null
                    : _message!.read.isEmpty &&
                            _message!.fromId != APIs.user.uid
                        ? Container(
                            height: 15,
                            width: 15,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: dotcolor),
                          )
                        : Text(
                            MyDateUtil.getLastMessageTime(
                                context: context, time: _message!.sent),
                          ),
              );
            },
          ),
        ));
  }
}
