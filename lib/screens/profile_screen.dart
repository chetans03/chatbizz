// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatbizz/api/apis.dart';
import 'package:chatbizz/constants/colors.dart';
import 'package:chatbizz/constants/common_fun.dart';
import 'package:chatbizz/helper/dialoge.dart';
import 'package:chatbizz/screens/auth/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:chatbizz/main.dart';
import 'package:chatbizz/models/chat_user.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  final ChatUser user;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isUpdating = false;
  String? _image;

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: Container(
            padding: EdgeInsets.all(5),
            height: 10,
            width: 10,
            child: Image.asset(
              "images/AppIcon.png",
              fit: BoxFit.fitHeight,
            ),
          ),
          title: Text(
            'ChatBizz',
            style: GoogleFonts.robotoCondensed(
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Dialogs.showProgressIndicator(context);
            await APIs.updateActiveStatus(false);
            await APIs.auth.signOut().then((value) async => {
                  await GoogleSignIn().signOut().then(
                        (value) => {
                          Navigator.pop(context),
                          Navigator.pop(context),
                          APIs.au = FirebaseAuth.instance,
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LoginScreen(),
                            ),
                          )
                        },
                      ),
                });
          },
          label: Text("Logout"),
          icon: Icon(Icons.logout),
        ),
        body: Container(
          height: sz.height,
          width: sz.width,
          decoration: const BoxDecoration(color: Colors.black),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * .05, vertical: height * .03),
                child: Column(
                  children: [
                    Stack(children: [
                      _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(height * .7),
                              child: Image.file(
                                File(_image!),
                                height: height * .19,
                                width: width * .4,
                                fit: BoxFit.fill,
                              ))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(height * .7),
                              child: CachedNetworkImage(
                                height: height * .19,
                                width: width * .4,
                                fit: BoxFit.fill,
                                imageUrl: widget.user.image,
                                // placeholder: (context, url) => CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    CircleAvatar(
                                  child: Icon(Icons.person),
                                ),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          shape: CircleBorder(),
                          color: black,
                          onPressed: _showBottomSheet,
                          child: Icon(
                            Icons.edit,
                            color: white,
                            size: 30,
                          ),
                        ),
                      )
                    ]),
                    CommonFun.Space(height * .02, 0),
                    Text(
                      widget.user.email,
                      style: GoogleFonts.poppins(
                        textStyle: TextStyle(fontSize: 20, color: white),
                      ),
                    ),
                    CommonFun.Space(height * .02, 0),
                    TextFormField(
                      onChanged: (value) => APIs.me.name = value,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : "Name Required",
                      initialValue: widget.user.name,
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        focusColor: white,
                        fillColor: black,
                        prefixIconColor: white,
                        prefixIcon: Icon(Icons.person),
                        hintText: "Eg. James Faulk",
                        label: Text(
                          "Name",
                          style: TextStyle(color: white),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    CommonFun.Space(height * .02, 0),
                    TextFormField(
                      onChanged: (value) => APIs.me.about = value,
                      validator: (value) => value != null && value.isNotEmpty
                          ? null
                          : "Hey, i am using ChatBizz",
                      initialValue: widget.user.about,
                      style: TextStyle(color: white),
                      decoration: InputDecoration(
                        focusColor: white,
                        fillColor: black,
                        prefixIconColor: white,
                        prefixIcon: Icon(Icons.info),
                        hintText: "Eg. Feeling happy !",
                        label: Text(
                          "About",
                          style: TextStyle(color: white),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    CommonFun.Space(height * .04, 0),
                    ElevatedButton.icon(
                      onPressed: () {
                        isUpdating = true;
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo();
                          isUpdating = false;
                          Dialogs.showsnackbar(context, "Updated Successfully");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundcolor,
                          foregroundColor: black,
                          minimumSize: Size(width * .03, height * .05)),
                      icon: Icon(Icons.edit),
                      label: isUpdating
                          ? const CircularProgressIndicator()
                          : Text("Update"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      context: context,
      builder: (_) {
        return ListView(
          padding: EdgeInsets.only(top: 10, bottom: 20),
          shrinkWrap: true,
          children: [
            Text(
              "Pick Profile",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                textStyle: TextStyle(fontSize: 20),
              ),
            ),
            CommonFun.Space(10, 0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: black,
                    shape: CircleBorder(),
                    elevation: 10,
                  ),
                  onPressed: () async {
                    final ImagePicker imagePicker = ImagePicker();
                    final XFile? image = await imagePicker.pickImage(
                        source: ImageSource.gallery);
                    if (image != null) {
                      log("path ${image.path}  + ${image.mimeType}");
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                    }

                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .15,
                    child: Image.asset(
                      "images/gallery.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: black,
                    shape: CircleBorder(),
                    elevation: 10,
                  ),
                  onPressed: () async {
                    final ImagePicker imagePicker = ImagePicker();
                    final XFile? image =
                        await imagePicker.pickImage(source: ImageSource.camera);
                    if (image != null) {
                      log("path ${image.path}  + ${image.mimeType}");
                      setState(() {
                        _image = image.path;
                      });
                      APIs.updateProfilePicture(File(_image!));
                    }

                    Navigator.pop(context);
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .15,
                    width: MediaQuery.of(context).size.width * .15,
                    child: Image.asset(
                      "images/camera.jpg",
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            CommonFun.Space(20, 0),
          ],
        );
      },
    );
  }
}
