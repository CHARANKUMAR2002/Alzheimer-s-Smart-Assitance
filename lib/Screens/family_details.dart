import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:s8/Components/firestore.dart';

class Family_details extends StatefulWidget {
  const Family_details({super.key, required this.currentUser});
  final currentUser;

  @override
  State<Family_details> createState() => _Family_detailsState();
}

class _Family_detailsState extends State<Family_details> {

  Stream<List<FamilyDetails>> readData() => FirebaseFirestore.instance.collection("${widget.currentUser}_family_details")
  .snapshots().map((snapshot) => snapshot.docs.map((detail) => FamilyDetails.fromJson(detail.data())).toList()
  );

  Widget Details(FamilyDetails data, int index)
  {
    return InkWell(
      onTap: ()
      async{await FlutterPhoneDirectCaller.callNumber("+91 ${data.phone}");},
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: ListTile(
          // tileColor: Colors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          leading: Text(data.relation, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,), textAlign: TextAlign.start,),
          title: Text("${data.name}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          trailing: Text(data.phone, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  TextEditingController controller = TextEditingController();

  List<String> relationsDrop = [
    "Son", "Daughter", 'Wife', 'Husband', 'Father'
  ];

  var selectedRelation;
  TextEditingController phoneController = TextEditingController();

  save()
  {
    FirebaseFirestore.instance.collection('${widget.currentUser}_family_details').doc('${controller.text}').set({'name': controller.text, 'relation' : selectedRelation, 'phone' : phoneController.text,});
    setState(() {
      controller.text = '';
      selectedRelation = null;
      phoneController.text = '';
    });
    Navigator.pop(context);
  }


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: ()
                  {
                    showModalBottomSheet(
                      scrollControlDisabledMaxHeightRatio: MediaQuery.of(context).size.height * .8,
                      context: context, 
                      builder: (BuildContext context)
                      {
                        return StatefulBuilder(
                          builder: (BuildContext context, StateSetter stateSetter)
                          {
                            return Container
                          (
                            height: MediaQuery.of(context).size.height * 0.7,
                            padding: EdgeInsets.all(20),
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  Row(
                                      children: [
                                        Text('Family Details', style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold))
                                      ],
                                    ),
                                    SizedBox(height: 20,),
                                    TextField(
                                      decoration: InputDecoration(label: Text("Name")),
                                      keyboardType: TextInputType.name,
                                      controller: controller,
                                    ),
                                    SizedBox(height: 20,),
                                    DropdownButton(
                                      hint: Text("Select Relation"),
                                      underline: SizedBox(),
                                      elevation: 20,
                                      items: relationsDrop.map<DropdownMenuItem<String>>((String value) 
                                      {
                                        return DropdownMenuItem<String>(value: value, child: Text(value),);
                                      }
                                      ).toList(),
                                      onChanged: (value){
                                        stateSetter(()
                                        {
                                          setState(() {
                                          selectedRelation = value;
                                        });
                                        }
                                        );
                                      },
                                      value: selectedRelation,
                                      borderRadius: BorderRadius.circular(10),
                                      ),
                                      SizedBox(height: 20,),
                                    TextField(
                                      decoration: InputDecoration(label: Text("Phone No.")),
                                      keyboardType: TextInputType.phone,
                                      controller: phoneController,
                                    ),
                                    SizedBox(height: 20,),
                                    Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(onPressed: (){save();}, child: Text("Record"),),
                                    ],
                                  ),
                                    SizedBox(height: 50,),
                                ],
                              ),
                            ),
                          );
                          }
                          
                        );
                      }
                      );
                  },
                  ),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: StreamBuilder<List<FamilyDetails>>(
                stream: readData(),
                builder: (context, snapshot)
                {
                  final data = snapshot.data;
                  
                  if(snapshot.hasData)
                  {
                    return data!.length == 0 ?  Column(
                            children: [
                              SizedBox(height: MediaQuery.of(context).size.height * .4,),
                              Center(child: Text('No Family Records Found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)),
                            ],
                          ) :
                          Column(
                            children: [
                               Padding(
                                 padding: const EdgeInsets.all(10),
                                 child: ListTile(
                                          //  tileColor: Colors.red,
                                           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                           leading: Text('Relation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
                                           title: Text("Name ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                           trailing: Padding(
                                             padding: const EdgeInsets.only(right: 30),
                                             child: Text("Phone No.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                           ),
                                         ),
                               ),
                              ListView.builder(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              shrinkWrap: true,
                              // children: list!.map(movie).toList(),
                              itemCount: data!.length,
                              itemBuilder: (context, index) => Details(data[index], index),
                                                      ),
                            ],
                          );
                  }
                   return Center(child: CircularProgressIndicator()); 
                },
              ),
            )
          ],
        ),
      )
    );
  }
}