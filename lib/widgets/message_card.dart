// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/helper/dialoge.dart';
import 'package:chatbizz/helper/my_date_util.dart';
import 'package:chatbizz/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chatbizz/models/messages.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:google_fonts/google_fonts.dart';

class MessageCards extends StatefulWidget {
  const MessageCards({
    Key? key,
    required this.messages,
  }) : super(key: key);

  final Message messages;
  @override
  State<MessageCards> createState() => _MessageCardsState();
}

class _MessageCardsState extends State<MessageCards> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.messages.fromId;
    return InkWell(
        onLongPress: () {
          _showBottomSheet(isMe);
        },
        child: isMe ? _greenMessage() : _blueMessage());
  }

  Widget _blueMessage() {
    if (widget.messages.read.isEmpty) {
      APIs.updateMessageReadStatus(widget.messages);
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  widget.messages.type == Type.image ? 0 : sz.width * .03,
              vertical: widget.messages.type == Type.image ? 0 : sz.width * .03,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: sz.width * .03, vertical: sz.height * .01),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 137, 202, 255),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(
                    widget.messages.type == Type.image ? 25 : 0,
                  )),
            ),
            child: widget.messages.type == Type.text
                ? Text(
                    widget.messages.msg,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 15, color: black),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(sz.height * .03),
                    child: CachedNetworkImage(
                      width: sz.height * .3,
                      height: sz.height * .3,
                      fit: BoxFit.cover,
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(100),
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: sz.width * .04),
          child: Text(
            MyDateUtil.getFormatedTime(
                context: context, time: widget.messages.sent),
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                  fontSize: 15, color: white, fontWeight: FontWeight.w300),
            ),
          ),
        ),
      ],
    );
  }

  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: EdgeInsets.only(left: sz.width * .04),
          child: Row(children: [
            if (widget.messages.read.isNotEmpty)
              Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
              ),
            Text(
              MyDateUtil.getFormatedTime(
                  context: context, time: widget.messages.sent),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 15, color: white, fontWeight: FontWeight.w300),
              ),
            ),
          ]),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal:
                  widget.messages.type == Type.image ? 0 : sz.width * .03,
              vertical: widget.messages.type == Type.image ? 0 : sz.width * .03,
            ),
            margin: EdgeInsets.symmetric(
                horizontal: sz.width * .03, vertical: sz.height * .01),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 160, 152, 82),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(
                    widget.messages.type == Type.image ? 25 : 0,
                  )),
            ),
            child: widget.messages.type == Type.text
                ? Text(
                    widget.messages.msg,
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 15, color: black),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(sz.height * .03),
                    child: CachedNetworkImage(
                      width: sz.height * .3,
                      height: sz.height * .3,
                      fit: BoxFit.cover,
                      imageUrl: widget.messages.msg,
                      placeholder: (context, url) => Padding(
                        padding: EdgeInsets.all(100),
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return Container(
            color: black,
            child: ListView(
              shrinkWrap: true,
              children: [
                //black divider
                Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      vertical: sz.height * .015, horizontal: sz.width * .4),
                  decoration: BoxDecoration(
                      color: black, borderRadius: BorderRadius.circular(8)),
                ),

                widget.messages.type == Type.text
                    ?
                    //copy option
                    _OptionItem(
                        icon: const Icon(Icons.copy_all_rounded,
                            color: Colors.white, size: 26),
                        name: 'Copy Text',
                        onTap: () async {
                          await Clipboard.setData(
                                  ClipboardData(text: widget.messages.msg))
                              .then(
                            (value) {
                              //for hiding bottom sheet
                              Navigator.pop(context);

                              Dialogs.showsnackbar(context, 'Text Copied!');
                            },
                          );
                        },
                      )
                    :
                    //save option
                    _OptionItem(
                        icon: const Icon(Icons.download_rounded,
                            color: Colors.white, size: 26),
                        name: 'Save Image',
                        onTap: () async {
                          try {
                            log('Image Url: ${widget.messages.msg}');
                            await GallerySaver.saveImage(widget.messages.msg,
                                    albumName: 'ChatBizz')
                                .then((success) {
                              //for hiding bottom sheet
                              Navigator.pop(context);
                              if (success != null && success) {
                                Dialogs.showsnackbar(
                                    context, 'Image Successfully Saved!');
                              }
                            });
                          } catch (e) {
                            log('ErrorWhileSavingImg: $e');
                          }
                        }),

                //separator or divider
                if (isMe)
                  Divider(
                    color: Colors.white,
                    endIndent: sz.width * .04,
                    indent: sz.width * .04,
                  ),

                //edit option
                if (widget.messages.type == Type.text && isMe)
                  _OptionItem(
                      icon:
                          const Icon(Icons.edit, color: Colors.white, size: 26),
                      name: 'Edit Message',
                      onTap: () {
                        //for hiding bottom sheet
                        Navigator.pop(context);

                        _showMessageUpdateDialog();
                      }),

                //delete option
                if (isMe)
                  _OptionItem(
                      icon: const Icon(Icons.delete_forever,
                          color: Colors.red, size: 26),
                      name: 'Delete Message',
                      onTap: () async {
                        await APIs.deleteMessage(widget.messages).then((value) {
                          //for hiding bottom sheet
                          Navigator.pop(context);
                        });
                      }),

                //separator or divider
                Divider(
                  color: Colors.white,
                  endIndent: sz.width * .04,
                  indent: sz.width * .04,
                ),

                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.blue),
                    name:
                        'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.sent)}',
                    onTap: () {}),

                _OptionItem(
                    icon: const Icon(Icons.remove_red_eye, color: Colors.green),
                    name: widget.messages.read.isEmpty
                        ? 'Read At: Not seen yet'
                        : 'Read At: ${MyDateUtil.getMessageTime(context: context, time: widget.messages.read)}',
                    onTap: () {}),
              ],
            ),
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.messages.msg;

    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              contentPadding: const EdgeInsets.only(
                  left: 24, right: 24, top: 20, bottom: 10),

              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),

              //title
              title: const Row(
                children: [
                  Icon(
                    Icons.message,
                    color: Colors.black,
                    size: 28,
                  ),
                  Text(
                    ' Update Message',
                    style: TextStyle(color: Colors.black),
                  )
                ],
              ),

              //content
              content: TextFormField(
                initialValue: updatedMsg,
                maxLines: null,
                onChanged: (value) => updatedMsg = value,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15))),
              ),

              //actions
              actions: [
                //cancel button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    )),

                //update button
                MaterialButton(
                    onPressed: () {
                      //hide alert dialog

                      APIs.updateMessage(widget.messages, updatedMsg);
                      navigatorKey.currentState?.pop();
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ))
              ],
            ));
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () => onTap(),
        child: Padding(
          padding: EdgeInsets.only(
              left: sz.width * .05,
              top: sz.height * .015,
              bottom: sz.height * .015),
          child: Row(children: [
            icon,
            Flexible(
                child: Text('    $name',
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white, letterSpacing: 0.5)))
          ]),
        ));
  }
}
