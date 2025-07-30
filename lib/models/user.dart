import 'package:cloud_firestore/cloud_firestore.dart';

enum PortalUserRole{
  superAdmin,
  dataEntry,
  customer
}

class PortalUser {
  String uid;
  String username;
  PortalUserRole role;

  PortalUser({required this.uid, required this.username, required this.role});

  factory PortalUser.fromDoc(DocumentSnapshot doc){
    return PortalUser(
      uid:doc.id,
      username: doc['username'],
      role: PortalUserRole.values.firstWhere((element)=>element.name == doc['role'])
    );
  }





}