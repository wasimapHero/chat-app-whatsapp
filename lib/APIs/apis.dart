import 'dart:io';

import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class APIs {
  // for firebase authentication
  static FirebaseAuth auth = FirebaseAuth.instance;

  // for firebase firestore
  static FirebaseFirestore cloud_firestore = FirebaseFirestore.instance;

  // for firebase firestore
  static FirebaseStorage firebase_storage = FirebaseStorage.instance;

  // firebase theke login info -> current User ke and tar userId retrive, jeta matro login korlo
  static User get current_User => auth.currentUser!;

  static Future<bool> doesUserExists() async {
    return (await cloud_firestore
            .collection('users')
            .doc(current_User.uid)
            .get())
        .exists;
    // get() diye uid sombilito doc collect korlo.
    // doc pele return true; na pele false pathabe.
  }

  static late Chat_cartUserModel curr_User_all_info;

  // to store current_User's doc e rakha baki info in a global variable "curr_User_all_info"

  static Future<void> get_nd_store_userInfo() async {
    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .get()
        .then((user) {
      // user ta holo current user er doc file
      if (user.exists) {
        curr_User_all_info = Chat_cartUserModel.fromJson(user.data()!);
        // kintu user er sob data json obj e ache bole convert korte holo

        print("Current User's data: ${user.data()}");
      } else {
        createUser().then((value) => get_nd_store_userInfo());
      }
    });
  }

  static Future<void> createUser() async {
    // Now time get
    final time = DateFormat.jm().format(DateTime.now()).toString();
    // final formatted_Time = DateFormat.jm(time).toString();
    final newUserData = Chat_cartUserModel(
        about: "Lovely Runner💜💜",
        email: current_User.email,
        id: current_User.uid,
        image: current_User.photoURL,
        isOnline: true,
        lastActive: time,
        name: current_User.displayName,
        pushToken: "");

    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .set(newUserData.toJson());
    // je login korlo, tar info sathe sathe firebase er cloudstore e gelo. json hisebe.
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return cloud_firestore
        .collection('users')
        .where('id', isNotEqualTo: current_User.uid)
        .snapshots();
  }

  static Future<void> updateProfileInfo() async {
    await cloud_firestore.collection('users').doc(current_User.uid).update(
        {'name': curr_User_all_info.name, 'about': curr_User_all_info.about});
  }

  // update profile pic
  static Future<void> updateProfilePicture(File file) async {
    // path of storage image file:
    // userUid.jpg inside profile_picture folder
    // .jpg ba .peg extension pete:
    final extension = file.path.split('.').last;
    print('Extension: $extension');
    final ref = await firebase_storage
        .ref()
        .child('profile_picture/${current_User.uid}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      print('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    // url niye update kora firebase cloud store e
    curr_User_all_info.image = await ref.getDownloadURL();

    await cloud_firestore
        .collection('users')
        .doc(current_User.uid)
        .update({'image': curr_User_all_info.image});
  }

  //**************************  Chat related APIs  ******************************* */

  //  chats (collection) --> conversation_id (doc) --> messages (collection) --> message (doc)

  ///  useful for getting a conversation id
  ///  The hashCode property simply returns a number.So, lets say two users A and B are chatting,
  ///  so in order to fetch messages between A(eg, hashCode=11) and B(eg, hashCode=22), this has to be stored in the same firestore collection,
  ///  for that we need a unique id(groupChatId). If we were to create groupChatId(here groupChatId is used as the key for the firestore collection) simply by
  ///  '$curentId-$peerId' groupChatId would be 11-22 for A and 22-11 for B, which would result in two collections. Instead if we use the logic of:
  //   if (currentId.hashCode <= peerId.hashCode) {
  //      groupChatId = '$currentId-$peerId';
  //   } else {
  //      groupChatId = '$peerId-$currentId';
  //   }
  ///  groupChatId will be 11-22 for both A and B, hence the same firestore collection can be used to write and read from.
  ///
  static String getConversationId(String id) => current_User.uid.hashCode <=
          id.hashCode
      ? '${current_User.uid}_$id'
      : '${id}_${current_User.uid}'; // এখানে id হলো peerId, আর current_User.uid হলো currentId

  // to get all messages of a specific conversation from cloudstore database
  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      Chat_cartUserModel chatuser) {
    return cloud_firestore
        .collection(
            'chats/${getConversationId(chatuser.id.toString())}/messages')
            .orderBy('sent_time', descending: true)
        .snapshots();
    // chatuser is: peer user
  }

  // for sending message
  static Future<void> sendMessage(
      Chat_cartUserModel chatuser, String msg, Type type) async {
    // chatuser is: peer user
    // message sending time (also used as id)
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    // make string msg to a modeled message
    Message message = Message(
        msg: msg,
        sentTime: time,
        fromId: current_User.uid,
        readTime: '',
        msgType: type,
        toId: chatuser.id.toString());
    final ref = cloud_firestore.collection(
        'chats/${getConversationId(chatuser.id.toString())}/messages');
    ref.doc(time).set(message.toJson());
  }

  // update read status of message
  static Future<void> updateReadStatus(Message message) async {
    cloud_firestore
        .collection('chats/${getConversationId(message.fromId)}/messages')
        .doc(message.sentTime)
        .update(
            {'read_time': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  // to get only last message
  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      Chat_cartUserModel chatuser) {
    return cloud_firestore
        .collection(
            'chats/${getConversationId(chatuser.id.toString())}/messages')
        .orderBy('sent_time', descending: true)
        .limit(1)
        .snapshots();
    // chatuser is: peer user
  }

  // to upload image of chat into database
  static Future<void> sendChatImage(
      Chat_cartUserModel chatUser, File file) async {
    // path of storage image file:
    // userUid.jpg inside profile_picture folder
    // .jpg ba .peg extension pete:
    final extension = file.path.split('.').last;
    print('Extension: $extension');

    final ref = await firebase_storage.ref().child(
        'images/${getConversationId(chatUser.id.toString())}/${DateTime.now().millisecondsSinceEpoch}.$extension');

    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$extension'))
        .then((p0) {
      print('Data Transferred ${p0.bytesTransferred / 1000} kb');
    });

    // url niye update kora firebase cloud store e
    final imageUrl = await ref.getDownloadURL();

    await sendMessage(chatUser, imageUrl, Type.image);
  }
}
