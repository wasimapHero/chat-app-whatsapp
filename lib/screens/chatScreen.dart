// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Widgets/messageCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Models/massage.dart';
import 'package:chat_app/main.dart';
import 'package:image_picker/image_picker.dart';

class ChatScreen extends StatefulWidget {
  //
  final Chat_cartUserModel user;
  ChatScreen({
    Key? key,
    required this.user,
  }) : super(key: key);

  //

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // call message class ad create list of msg
  late List<Message> _msgList = [];

  TextEditingController _sent_textController = TextEditingController();
  ScrollController _scrollController = ScrollController();

  bool _showEmoji = false;
  // to check if images are uploading or not
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),

        // if emoji button is shown and back button is pressed,
        // then at first, emoji button will be closed/hide
        // else, will go back to back page
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            //
            backgroundColor: Color.fromARGB(244, 249, 249, 254),

            //
            body: Column(
              children: [
                Expanded(
                    child: StreamBuilder(
                  // ekhane widget.user holo: peer user
                  stream: APIs.getAllMessages(widget.user),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Text("No connection found");
                      case ConnectionState.active:
                      case ConnectionState.done:
                        //
                        // if(snapshot.hasData) {
                        //   final data = snapshot.data!.docs;
                        //   print('Data (message) : ${jsonEncode(data[0].data())}');
                        //   final msg = jsonEncode(data[0].data());
                        //   // Data (message) : {"msg":"hi hello bye","sent_time":"294865hjg","from_Id":"3845t7746","read_time":"zfghbhbn","msg_type":"image jpg","to_Id":"05846748678"}
                        //   return Text("data");
                        // } else {
                        //   return Text("snapshot has no data");
                        // }

                        final data = snapshot.data!.docs;
                        _msgList = data
                                .map((e) => Message.fromJson(e.data()))
                                .toList() ??
                            [];

                        if (_msgList.isNotEmpty) {
                          return ListView.builder(
                            // to show the last item always
                              reverse: true,
                              itemCount: _msgList.length,
                              // controller: _scrollController,
                              itemBuilder: (context, index) {
                                return MessageCard(message: _msgList[index]);
                              });
                        } else {
                          return Center(
                            child: Text(
                              "Hi! 👋",
                              style: TextStyle(fontSize: 30),
                            ),
                          );
                        }
                    }
                  },
                )),
                _chatInput(),
                if (_showEmoji)
                  SizedBox(
                      height: mq.height * 0.35,
                      child: EmojiPicker(
                        textEditingController: _sent_textController,
                        config: Config(
                            emojiViewConfig: EmojiViewConfig(
                          backgroundColor: Colors.transparent,
                          emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                          columns: 8,
                        )),
                      ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return Row(
      children: [
        IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black54,
            )),
        ClipRRect(
          borderRadius: BorderRadius.circular(mq.width * 0.05),
          child: CachedNetworkImage(
            width: mq.width * .1,
            height: mq.height * .053,
            fit: BoxFit.fill,
            imageUrl: widget.user.image!, // peer user image
            errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // peer user name
            Text(
              "${widget.user.name}",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
            Text(
              "Active 10m ago",
              style: TextStyle(
                  fontSize: 13, color: Color.fromARGB(255, 122, 121, 121)),
            ),
          ],
        )
      ],
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mq.height * 0.01, horizontal: mq.width * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(mq.height * .5)),
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: Icon(
                        Icons.emoji_emotions_outlined,
                        color: Colors.black54,
                      )),
                  Expanded(
                    child: TextField(
                      onTap: () {
                        setState(() {
                          if (_showEmoji) _showEmoji = !_showEmoji;
                        });
                      },
                      controller: _sent_textController,
                      keyboardType: TextInputType.multiline,
                      maxLength: null,
                      maxLines: null,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Message",
                          hintStyle: TextStyle(color: Colors.black54)),
                    ),
                  ),

                  // gallery theke pic send
                  IconButton(
                      onPressed: () async{
                        final ImagePicker picker = ImagePicker();
                        // Pick multiple images.
                        final List<XFile>? images = await picker.pickMultiImage(imageQuality: 70);

                        if (images != null) {

                          // upload to db one by one
                          for (var i in images) {
                            // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                            // Get.snackbar('${image.name}', '${image.path}');

                            APIs.sendChatImage(widget.user, File(i.path));
                          }
                        }
                      },
                      icon: Icon(
                        Icons.image_outlined,
                        color: Colors.black54,
                      )),

                      // camera theke pic send
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 70);

                        if (image != null) {
                          // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                          // Get.snackbar('${image.name}', '${image.path}');

                          APIs.sendChatImage(widget.user, File(image.path));
                        }
                      },
                      icon: Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.black54,
                      )),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: mq.width * 0.1,
            child: MaterialButton(
              onPressed: () {
                if (_sent_textController.text.isNotEmpty) {
                  // msg + peer user er id pathacchi
                  APIs.sendMessage(
                      widget.user, _sent_textController.text, Type.text);
                  _sent_textController.text = '';

                  // message send korle jate scroll kore end auto dekhay
                  _scrollController.animateTo(
                      _scrollController.position.extentBefore,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut);
                }
              },
              shape: CircleBorder(),
              padding: EdgeInsets.only(top: 9, bottom: 9, right: 5, left: 6),
              child: Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 17,
              ),
              color: Color(0xFF1DAB61),
            ),
          ),
        ],
      ),
    );
  }
}
