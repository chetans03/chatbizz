// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/helper/my_date_util.dart';
import 'package:chatbizz/main.dart';
import 'package:flutter/material.dart';

import 'package:chatbizz/models/messages.dart';
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
  Widget build(BuildContext context) {
    return APIs.user.uid == widget.messages.fromId
        ? _greenMessage()
        : _blueMessage();
  }

  Widget _blueMessage() {
    // if (widget.messages.read.isEmpty) {
    //   APIs.updateMessageReadStatus(widget.messages);
    // }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: sz.width * .03, vertical: sz.height * .01),
            margin: EdgeInsets.symmetric(horizontal: sz.width * .03),
            decoration: BoxDecoration(
              color: bluebubble,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
            ),
            child: Text(
              widget.messages.msg,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 15, color: black),
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
                  fontSize: 15, color: grey, fontWeight: FontWeight.w300),
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
            // if (widget.messages.read.isNotEmpty)
            Icon(
              Icons.done_all_rounded,
              color: Colors.blue,
            ),
            Text(
              MyDateUtil.getFormatedTime(
                  context: context, time: widget.messages.sent),
              style: GoogleFonts.poppins(
                textStyle: TextStyle(
                    fontSize: 15, color: grey, fontWeight: FontWeight.w300),
              ),
            ),
          ]),
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal: sz.width * .03, vertical: sz.height * .01),
            margin: EdgeInsets.symmetric(horizontal: sz.width * .03),
            decoration: BoxDecoration(
              color: whitebubble,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            child: Text(
              widget.messages.msg,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 15, color: black),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
