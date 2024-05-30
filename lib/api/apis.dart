import 'dart:developer';
import 'dart:io';

import 'package:chatbizz/models/chat_user.dart';
import 'package:chatbizz/models/messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User user = auth.currentUser!;
  static late ChatUser chatUser;
  static FirebaseStorage storage = FirebaseStorage.instance;

//check if user is present or not
  static Future<bool> userExists() async {
    return (await firestore
            .collection("users")
            .doc(auth.currentUser!.uid)
            .get())
        .exists;
  }

//get information about self
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

//creating the user
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

//getting all users
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    log('inside get all user');
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: auth.currentUser!.uid)
        .snapshots();
  }

//updating name and about of the user
  static Future<void> updateSelfUser() async {
    await firestore.collection("users").doc(auth.currentUser!.uid).update(
      {'name': chatUser.name, 'about': chatUser.about},
    );
    log("updated name and about is ${chatUser.name} + ${chatUser.about}");
  }

//uploading or updating the users profile picture
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

  //************chatting apis**************** */

  //chat(collection)->conversationid -> messages(collection)-> message doc

// useful for getting conversation id
  static String getConversationID(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  // for getting all messages of a specific conversation from firestore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .snapshots();
  }

//sending message
  static Future<void> sendMessage(ChatUser chatuser, String msg) async {
    //used as id for sending time
    final time = DateTime.now().millisecondsSinceEpoch.toString();

    //message to send
    final Message message = Message(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);

    final ref = firestore
        .collection('chats/${getConversationID(chatuser.id)}/messages/');

    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageReadStatus(Message message) async {
    firestore
        .collection('chats/${getConversationID(message.fromId)}/messages/')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      ChatUser user) {
    return firestore
        .collection('chats/${getConversationID(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }
}
