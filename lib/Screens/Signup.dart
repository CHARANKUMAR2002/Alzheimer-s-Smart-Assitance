import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s8/Components/validate.dart';
import 'package:s8/Screens/signin.dart';
import '../Components/google_auth_api.dart';

class Sign_Up extends StatefulWidget {
  const Sign_Up({super.key});

  @override
  State<Sign_Up> createState() => _Sign_UpState();
}

class _Sign_UpState extends State<Sign_Up> {

  var currentUser = FirebaseAuth.instance.currentUser;
  
  final firestore = FirebaseFirestore.instance;

  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? user;

  GoogleSignInAccount get User => user!;


  google_signup() async
  {
    try{
      await GoogleSignInProvider().googleLogin();
      var userDetails = 
  {
    'name' : FirebaseAuth.instance.currentUser!.displayName,
    'email' : FirebaseAuth.instance.currentUser!.email,
    'profile' : FirebaseAuth.instance.currentUser!.photoURL
  };
      await firestore.collection(currentUser!.email!).doc('personal_details').set(userDetails);
      await firestore.collection(currentUser!.email!).doc('personal_details').set(userDetails);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Validator(newUser: true)));
    }
    catch(e)
    {

    }
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController userid = TextEditingController();
  final formkey = GlobalKey<FormState>();
  bool hide = true;
  var icon = Icon(FontAwesomeIcons.eye, color: const Color.fromARGB(255, 255, 255, 255), size: 20,);
  Future signup() async {
    final isValid = formkey.currentState!.validate();
    if (!isValid)
      return showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              content: Text("Please fill the details"),
              actions: [
                CupertinoButton(
                    child: Text("OK"), onPressed: () => Navigator.pop(context))
              ],
            );
          });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text.trim(), password: password.text.trim());

      if (FirebaseAuth.instance.currentUser != null) {
        FirebaseAuth.instance.currentUser!
            .updateDisplayName(userid.text.toString());
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text("Your Account Has Been Created Successfully !"),
                actions: [
                  CupertinoButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(builder: (context) => Validator(newUser: true,)));
                      }),
                ],
              );
            });
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                content: Text(e.message!),
                actions: [
                  CupertinoButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(context);
                        email.text = '';
                        password.text = '';
                        userid.text = "";
                      })
                ],
              );
            });
      });
    }
    CupertinoAlertDialog(
      content: Text("An account already exists for that email"),
      actions: [
        CupertinoButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.pop(context);
              email.text = '';
              password.text = '';
              userid.text = "";
            })
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    

    return Scaffold(
      body: SafeArea(
        child: 
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Center(
                    child: Column(
                      children: [
                        
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Welcome To Alzheimer's Assistance !",
                          style: GoogleFonts.openSans(fontSize: 20),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Sign Up To Continue",
                          style: GoogleFonts.openSans(fontSize: 20),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: 500,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(86, 32, 32, 32),
                            Color.fromARGB(146, 77, 77, 77),
                            Color.fromARGB(148, 51, 51, 51),
                            Color.fromARGB(147, 99, 99, 99),
                            Color.fromARGB(147, 0, 0, 0),
                          ]
                          ),
                          backgroundBlendMode: BlendMode.multiply
                        ),
                      child: SingleChildScrollView(
                        child: Form(
                            key: formkey,
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    controller: userid,
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(FontAwesomeIcons.userCircle,
                                          color: const Color.fromARGB(255, 255, 255, 255), size: 20,),
                                      hintText: "Username",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: const Color.fromARGB(255, 255, 255, 255), ),
                                          borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    controller: email,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (email) =>
                                        email != null && !EmailValidator.validate(email)
                                            ? "Enter a valid email"
                                            : null,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(FontAwesomeIcons.user,
                                          color: const Color.fromARGB(255, 255, 255, 255), size: 20,),
                                      hintText: "Email Id",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: const Color.fromARGB(255, 255, 255, 255), ),
                                          borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    controller: password,
                                    obscureText: hide,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) => value != null &&
                                            value.length < 8
                                        ? "Your password should be minimum of 8 charecters"
                                        : null,
                                    keyboardType: TextInputType.visiblePassword,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(FontAwesomeIcons.key,
                                          color: const Color.fromARGB(255, 255, 255, 255), size: 20,),
                                      suffixIcon: GestureDetector(
                                        child: icon,
                                        onTap: () {
                                          if (hide == true) {
                                            hide = false;
                                            setState(() {
                                              icon = Icon(FontAwesomeIcons.eyeSlash,
                                                  color: const Color.fromARGB(255, 255, 255, 255), size: 20,);
                                            });
                                          } else {
                                            hide = true;
                                            icon = Icon(FontAwesomeIcons.eye,
                                                color: const Color.fromARGB(255, 255, 255, 255), size: 20,);
                                          }
                                          setState(() {});
                                        },
                                      ),
                                      hintText: "Password",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: const Color.fromARGB(255, 255, 255, 255), ),
                                          borderRadius: BorderRadius.circular(10.0)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => signup(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  child: Text('Sign Up', style: GoogleFonts.openSans(color: Colors.white),),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(148, 73, 73, 73)
                                  ),
                                ),
                              ),
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(height: 5,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(child: LinearProgressIndicator(value: 25, color: Colors.white, minHeight: 1.5,),),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    child: Center(child: Text("OR", style: GoogleFonts.openSans(),)),
                                  ),
                                  Expanded(child: LinearProgressIndicator(value: 25,color: Colors.white,minHeight: 1.5,)),
                                ],
                              ),
                              SizedBox(height: 5,),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => google_signup(),
                                child: Container(
                                  padding: EdgeInsets.all(10),
                                  width: 250,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(FontAwesomeIcons.google),
                                      Text("Sign Up With Google", style: GoogleFonts.openSans(),),
                                    ],
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(148, 73, 73, 73)),
                                  ),
                              ),
                              SizedBox(height: 15,),
                                Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text("Do you already have an Account?")),
                                    InkWell(
                                      child: Text(
                                        " Sign In",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Sign_In()));
                                      },
                                    )
                                  ],
                                ),
                                
                              ],
                            ),
                          ),
                      ),
                      ),
                    ),
                    SizedBox(height: 20,)
                ],
              ),
            ),
      ),
    );
  }
}

// return Scaffold(
//       body: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             Center(
//               child: InkWell(
//                 onTap: ()
//                 {
//                   google_signup();
//                 },
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   height: 80,
//                   width: 220,
//                   decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.blue,),
//                   child: Row(
//                     children: [
//                       Spacer(),
//                       Icon(FontAwesomeIcons.google, color: Colors.red,),
//                       Spacer(),
//                       Text('SignUp With Google',)
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );