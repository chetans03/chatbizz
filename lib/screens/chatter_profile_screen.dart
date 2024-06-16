import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../helper/my_date_util.dart';
import '../main.dart';
import '../models/chat_user.dart';

//view profile screen -- to view profile of user
class ChatterProfileScreen extends StatefulWidget {
  final ChatUser user;

  const ChatterProfileScreen({super.key, required this.user});

  @override
  State<ChatterProfileScreen> createState() => _ChatterProfileScreenState();
}

class _ChatterProfileScreenState extends State<ChatterProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // for hiding keyboard
      onTap: FocusScope.of(context).unfocus,
      child: Scaffold(
          //app bar
          appBar: AppBar(
              backgroundColor: black,
              iconTheme: IconThemeData(color: white),
              title: Text(
                widget.user.name,
                style: TextStyle(color: white),
              )),
          backgroundColor: black,

          //user about
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Joined On: ',
                  style:
                      GoogleFonts.poppins(textStyle: TextStyle(color: white))),
              Text(
                  MyDateUtil.getLastMessageTime(
                      context: context,
                      time: widget.user.createdAt,
                      showYear: true),
                  style:
                      GoogleFonts.poppins(textStyle: TextStyle(color: white))),
            ],
          ),

          //body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: sz.width * .05),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // for adding some space
                  SizedBox(width: sz.width, height: sz.height * .03),

                  //user profile picture
                  ClipRRect(
                    borderRadius: BorderRadius.circular(sz.height * .1),
                    child: CachedNetworkImage(
                      width: sz.height * .2,
                      height: sz.height * .2,
                      fit: BoxFit.cover,
                      imageUrl: widget.user.image,
                      errorWidget: (context, url, error) => const CircleAvatar(
                          child: Icon(CupertinoIcons.person)),
                    ),
                  ),

                  // for adding some space
                  SizedBox(height: sz.height * .03),

                  // user email label
                  Text(widget.user.email,
                      style: GoogleFonts.poppins(
                          textStyle: TextStyle(color: white))),

                  // for adding some space
                  SizedBox(height: sz.height * .02),

                  //user about
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('About: ',
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: white))),
                      Text(widget.user.about,
                          style: GoogleFonts.poppins(
                              textStyle: TextStyle(color: white))),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
