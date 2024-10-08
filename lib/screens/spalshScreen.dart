

import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


      @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 1000), () {

      if (FirebaseAuth.instance.currentUser != null) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
      }

      /// exit full screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(systemNavigationBarColor: Colors.white,  statusBarColor: Colors.white)
      );
      ///
      
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
          Positioned(
            top: mq.height* .15,
            right:  mq.width* .25 ,
            width: mq.width* .5,
            child: Image.asset("assets/images/chatting-app.png")
            ),

            Positioned(
            bottom: mq.height* .15,
            left: mq.width* .11,
            width: mq.width* .75,
            height: mq.width* .1,
            child: Center(child: Text("Made solely by Esty!💜"))
            ),
        ],
      ),

      
    );
  }
}