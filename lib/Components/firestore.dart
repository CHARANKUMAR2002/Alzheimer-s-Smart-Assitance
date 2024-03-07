import 'package:cloud_firestore/cloud_firestore.dart';

class UserDetails{
  final  name;
  final  email;
  final phone;
  final dob;
  final currentUser;
  final profile;
  final disease_encountered;
  final emergency_contact;

  UserDetails({
    this.name,
    this.email,
    this.phone,
    this.dob,
    this.currentUser,
    this.profile,
    this.emergency_contact,
    this.disease_encountered
  });


  Map<String, dynamic> toJson() => {
    'name' : name,
    'email' : email,
    'currentUser' : currentUser,
    'phone' : phone,
    'dob': dob,
    'profile': profile,
    'emergency_contact' : emergency_contact,
    'disease_encountered': disease_encountered
  };

  static UserDetails fromJson(Map<String, dynamic> json) => UserDetails(
    name: json['name'],
    email: json['email'],
    phone: json['phone'],
    dob: json['dob'],
    currentUser: json['currentUser'],
    profile: json['profile'],
    emergency_contact: json['emergency_contact'],
    disease_encountered: json['disease_encountered']
  );

  factory UserDetails.getcurrentUser(DocumentSnapshot<Map<String, dynamic>> document)
  {
    final data = document.data()!;
    return UserDetails(
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        dob: data['dob'],
        currentUser: data['currentUser'],
        profile: data['profile'],
        emergency_contact: data['emergency_contact'],
        disease_encountered: data['disease_encountered']
      );
  }
}


class FamilyDetails{
  final  name;
  final  relation;
  final phone;
 

  FamilyDetails({
    required this.name,
    required this.relation,
    this.phone,
   
  });


  Map<String, dynamic> toJson() => {

    'name' : name,
    'relation' : relation,
    'phone' : phone,
    
  };

  static FamilyDetails fromJson(Map<String, dynamic> json) => FamilyDetails(
    name: json['name'],
    relation: json['relation'],
    phone: json['phone'],
  );
}

class Schedules{
  final  hour;
  final  minute;
  final activity;
  final period;
  

  Schedules({
    this.hour,
    this.minute,
    this.activity,
    this.period
  });


  Map<String, dynamic> toJson() => {

    'hour' : hour,
    'minute': minute,
    'activity' : activity,
    'period': period
  };

  static Schedules fromJson(Map<String, dynamic> json) => Schedules(
    hour: json['hour'],
    minute: json['minute'],
    activity: json['activity'],
    period: json['period']
  );
}