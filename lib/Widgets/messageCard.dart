// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Dialogs/my_date_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/massage.dart';

class MessageCard extends StatefulWidget {

  final Message message;
  MessageCard({
    Key? key,
    required this.message,
  }) : super(key: key);

  @override
  _MessageCardState createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return APIs.current_User.uid == widget.message.fromId 
    ? _greenMessages() 
    : _blueMessages() ;
  }

  // other user's message
  Widget _blueMessages() {


    // update the read status if the sender and receiver are different
    if(widget.message.readTime.isEmpty) {
      APIs.updateReadStatus(widget.message);
      print("readTime updated, ==${widget.message.readTime}===");
    }

    //
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      // crossAxisAlignment: CrossAxisAlignment.end,
      children: [

          // blue message
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:  widget.message.msgType == Type.text ? mq.width*0.04 : 0, 
                                          vertical: widget.message.msgType == Type.text ? mq.width*0.03 : 0),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.height*0.02),
            decoration: BoxDecoration(
              borderRadius: widget.message.msgType == Type.text ? BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30), topLeft: Radius.circular(30))
                            : BorderRadius.circular(0),
              border: Border.all(color: Colors.lightBlueAccent),
              color: Color.fromARGB(255, 231, 246, 250)
            ),
            child: widget.message.msgType == Type.text ?
            Text(widget.message.msg, style: TextStyle(fontSize: 15,  color: Colors.black87),)
            : ClipRRect(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
                        errorWidget: (context, url, error) => Icon(Icons.image, size: 70,),
                    ),
                                ),
          ),
        ),

        // read time section

        Container(
          padding: EdgeInsets.only(right: mq.width*0.04),
          child: Text(
            MyDateUtil.getFormattedTime(context: context, time: widget.message.sentTime)
            , style: TextStyle(fontSize: 13, color: Colors.black54),)
            ),
        
      ],
    );
  }
  
  // my message
  Widget _greenMessages() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [

        Row(
          children: [
            SizedBox(width: mq.width*0.04,),
            // one line if, without the bracket
            widget.message.readTime.isNotEmpty ?
            Icon(Icons.done_all_rounded, color: Colors.lightBlueAccent.shade400, size: 15,)
            : Icon(Icons.done_all_rounded, color: Colors.black54, size: 15,)   ,
            Container(
              margin: EdgeInsets.symmetric(horizontal: mq.width*0.01, vertical: mq.height*0.02),
              child: Text(
                MyDateUtil.getFormattedTime(context: context, time: widget.message.sentTime)
                , style: TextStyle(fontSize: 13, color: Colors.black54),)),
          ],
        ),
          //
        Flexible(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:  widget.message.msgType == Type.text ? mq.width*0.04 : 0, 
                                          vertical: widget.message.msgType == Type.text ? mq.width*0.03 : 0),
            margin: EdgeInsets.symmetric(horizontal: mq.width*0.04, vertical: mq.height*0.02),
            decoration: BoxDecoration(
              borderRadius: widget.message.msgType == Type.text ? BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30), topLeft: Radius.circular(30))
                            : BorderRadius.circular(0),
              border: Border.all(color: Colors.lightGreen),
              color: Color.fromARGB(255, 223, 251, 235)
            ),
            child: widget.message.msgType == Type.text ?
            Text(widget.message.msg, style: TextStyle(fontSize: 15,  color: Colors.black87),)
            : ClipRRect(
                    child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: widget.message.msg,
                        placeholder: (context, url) => CircularProgressIndicator(strokeWidth: 2,),
                        errorWidget: (context, url, error) => Icon(Icons.image, size: 70,),
                    ),
                                ),
          ),
        ),
        
      ],
    );
  }
}