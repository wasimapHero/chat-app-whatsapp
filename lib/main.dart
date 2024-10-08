import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:chat_app/screens/spalshScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


// Global object for accessing device screen size;
late Size mq;
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _initialize_Firebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // title: 'We Chat',
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.black),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 1,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 19, fontWeight: FontWeight.normal),
          backgroundColor: Colors.white
        )
      ),
      debugShowCheckedModeBanner: false,
      // home: const HomeScreen(),
      home: const SplashScreen(),
      // home: LoginScreen(),

    );
  }
}



_initialize_Firebase() async{
 await Firebase.initializeApp (
   options: DefaultFirebaseOptions.currentPlatform,
 );
} 