
import 'dart:io';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/screens/Dialogs/dialogs.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    Future.delayed(Duration(milliseconds: 3500), () {
      setState(() {
        isAnimated = true;
      });
    });
    super.initState();
  }


  // login to google by clicking "login button"

  _loginButtonHandle()  { 
              // for showing progess bar
              Dialogs.showProgressBar(context);

              // signIn সফল হলে => 
              signInWithGoogle().then((user) async {

                  // for hiding progess bar
                    Navigator.pop(context);

                    if (user != null) {
                      print("\nUser email: ${user.user!.email}");
                    print("\nUser additionalUserInfo: ${user.additionalUserInfo}");


                            if ( await APIs.doesUserExists()) {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                            } else {
                              await APIs.createUser().then((value) {
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
                              });
                            }
                    }

              })
              ;
   }

    Future<UserCredential?> signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');
        // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ['profile', 'email']).signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
      
    } catch (e) {
      print("signin error: $e");
      Dialogs.showSnackBar(context, "Something went wrong (Check Internet!)");
      return null;
    }
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
                _loginButtonHandle();
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

      
    );
  }
}