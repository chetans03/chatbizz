import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/helper/my_date_util.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/models/messages.dart';
import 'package:chatbizz/screens/chatter_profile_screen.dart';
import 'package:chatbizz/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  bool _isshowemoji = false, _isUploading = false;
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        //app bar

        appBar: AppBar(
          iconTheme: IconThemeData(
            color: white,
          ),
          automaticallyImplyLeading: false,
          backgroundColor: black,
          flexibleSpace: _appBar(),
        ),

        backgroundColor: black,

        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshots) {
                    switch (snapshots.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return const SizedBox();

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshots.data?.docs;
                        _list = data
                                ?.map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_list.isNotEmpty) {
                          return ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top: 20, bottom: 20),
                            physics: BouncingScrollPhysics(),
                            itemCount: _list.length,
                            itemBuilder: (context, index) {
                              return MessageCards(
                                messages: _list[index],
                              );
                            },
                          );
                        } else {
                          return Center(
                            child: Text(
                              "Say hii!",
                              style: TextStyle(fontSize: 15, color: white),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              if (_isUploading)
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  ),
                ),
              _chatInput(),
              if (_isshowemoji)
                SizedBox(
                  height: mq.height * .35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  // app bar widget
  Widget _appBar() {
    return SafeArea(
      child: InkWell(
          onTap: () {
            Navigator.push(
                context,
                PageTransition(
                    child: ChatterProfileScreen(user: widget.user),
                    type: PageTransitionType.rightToLeft));
          },
          child: StreamBuilder(
              stream: APIs.getUserInfo(widget.user),
              builder: (context, snapshot) {
                final data = snapshot.data?.docs;
                final _list =
                    data?.map((e) => ChatUser.fromJson(e.data())).toList() ??
                        [];
                return Row(
                  children: [
                    //back button
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: Colors.black54)),

                    //user profile picture
                    ClipRRect(
                      borderRadius: BorderRadius.circular(sz.height * .03),
                      child: CachedNetworkImage(
                        width: sz.height * .03,
                        height: sz.height * .03,
                        fit: BoxFit.cover,
                        imageUrl: _list.isNotEmpty
                            ? _list[0].image
                            : widget.user.image,
                        errorWidget: (context, url, error) =>
                            const CircleAvatar(
                                child: Icon(CupertinoIcons.person)),
                      ),
                    ),

                    //for adding some space
                    const SizedBox(width: 10),

                    //user name & last seen time
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //user name
                        Text(
                            _list.isNotEmpty ? _list[0].name : widget.user.name,
                            style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),

                        const SizedBox(height: 2),

                        Text(
                            _list.isNotEmpty
                                ? _list[0].isOnline
                                    ? 'Online'
                                    : MyDateUtil.getLastActiveTime(
                                        context: context,
                                        lastActive: _list[0].lastActive)
                                : MyDateUtil.getLastActiveTime(
                                    context: context,
                                    lastActive: widget.user.lastActive),
                            style: const TextStyle(
                                fontSize: 13, color: Colors.white)),
                      ],
                    )
                  ],
                );
              })),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: sz.width * .03, vertical: sz.height * .01),
      child: Row(
        children: [
          Expanded(
            child: Card(
              elevation: 20,
              shadowColor: black,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        FocusScope.of(context).unfocus();
                        _isshowemoji = !_isshowemoji;
                      });
                    },
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        if (_isshowemoji) {
                          setState(() {
                            _isshowemoji = !_isshowemoji;
                          });
                        }
                      },
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Type something", border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker imagePicker = ImagePicker();
                      final List<XFile>? image =
                          await imagePicker.pickMultiImage();

                      for (var i in image!) {
                        setState(() {
                          _isUploading = true;
                        });
                        await APIs.sendChatImage(widget.user, File(i.path));
                        setState(() {
                          _isUploading = false;
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.image,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      final ImagePicker imagePicker = ImagePicker();
                      final XFile? image = await imagePicker.pickImage(
                          source: ImageSource.camera);

                      if (image != null) {
                        log("path ${image.path}  + ${image.mimeType}");

                        await APIs.sendChatImage(
                            widget.user, File(image.path!));
                      }
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            elevation: 20,
            minWidth: 0,
            color: white,
            shape: CircleBorder(),
            onPressed: () async {
              if (_textController.text.isNotEmpty) {
                if (_list.isEmpty) {
                  await APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }
                _textController.text = '';
              }
            },
            child: Icon(
              Icons.send,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
