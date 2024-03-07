
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:s8/Components/google_auth_api.dart';
import 'package:s8/Components/validate.dart';
import 'package:s8/Screens/Signup.dart';
import 'package:google_fonts/google_fonts.dart';

class Sign_In extends StatefulWidget {
  const Sign_In({super.key});

  @override
  State<Sign_In> createState() => _Sign_InState();
}

class _Sign_InState extends State<Sign_In> {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount? user;

  GoogleSignInAccount get User => user!;

  final formkey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  bool hide = true;
  var icon = Icon(FontAwesomeIcons.eye, color: const Color.fromARGB(255, 255, 255, 255), size: 20,);
  var snapshotUser;

  Future signin() async {
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
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Validator(newUser: false,)));

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
                      })
                ],
              );
            });
      });
    }
  }

  google_signin() async
  {
    try{
      await GoogleSignInProvider().googleLogin();
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Validator(newUser: false,)));
      
    }
    catch(e)
    {

    }
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
                          style: GoogleFonts.openSans(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255)),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Text(
                          "Sign In To Continue",
                          style: GoogleFonts.openSans(fontSize: 20, color: const Color.fromARGB(255, 255, 255, 255)),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * .6,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(86, 32, 32, 32),
                            Color.fromARGB(146, 77, 77, 77),
                            Color.fromARGB(148, 51, 51, 51),
                            Color.fromARGB(146, 255, 255, 255),
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
                                  height: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.openSans(),
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
                                          color: const Color.fromARGB(255, 255, 255, 255), size: 20),
                                      hintText: "Email Id",
                                      hintStyle: GoogleFonts.openSans(),
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
                                              color: const Color.fromARGB(255, 255, 255, 255)),
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Container(
                                  padding: EdgeInsets.only(left: 20, right: 20),
                                  child: TextFormField(
                                    onFieldSubmitted: (value) => signin(),
                                    cursorColor: Colors.white,
                                    style: GoogleFonts.openSans(),
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
                                      hintStyle: GoogleFonts.openSans(),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              style: BorderStyle.solid,
                                              color: Color.fromARGB(255, 255, 255, 255),
                                             ),
                                          borderRadius: BorderRadius.circular(10)),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(255, 255, 255, 255)),
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              InkWell(
                                borderRadius: BorderRadius.circular(10),
                                onTap: () => signin(),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                                  child: Text('Sign In', style: GoogleFonts.openSans(color: Colors.white),),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Color.fromARGB(148, 73, 73, 73)
                                  ),
                                ),
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
                                onTap: () => google_signin(),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                  width: 200,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Icon(FontAwesomeIcons.google),
                                      Text("Login With Google", style: GoogleFonts.openSans(),),
                                    ],
                                  ),
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Color.fromARGB(148, 73, 73, 73)),
                                  ),
                              ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    Container(
                                        padding: EdgeInsets.only(left: 50),
                                        child: Text("New to Alzheimer's Assistance?")),
                                    InkWell(
                                      child: Text(
                                        " Sign Up",
                                        style: TextStyle(
                                          decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Sign_Up()));
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

// SafeArea(
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
//                       Text('SignIn With Google',)
//                     ],
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),