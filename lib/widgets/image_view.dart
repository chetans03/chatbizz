import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/messages.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  ImageView({super.key, required this.message});
  Message? message;

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        iconTheme: IconThemeData(color: white),
      ),
      backgroundColor: black,
      body: Center(
        child: Container(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(sz.height * .03),
            child: CachedNetworkImage(
              width: sz.height * .4,
              height: sz.height * .4,
              fit: BoxFit.cover,
              imageUrl: widget.message!.msg,
              placeholder: (context, url) => Padding(
                padding: EdgeInsets.all(100),
                child: const CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) =>
                  const CircleAvatar(child: Icon(CupertinoIcons.person)),
            ),
          ),
        ),
      ),
    );
  }
}
