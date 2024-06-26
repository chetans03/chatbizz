import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/screens/chatter_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileDialog extends StatelessWidget {
  const ProfileDialog({super.key, required this.user});

  final ChatUser user;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      backgroundColor: Colors.white.withOpacity(.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SizedBox(
          width: sz.width * .6,
          height: sz.height * .35,
          child: Stack(
            children: [
              //user profile picture
              Positioned(
                top: sz.height * .075,
                left: sz.width * .1,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(sz.height * .25),
                  child: CachedNetworkImage(
                    width: sz.width * .5,
                    height: sz.width * .5,
                    fit: BoxFit.cover,
                    imageUrl: user.image,
                    errorWidget: (context, url, error) =>
                        const CircleAvatar(child: Icon(CupertinoIcons.person)),
                  ),
                ),
              ),

              //user name
              Positioned(
                left: sz.width * .04,
                top: sz.height * .02,
                width: sz.width * .55,
                child: Text(user.name,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500)),
              ),

              //info button
              Positioned(
                  right: 8,
                  top: 6,
                  child: MaterialButton(
                    onPressed: () {
                      //for hiding image dialog
                      Navigator.pop(context);

                      //move to view profile screen
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  ChatterProfileScreen(user: user)));
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.all(0),
                    shape: const CircleBorder(),
                    child: const Icon(Icons.info_outline,
                        color: Colors.black, size: 30),
                  ))
            ],
          )),
    );
  }
}
