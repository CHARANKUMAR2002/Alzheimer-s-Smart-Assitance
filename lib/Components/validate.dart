import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:s8/Screens/home.dart';

class Validator extends StatefulWidget {
  

  const Validator({super.key, required this.newUser});

  final newUser;

  @override
  State<Validator> createState() => _ValidatorState();
}

class _ValidatorState extends State<Validator> {

  TextEditingController id = TextEditingController();

    getUserDetails() async
   {
    final snapshot = await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc('personal_details').get();
    final data = snapshot.data();

    setState(() {
      user = data!['current_user'];
    });
   }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  var user;



  

  @override
  Widget build(BuildContext context) {

    var currentUser = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
          {
            if(widget.newUser)
            {
              return AlertDialog(
                title: Text("User Type"),
                content: Text("Specify Your user type"),
                actions: [
                  ElevatedButton(
                    onPressed: (){
                    showDialog(
                      context: context, 
                      builder: (BuildContext context)
                      {
                        return AlertDialog(title: Text("Fetch Patient's Details"),
                content: TextField(
                  decoration: InputDecoration(label: Text("Enter Patient's mail id")),
                  controller: id,
                ),
                actions: [
                  ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("Cancel")),
                  ElevatedButton(onPressed: ()async{
                      setState(() {
                        FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc('personal_details')
                    .set(
                      {
                        'current_user' : id.text,
                        'name' : currentUser!.displayName,
                        'profile' : 'https://imgv3.fotor.com/images/blog-richtext-image/10-profile-picture-ideas-to-make-you-stand-out.jpg',
                        'email' : currentUser!.email
                        }
                      );
                      });
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home(currentUser: id.text,)));
                    }, child: Text("OK")),

                ],
                );
                      }
                      );
                }, child: Text("Family Member")),
                  ElevatedButton(onPressed: () async{
                    
                      setState(() {
                        FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.email!).doc('personal_details')
                    .set(
                      {
                        'current_user' : currentUser!.email,
                        'name' : currentUser!.displayName,
                        'profile' : 'https://imgv3.fotor.com/images/blog-richtext-image/10-profile-picture-ideas-to-make-you-stand-out.jpg',
                        'email' : currentUser!.email
                        }
                      );
                      });
                    await Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Home(currentUser: currentUser!.email,)));
                    }, child: Text("Patient")),
                ],
              );
            }
            else
            {
              return Home(currentUser: user);
            }
          }
          if(snapshot.hasError)
          {
            return Center(child: Text("Something went wrong"),);
          }
          return Center(child: CircularProgressIndicator(),);
          
        },
      ),
    );
  }
}