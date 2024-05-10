import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/homeScreen.dart';
import 'package:flutter/material.dart';

// Global object for accessing device screen size;
late Size mq;
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const LoginScreen(),

    );
  }
}
