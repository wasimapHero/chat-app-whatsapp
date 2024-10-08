// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/APIs/apis.dart';
import 'package:chat_app/Widgets/chatCard_User.dart';
import 'package:chat_app/screens/Auth/login_screen.dart';
import 'package:chat_app/screens/Dialogs/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/Models/chat_cartUserModel.dart';
import 'package:chat_app/main.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

class ProfileOfUser extends StatefulWidget {
  final Chat_cartUserModel user;

  ProfileOfUser({
    Key? key,
    required this.user,
  }) : super(key: key);

  

  @override
  _ChatCardUserState createState() => _ChatCardUserState();
}

class _ChatCardUserState extends State<ProfileOfUser> {

  // formkey te form er state store
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {

    mq = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text("Profile")),
        // body
        body: Form(
          // key sthapon
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
                
              child: Column(
                children: [
                  SizedBox(width: mq.width, height: mq.height*0.03,),
                  Stack(
                    children: [ 
                      _image != null ? 
                      ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height *0.09),
                    child: Image.file(
                        File(_image!),
                        width: mq.width * .35,
                        height: mq.height * .18,
                        fit: BoxFit.cover,
                    ),
                                ) : 

                       ClipRRect(
                    borderRadius: BorderRadius.circular(mq.height *0.09),
                    child: CachedNetworkImage(
                        width: mq.height * .18,
                        height: mq.height * .18,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image!,
                        errorWidget: (context, url, error) => Icon(CupertinoIcons.person),
                    ),
                                ),

                       //
                       Positioned(child: MaterialButton(onPressed: () {
                        _showBottomSheet();
                       }, shape: CircleBorder(side: BorderSide(color: Color.fromARGB(255, 93, 42, 182), width: 1)), child: Icon(Icons.edit, color: Color.fromARGB(255, 93, 42, 182),), color: Colors.white,), bottom: -6, right: -20,)
                  ]),
                  SizedBox(width: mq.width, height: mq.height*0.03,),
                  Text(widget.user.email!, style: TextStyle(color: Colors.black54, fontSize: 16),),
                  SizedBox(width: mq.width, height: mq.height*0.05,),

                  TextFormField(
                    initialValue: widget.user.name,
                    onSaved: (newValue) => APIs.curr_User_all_info.name = newValue ?? " ", // value null hole " ", curr user e rakho, porer line e validate hobe
                    // ?? othoba bujhay
                    // ?   :   if else bujhau=y
                    validator: (value) => value != null && value.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      hintText: "e.g Meena Akter",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(CupertinoIcons.person),
                      labelText: "Name"
                    ),
                  ),
                  SizedBox(width: mq.width, height: mq.height*0.03,),
                  
                  TextFormField(
                    initialValue: widget.user.about,
                     onSaved: (newValue) => APIs.curr_User_all_info.about = newValue ?? " ", // value null hole " ", curr user e rakho, porer line e validate hobe
                    // ?? othoba bujhay
                    // ?   :   if else bujhau=y
                    validator: (value) => value != null && value.isNotEmpty ? null : 'Required Field',
                    decoration: InputDecoration(
                      hintText: "e.g I'm feeling very happy",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: Icon(CupertinoIcons.info_circle),
                      labelText: "About"
                    ),
                  ),
              
                  SizedBox(width: mq.width, height: mq.height*0.07,),
                  ElevatedButton.icon(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        log('validator worked.');
                        APIs.updateProfileInfo().then((value) {
                          // Get.defaultDialog(content: AboutDialog(children: [Text("abc hello")],));
                          Get.snackbar('Title', 'Profile Updated successfully!');
                          Dialogs.showSnackBar(context, 'Profile Updated successfully!');
                          
                        });
                      }
                      
                    }, icon: Icon(Icons.edit), label: Text("Update"),
                    style: ElevatedButton.styleFrom(elevation: 0, shape: StadiumBorder(side: BorderSide(color: Color.fromARGB(255, 169, 122, 240), width : 1.0)), minimumSize: Size(mq.width*0.4, mq.height*0.06), backgroundColor: Color.fromARGB(255, 231, 214, 244)),
                    ),
              
                
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(onPressed: () async {
          //to show dialog of progress bar
          Dialogs.showProgressBar(context);
            await APIs.auth.signOut().then((value) async {
              await GoogleSignIn().signOut().then((value) {
                // to hide progress bar
                Navigator.pop(context);
      
                // to move to previous page which is home screen
                Navigator.pop(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
              } 
              
              
        );
        });
            
          }, 
          // child: Icon(Icons.add_comment_rounded)
          child: Icon(Icons.logout)
          ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(context: context,
    // backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20), topRight: Radius.circular(20)
      ),
    ), 
    builder: (_) {
      return ListView(
        shrinkWrap: true,
        padding: EdgeInsets.only(top: mq.height*0.03, bottom: mq.height*0.05),
        children: [
          Text("Pick Profile Picture", textAlign: TextAlign.center, style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
          SizedBox(height: mq.height*0.01,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(mq.width*0.3, mq.height*0.15)
                ),
                onPressed: () async{
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
                  if (image != null) {
                    // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                    Get.back();
                    Get.snackbar('${image.name}', '${image.path}');
                    setState(() {
                      _image = image.path;
                    });
                    APIs.updateProfilePicture(File(_image!));
                  } 
                },
                child: Image.asset("assets/images/add_image.png")),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  fixedSize: Size(mq.width*0.3, mq.height*0.15)
                ),
                onPressed: () async{
                  final ImagePicker picker = ImagePicker();
                  // Pick an image.
                  final XFile? image = await picker.pickImage(source: ImageSource.camera);
                  if (image != null) {
                    // log('image path:  ${image.name} -- mimeType: ${image.mimeType}');

                    Get.back();
                    Get.snackbar('${image.name}', '${image.path}');
                    setState(() {
                      _image = image.path;
                    });
                    APIs.updateProfilePicture(File(_image!));
                  } 
                },
                child: Image.asset("assets/images/camera.png")),
              
            ],
          )
        ],
      );
    });
  }


}