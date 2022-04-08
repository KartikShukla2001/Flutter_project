import 'package:cofee_brew_1/models/user.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cofee_brew_1/models/brew.dart';
import 'package:cofee_brew_1/models/user.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  //collection reference

  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars,String name,int strength) async{
    return await brewCollection.doc(uid).set({
      'sugars' : sugars ,
      'name' : name,
      'strength': strength
    });
  }

  //brew list from snapshot
 List<Brew> _brewListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc){
      return Brew(
        name: (doc.data() as dynamic)['name'] ?? '',
        strength: (doc.data() as dynamic)['strength'] ?? 0,
        sugars: (doc.data() as dynamic)['sugars'] ?? '0'
      );
    }).toList();
 }

 //userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: (snapshot.data() as Map<String, dynamic>)['name'],
      sugars: (snapshot.data() as Map<String, dynamic>)['sugars'],
      strength: (snapshot.data() as Map<String, dynamic>)['strength']
    );
  }
 Stream<List<Brew>> get brews{
return brewCollection.snapshots()
    .map(_brewListFromSnapshot);
 }

 //get user doc stream
Stream<UserData> get userData{
    return brewCollection.doc(uid).snapshots()
        .map(_userDataFromSnapshot);
}
}