import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:s8/Components/validate.dart';
import 'package:s8/Screens/signin.dart';
import './Screens/signup.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
     options: FirebaseOptions(
       apiKey: "AIzaSyACTycNxeUhGKaAsH18IF5KiDbv-pqxqfY",
  authDomain: "alzheimer-s-disease-b1ed2.firebaseapp.com",
  projectId: "alzheimer-s-disease-b1ed2",
  storageBucket: "alzheimer-s-disease-b1ed2.appspot.com",
  messagingSenderId: "699298352510",
  appId: "1:699298352510:web:3d8e7ad9ee39851f53f72f",
  measurementId: "G-8CKXF0CREL"
    )
  );
  AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: "basic_channel",
        channelName: "Basic Notification",
        channelDescription: 'Basic Notification Channel',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableLights: true,
      ),
      NotificationChannel(
        channelKey: "scheduled_channel",
        channelName: "Scheduled Notification",
        channelDescription: 'Scheduled Reminder Channel',
        defaultColor: Colors.blue,
        importance: NotificationImportance.High,
        channelShowBadge: true,
        playSound: true,
        enableLights: true,
      )
    ],
    );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: Validate()
    );
  }
}

class Validate extends StatelessWidget {
  const Validate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Validator(newUser: false);
            }else{
              return Sign_Up();
            }
          },
          stream: FirebaseAuth.instance.authStateChanges(),
        ),
      );
}