import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './family_details.dart';
import 'package:s8/Screens/location.dart';
import 'package:s8/Screens/logout.dart';
import 'package:s8/Screens/personal_details.dart';
import 'package:s8/Screens/schedule_alert.dart';

class Home extends StatefulWidget {
  const Home({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final auth = FirebaseAuth.instance;
  var name;
  int index = 0;
  

  @override
  Widget build(BuildContext context) {

    List Screens = [
            Personal_details(currentUser: widget.currentUser.toString(),),
            Family_details(currentUser: widget.currentUser.toString(),),
            Locate(currentUser: widget.currentUser.toString(),),
            Schedule_alert(currentUser: widget.currentUser.toString(),),
            Logout(currentUser: widget.currentUser.toString(),)
          ];



    return Scaffold(
      body: Screens[index],
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(indicatorColor: Color.fromARGB(150, 33, 149, 243)),
        child: NavigationBar(
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          height: 65.0,
          onDestinationSelected: (value) => setState(() {index = value;}),
          destinations: [
            NavigationDestination(icon: Icon(FontAwesomeIcons.user, color: Colors.white,),label: "Personal Details", ),
            NavigationDestination(icon: Icon(FontAwesomeIcons.peopleGroup, color: Colors.white,),label: "Family Details", ),
            NavigationDestination(icon: Icon(FontAwesomeIcons.location, color: Colors.white,),label: "Live Location", ),
            NavigationDestination(icon: Icon(FontAwesomeIcons.bell, color: Colors.white,),label: "Schedule Alerts", ),
            NavigationDestination(icon: Icon(FontAwesomeIcons.signOut,color: Colors.white),label: "Profile", ),
          ],
          selectedIndex: index,
        ),
      )
    );
  }
}