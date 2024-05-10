import 'package:chat_app/screens/homeScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({ Key? key }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isAnimated = false;

  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        isAnimated = true;
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to We Chat"),
        
      ),

      body: Stack(
        children: [
          AnimatedPositioned(
            top: mq.height* .15,
            right: !isAnimated ? mq.width* .25 : -mq.width* .5,
            width: mq.width* .5,
            duration: Duration(seconds: 1),
            child: Image.asset("assets/images/chatting-app.png")
            ),

            Positioned(
            bottom: mq.height* .15,
            left: mq.width* .11,
            width: mq.width* .75,
            height: mq.width* .1,
            child: ElevatedButton.icon(
               onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
               }, 
               style: ElevatedButton.styleFrom(backgroundColor: Color.fromARGB(255, 239, 234, 251), shape: StadiumBorder(), elevation: 1),
               label: RichText(text: TextSpan(
                style: TextStyle(color: Colors.black, fontSize: 17),
                children: [
                  TextSpan(text: "Login with "),
                  TextSpan(text: "Google", style: TextStyle(fontWeight: FontWeight.w500)),

                ]
              ),  
               ),
               icon: Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: Image.asset("assets/images/google.png"),
               ) 
               )
            ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 20, right: 10),
        child: FloatingActionButton(onPressed: () {}, child: Icon(Icons.add_comment_rounded)),
      ),
    );
  }
}