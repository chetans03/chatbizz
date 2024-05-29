import 'dart:developer';
import 'dart:io';

import 'package:chatbizz/models/chat_user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User user = auth.currentUser!;
  static late ChatUser chatUser;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<bool> userExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

  static Future<void> getSelfUserInfo() async {
    await firestore.collection("users").doc(auth.currentUser!.uid).get().then(
          (user) async => {
            if (user.exists)
              {chatUser = ChatUser.fromJson(user.data()!)}
            else
              {await createUser().then((value) => getSelfUserInfo())}
          },
        );
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final ChatUser chatUser = ChatUser(
        image: user.photoURL.toString(),
        about: "Hey , i am using ChatBizz",
        name: user.displayName.toString(),
        createdAt: time,
        id: user.uid,
        lastActive: time,
        isOnline: false,
        pushToken: '',
        email: user.email.toString());

    await firestore.collection("users").doc(user.uid).set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    log('inside get all user');
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

  static Future<void> updateSelfUser() async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update(
      {'name': chatUser.name, 'about': chatUser.about},
    );
    log("updated name and about is ${chatUser.name} + ${chatUser.about}");
  }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;

    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');

    await ref.putFile(file).then(
      (p0) {
        log('insede then');
        log("data ${p0.bytesTransferred / 1000} kb");
      },
    );

    chatUser.image = await ref.getDownloadURL();
    log(" url is ${ref.getDownloadURL()}");
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': chatUser.image});
  }
}
