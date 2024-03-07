import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Components/firestore.dart';

class Schedule_alert extends StatefulWidget {
  const Schedule_alert({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Schedule_alert> createState() => _Schedule_alertState();
}

class _Schedule_alertState extends State<Schedule_alert> with TickerProviderStateMixin{

  var hour;
  var minute;
  var period;
  var activity;

 late AnimationController vsync;

  var currentUser = FirebaseAuth.instance.currentUser;

  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    vsync = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      reverseDuration: Duration(milliseconds: 200)
    );
  }

  save()
  {
    FirebaseFirestore.instance.collection('${widget.currentUser}_schedules').doc('${activity}').set({'hour': hour, 'minute' : minute, 'period' : period, 'activity': activity});
    setState(() {
      hour = null;
      minute = null;
      controller.text = '';
      activity = null;
      period = null;
    });
    Navigator.pop(context);
  }

  Widget Details(Schedules data, int index)
  {
    var _hour;

    if(data.period == 'pm')
    {
      if(data.hour == 12)
      {
        _hour = data.hour;
      }
      _hour = 12 + data.hour;
      print(_hour);
    }
    else
    {
      hour = data.hour;
    }

    Future <void> ScheduleNotify() async
  {
    String timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await  AwesomeNotifications().createNotification(content: NotificationContent(
      actionType: ActionType.SilentBackgroundAction,
      id: Random().nextInt(1000),
      channelKey: 'scheduled_channel',
      title: "Reminder",
      body: "${data.activity}",
      notificationLayout: NotificationLayout.Default,
    ),
    schedule: NotificationCalendar(repeats: true, hour: hour, minute: data.minute, second: 0, millisecond: 0, timeZone: timeZone));
  }
  ScheduleNotify();
    return ListTile(
      title: Text("${data.activity}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      trailing: Text("${data.hour.toString()} : ${data.minute.toString()} ${data.period.toString().toUpperCase()}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Stream<List<Schedules>> getData() => FirebaseFirestore.instance.collection('${widget.currentUser}_schedules')
  .snapshots().map((snapshot) => snapshot.docs.map((detail) => Schedules.fromJson(detail.data())).toList()
  );


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
              // return showBottomSheet(context: context, builder: builder)
    //           TextEditingController activity = TextEditingController();
    // showDialog(
    //   context: context, 
    //   builder: (BuildContext context)
    //   {
    //     return BottomSheet(onClosing: (){},
    //     
    
    //     {
    //       return Container(
    //         height: MediaQuery.of(context).size.height *0.5,
    //         child: Column(
    //           children: [
    //             Container(
    //               child: TextField(
    //                 decoration: InputDecoration(label: Text("Activity")),
    //                 controller: activity,
    //                 keyboardType: TextInputType.phone,
    //               ),
    //             ),
    //           ],
    //         ),
    //       );
    //     }
    //     );
    //     return AlertDialog(
    //   title: Text("Add Reminder"),
    //   content: Column(
    //     children: [
    //       Container(
    //         child: TextField(
    //           decoration: InputDecoration(label: Text("Activity")),
    //           controller: activity,
    //           keyboardType: TextInputType.phone,
    //         ),
    //       ),
    //       SizedBox
    //     ],
    //   ),
    //   actions: [
    //     ElevatedButton(child: Text('Cancel'), onPressed: (){Navigator.pop(context);},),
    //     ElevatedButton(onPressed: ()async { await FirebaseFirestore.instance.collection(("${currentUser!.email!}_schedules")).doc().update({'hour' : '${hour}','minute' : '${minute}','activity' : '${activity}'}); activity.text = ''; Navigator.pop(context);}, child: Text('Add')),
    //     ],
    // );
      // }
      // );
        
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: (){
                    showModalBottomSheet(
                      transitionAnimationController: vsync,
                      scrollControlDisabledMaxHeightRatio: MediaQuery.of(context).size.height * 0.7,
                      context: context, 
                      builder: (BuildContext context)
                      {
                          return StatefulBuilder(
                            builder: (BuildContext context, StateSetter stateSetter)
                            {
                              return Container(
                                height: MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text('Schedule Reminder', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic))
                                    ],
                                  ),
                                  SizedBox(height: 10,),
                                  TextField(
                                    decoration: InputDecoration(label: Text("Activity")),
                                    controller: controller,
                                  ),
                                  SizedBox(height: 20,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("Time", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  SizedBox(height: 20,),
                                  InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    onTap: ()
                                    {
                                      showTimePicker(context: context, initialTime: TimeOfDay.now())
                                      .then(
                                        (value)
                                        {
                                          stateSetter(
                                            ()
                                            {
                                            setState(() {
                                            hour = value!.hourOfPeriod;
                                            minute = value.minute;
                                            activity = controller.text;
                                            period = value.period.name;
                                          });
                                            }
                                          );
                                          
                                        }
                                        );
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Color.fromARGB(255, 0, 0, 0)
                                            ),
                                            padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 80,
                                            child: hour != null ? Center(child: Text(hour.toString().length == 2 ? '${hour}' : '0${hour}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)) : Center(child: Text('- -', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color.fromARGB(255, 46, 46, 46),
                                            ),
                                          ),
                                          Text(':', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                          Container(
                                            height: 80,
                                            width: 80,
                                            child: minute != null ? Center(child: Text(minute.toString().length == 2 ? '${minute}' : '0${minute}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))) : Center(child: Text('- -', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color.fromARGB(255, 46, 46, 46)
                                            ),
                                          ),
                                          Container(
                                            height: 80,
                                            width: 80,
                                            child: period != null ? Center(child: Text('${period.toString().toUpperCase()}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)) : Center(child: Text('- -', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: const Color.fromARGB(255, 46, 46, 46)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(onPressed: (){save();}, child: Text("Schedule")),
                                    ],
                                  ),
                                  SizedBox(height: 40,),
                                ],
                              ),
                            ),
                          );
                            },
                          ); 
                      }
                      );
                  },
                  ),
                SizedBox(width: 10,),
              ],
            ),
            StreamBuilder(
              stream: getData(),
              builder: (context, snapshot)
              {
                  if(snapshot.hasData)
                        {
                          final data = snapshot.data;
                          return data!.length == 0 ?  Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * .4,),
                              Text('No Reminder Scheduled', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                            ],
                          ) :
                          ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          shrinkWrap: true,
                          // children: list!.map(movie).toList(),
                          itemCount: data!.length,
                          itemBuilder: (context, index) => Details(data[index], index),
                        );
                        }
                        return Center(child: CircularProgressIndicator());
                        
              },
            ),
          ],
        ),
      )
    );
  }
}