import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/models/messages.dart';
import 'package:chatbizz/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;

  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Message> _list = [];
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: _appBar(),
      ),

      backgroundColor: const Color.fromARGB(255, 234, 248, 255),

      body: SafeArea(
        child: Container(
          height: sz.height,
          width: sz.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("images/background.jpg"),
                opacity: .7,
                fit: BoxFit.cover),
          ),
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
                              style: TextStyle(fontSize: 15),
                            ),
                          );
                        }
                    }
                  },
                ),
              ),
              _chatInput()
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
          // Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //         builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: Row(
          children: [
            //back button
            IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.black54)),

            //user profile picture
            ClipRRect(
              borderRadius: BorderRadius.circular(sz.height * .03),
              child: CachedNetworkImage(
                width: sz.height * .03,
                height: sz.height * .03,
                fit: BoxFit.cover,
                imageUrl: widget.user.image,
                errorWidget: (context, url, error) =>
                    const CircleAvatar(child: Icon(CupertinoIcons.person)),
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
                Text(widget.user.name,
                    style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500)),

                //for adding some space
                const SizedBox(height: 2),

                //last seen time of user
                // Text(
                //     list.isNotEmpty
                //         ? list[0].isOnline
                //             ? 'Online'
                //             : MyDateUtil.getLastActiveTime(
                //                 context: context,
                //                 lastActive: list[0].lastActive)
                //         : MyDateUtil.getLastActiveTime(
                //             context: context,
                //             lastActive: widget.user.lastActive),
                //     style: const TextStyle(
                //         fontSize: 13, color: Colors.black54)),
              ],
            )
          ],
        ),
      ),
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
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      decoration: InputDecoration(
                          hintText: "Type something", border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.black,
                      size: 26,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
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
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                APIs.sendMessage(widget.user, _textController.text);
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
