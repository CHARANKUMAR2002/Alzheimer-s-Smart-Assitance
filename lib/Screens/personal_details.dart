import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_path/external_path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s8/Components/firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:sensors_plus/sensors_plus.dart';

class Personal_details extends StatefulWidget {
  const Personal_details({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Personal_details> createState() => _Personal_detailsState();
}

class _Personal_detailsState extends State<Personal_details> {

  final firestore = FirebaseFirestore.instance;

  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  String timestamp = '';
  var dir;

  update_phoneNumber() async
  {
    TextEditingController number = TextEditingController();
    showDialog(
      context: context, 
      builder: (BuildContext context)
      {
        return AlertDialog(
      title: Text("Update Phone Number"),
      content: Container(
        child: TextField(
          decoration: InputDecoration(label: Text("Phone Number")),
          controller: number,
          keyboardType: TextInputType.phone,
        ),
      ),
      actions: [
        ElevatedButton(child: Text('Cancel'), onPressed: (){Navigator.pop(context);},),
        ElevatedButton(onPressed: ()async { await firestore.collection(widget.currentUser).doc('personal_details').update({'phone' : '${number.text}'}); number.text = ''; Navigator.pop(context);}, child: Text('Update')),
        ],
    );
      }
      );
  }

  update_age() async
  {
    
        return showDatePicker(context: context, firstDate: DateTime(1800), lastDate: DateTime.now(),)
        .then(
          (value) async {
            await firestore.collection(widget.currentUser).doc('personal_details').update({'dob' : '${value!.day}-${value.month}-${value.year}'});
          }
        );
  }

  update_date() async
  {
    
        return showDatePicker(context: context, firstDate: DateTime(1800), lastDate: DateTime.now())
        .then(
          (value) async {
            await firestore.collection(widget.currentUser).doc('personal_details').update({'disease_encountered' : '${value!.day}-${value.month}-${value.year}'});
          }
        );
  }

  update_ec() async
  {
    TextEditingController ec = TextEditingController();
    showDialog(
      context: context, 
      builder: (BuildContext context)
      {
        return AlertDialog(
      title: Text("Update Emergency Contact"),
      content: Container(
        child: TextField(
          decoration: InputDecoration(label: Text("Emergency Contact")),
          controller: ec,
          keyboardType: TextInputType.phone,
        ),
      ),
      actions: [
        ElevatedButton(child: Text('Cancel'), onPressed: (){Navigator.pop(context);},),
        ElevatedButton(onPressed: ()async { await firestore.collection(widget.currentUser).doc('personal_details').update({'emergency_contact' : '${ec.text}'}); ec.text = ''; Navigator.pop(context);}, child: Text('Update')),
        ],
    );
      }
      );
  }

  Stream<List<UserDetails>> readData() => FirebaseFirestore.instance.collection(widget.currentUser)
  .snapshots().map((snapshot) => snapshot.docs.map((detail) => UserDetails.fromJson(detail.data())).toList()
  );

  permission() async
  {
    await [Permission.notification,Permission.location,Permission.locationAlways,Permission.phone, Permission.storage].request();
    dir = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
    
  }
  

  @override

  stat() async{

  await accelerometerEvents.listen(
    (AccelerometerEvent event) {
      x = event.x;
      y = event.y;
      z = event.z;
    }
    );

    String time = DateTime.now().toString();
    String date = time.replaceAll('-', '');
    String stamp = date.replaceAll(':', '');
    String format = stamp.replaceAll(' ', '');
    timestamp = format.substring(0,12);

    // Sitting

    if(x >= -10.31 && x <= 12.45)
    {
      if(y >= -9.3 && y <= 18.47)
      {
        if(z >= 0.04 && z <= 9)
        {
          await File('${dir}/Sample.txt')..createSync(recursive: true)..writeAsStringSync('Sitting,${timestamp},${x},${y},${z};\n',mode: FileMode.writeOnlyAppend);
        }
      }
    }

    // Standing

    if(x >= -10.99 && x <= 13.1)
    {
      if(y >= -0.65 && y <= 19.46)
      {
        if(z >= -4.14 && z <= 7.25)
        {
          await File('${dir}/Sample.txt')..createSync(recursive: true)..writeAsStringSync('Standing,${timestamp},${x},${y},${z};\n',mode: FileMode.writeOnlyAppend);
        }
      }
    }

    // Walking

    if(x >= -19.61 && x <= 19.91)
    {
      if(y >= -18.85 && y <= 20.04)
      {
        if(z >= 0.0 && z <= 10)
        {
          await File('${dir}/Sample.txt')..createSync(recursive: true)..writeAsStringSync('Walking,${timestamp},${x},${y},${z};\n',mode: FileMode.writeOnlyAppend);
        }
      }
    }

}


  Widget Details(UserDetails data, int index)
  {

    return Column(
      children: [
        SizedBox(height: 10,),
        Center(child:  Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), image: DecorationImage(image: NetworkImage('${data.profile}'), fit: BoxFit.cover)), height: 100, width: 100,),),
        SizedBox(height: 30,),
        DataTable(
          dataRowHeight: MediaQuery.of(context).size.height *.12,
          columnSpacing: 50,
          columns: [
            DataColumn(label: Text("Name :", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,),)),
            DataColumn(label: Text("${data.name}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, overflow: TextOverflow.ellipsis), textAlign: TextAlign.center,))
          ], 
          rows: [
            DataRow(cells: [
              DataCell(Text("Date Of Birth : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              widget.currentUser == FirebaseAuth.instance.currentUser!.email ? 
              DataCell(data.dob == null ? Center(child: Text(' - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))) : 
              Text('${data.dob.toString().replaceAll('-', '/')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,) ) : 
              DataCell(data.dob == null ? Center(child: ElevatedButton(onPressed: (){update_age();}, child: Text("Update DOB", textAlign: TextAlign.center,))) : 
              Text('${data.dob.toString().replaceAll('-', '/')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),onLongPress: update_age),
            ]),
             DataRow(cells: [
              DataCell(Text("Phone \nNumber : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              widget.currentUser == FirebaseAuth.instance.currentUser!.email ? 
              DataCell(data.phone == null ? Center(child: Text(' - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))) : 
              Text('${data.phone}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,)) : 
              DataCell(data.phone == null ? ElevatedButton(onPressed: (){update_phoneNumber();}, child: Text("Update Phone Number", textAlign: TextAlign.center,),) : 
              Text('${data.phone}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),onLongPress: update_phoneNumber),
            ]),
            DataRow(cells: [
              DataCell(Text("Disease Encountered On : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              widget.currentUser == FirebaseAuth.instance.currentUser!.email ? 
              DataCell(data.disease_encountered == null ? Center(child: Text(' - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))) : 
              Text('${data.disease_encountered.toString().replaceAll('-', '/')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,)) : 
              DataCell(data.disease_encountered == null ? Center(child: ElevatedButton(onPressed: (){update_date();}, child: Text("Update Date", textAlign: TextAlign.center,))) : 
              Text('${data.disease_encountered.toString().replaceAll('-', '/')}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18), textAlign: TextAlign.center,),onLongPress: update_date),
            ]),
             DataRow(cells: [
              DataCell(Text("Emergency \nContact : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))),
              widget.currentUser == FirebaseAuth.instance.currentUser!.email ? 
              DataCell(data.emergency_contact == null ? Center(child: Text(' - ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18))) :
              Text('${data.emergency_contact}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), onTap: ()async{await FlutterPhoneDirectCaller.callNumber("+91 ${data.emergency_contact}");}) : 
              DataCell(data.emergency_contact == null ? Center(child: ElevatedButton(onPressed: (){update_ec();}, child: Text("Update Emergency Contact", textAlign: TextAlign.center,))) : 
              Text('${data.emergency_contact}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              onLongPress: update_ec, onTap: ()async{await FlutterPhoneDirectCaller.callNumber("+91 ${data.emergency_contact}");}),
            ]),
          ]
          ),
      ],
    );
  }
  
  
  @override

  void initState() {
    permission();
    Timer timer = new Timer.periodic(Duration(seconds: 1), (timer) { setState(() {
    stat();
    });
  });
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder<List<UserDetails>>(
                stream: readData(),
                builder: (context, snapshot)
                {
                  if(snapshot.hasData)
                  {
                    final data = snapshot.data;

                    return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    shrinkWrap: true,
                    itemCount: data!.length,
                    itemBuilder:(context, index) => Details(data[index], index),
                  );
                  }
                  return Container();
                },
              ),
            )
          ],
        ),
      )
    );
  }
}