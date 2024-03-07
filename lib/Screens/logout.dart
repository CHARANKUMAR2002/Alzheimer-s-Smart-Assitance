import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:s8/Components/google_auth_api.dart';
import 'package:s8/Screens/signin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:s8/main.dart';

class Logout extends StatefulWidget {
  const Logout({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {

  Color hover = Colors.transparent;

  getUserDetails() async
   {
    final snapshot = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc('personal_details').get();
    final data = snapshot.data();

    setState(() {
      profile = data!['profile'];
    });
   }

   var profile;

  sign_out()
  {
    GoogleSignInProvider().LogOut();
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Validate()));
  }

  upload() async
  {

    setState(() async{
    final ref = FirebaseStorage.instance.ref();
    final child = ref.child('/profiles/${FirebaseAuth.instance.currentUser!.email!.toString()}');
    final img = await ImagePicker.platform.pickImage(source: ImageSource.gallery,);
    child.putFile(File(img!.path),SettableMetadata(contentType: 'image/png'));
    print("Path : ${img!.path}");
    final link = await child.getDownloadURL();
    print(link);
    FirebaseFirestore.instance.collection('${FirebaseAuth.instance.currentUser!.email!}').doc('personal_details').update({'profile' : link});
    });
  }

  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
      Center(
        child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(141, 255, 38, 0)),
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Stack(
                    children: [
                      Center(child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage('${profile}'), fit: BoxFit.cover)), height: 100, width: 100,),),
                      Center(
                        child: Container(
                          padding: EdgeInsets.all(0),
                          height: 112,
                          width: 120,
                          child: 
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                
                                children: [
                                  SizedBox(height: 60,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(onPressed: (){upload();}, icon: Icon(Icons.edit_square)),
                                    ],
                                  ),
                                ],
                              )
                            
                        ),
                      )
                      
                    ],
                  ),
                  SizedBox(height: 15,),
                  Text('${FirebaseAuth.instance.currentUser!.displayName}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 20,),
                  Text('${FirebaseAuth.instance.currentUser!.email}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                  SizedBox(height: 20,),
                  ElevatedButton.icon(onPressed: sign_out, icon: Icon(FontAwesomeIcons.signOut), label: Text("Sign Out"),)
                ],
              ),
            ),
      ),
        
    );
  }
}