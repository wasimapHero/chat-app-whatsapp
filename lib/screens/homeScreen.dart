import 'dart:convert';
import 'dart:ffi';

import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:chat_app/Widgets/profile_User.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/spalshScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({ Key? key }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
// final list = [];  // ei list jokhon data asce kina check korbo, tokhon use korbo
  // ar eta model use korar somoy:
  List<Chat_cartUserModel> list = [];
  List<Chat_cartUserModel> _searchLettersList = []; // search list dorkar ekadhik result (similar) dekhanor jonno
  bool _isSearching = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    APIs.get_nd_store_userInfo();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: () {
          if (_isSearching) {
            setState(() {
              _isSearching = !_isSearching;
            });
           return Future.value(false);
          } else {
           return Future.value(true);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () {}, icon: Icon(CupertinoIcons.home)),
            title: _isSearching ? TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Name, email..",
                hintStyle: TextStyle(color: Color.fromARGB(255, 179, 159, 253), fontWeight: FontWeight.w200, fontSize: 15),
              ), 
              autofocus: true,
              onChanged: (value) {
                
                // age add kora thakle segula baad dite
                _searchLettersList.clear();
        
                for (var i in list) {
                  if (i.name!.toLowerCase().contains(value.toLowerCase()) || i.email!.toLowerCase().contains(value.toLowerCase())) {
                     _searchLettersList.add(i); // mil hyoa doc gula add hobe search list e
                     
                  }
                  setState(() {
                      // sob gula mil i add hyoar por ekbare update kora search list ke
                      _searchLettersList;
                  });
                }
        
              },
            ) : Text("We Chat"),
            actions: [
              IconButton(onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                });
              }, icon: _isSearching ? Icon(Icons.clear_outlined) : Icon(Icons.search)),
              IconButton(onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOfUser(user: APIs.curr_User_all_info)));
              }, icon: Icon(Icons.person)),
            ],
          ),
        
        
          floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 20, right: 10),
            child: FloatingActionButton(onPressed: () async {
              await FirebaseAuth.instance.signOut();
              await GoogleSignIn().signOut().then((value) => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen())));
            }, 
            // child: Icon(Icons.add_comment_rounded)
            child: Icon(Icons.logout)
            ),
          ),
        
          body: StreamBuilder(
            stream: APIs.getAllUsers(), 
            builder: (context, snapshot) {
              // builder er moddhe ar return er age code lekha jay
              switch (snapshot.connectionState) {
                // if data is loading
                case ConnectionState.waiting:
                case ConnectionState.none:
                  return Center(child: CircularProgressIndicator(),);
          
                // if some of the data is loaded / all of it loaded
                case ConnectionState.active:
                case ConnectionState.done:
                                
                // jokhon connection state thik ache, tokhon nicher moto data load koro:
          
                if (snapshot.hasData) {
                final data = snapshot.data?.docs;
                
                list = data?.map((e) => Chat_cartUserModel.fromJson(e.data())).toList() ?? [];
                // print("list[0]");
                // print(list[0].email);
          
          
          
          
                // evabe data firebase theke adoi ase kina check korba: (if er moddhe)
                // 
                // for (var i in data!) {
                //   print("\nPrint data coming from User Collection:\n ${i.data()}");
                //   list.add(i.data()['name']);
                //   print('Data: ${i.data()}');
                //   // print(jsonEncode(i.data()));
          
                // }
                //
              }
          
          
              }
          
          
              
          
              if (list.isNotEmpty) {
                return ListView.builder(
                itemCount: _isSearching ? _searchLettersList.length : list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder:  (context, index) {
                  return ChatCardUser(user: _isSearching ? _searchLettersList[index] : list[index],);
                  // return Text("Name: ${list[index]}"); // data asce kina dekhar jonno
            });
              } else {
                return Center(
                  child: Text("No data found!", style: TextStyle(fontSize: 30),),
                );
              }
            })
            ,
        ),
      ),
    );
  }
  
  
  
}


// 