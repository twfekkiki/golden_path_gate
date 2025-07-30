import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/models/user.dart';

class GetUsersListProvider extends ChangeNotifier {

  final _usersCollection = FirebaseFirestore.instance.collection("users");

  List<PortalUser>? users;
  bool loading = false;
  bool done = false;


  getUsersList({String? searchKey}) async {
    var query = _usersCollection;
    if(searchKey != null && searchKey.isNotEmpty){
      // query = query.where('firstName',is)
    }

    var result = await _usersCollection.get();

    users = result.docs.map((element){return PortalUser.fromDoc(element);}).toList();

    notifyListeners();
  }


  updateUserPassword(){

  }

  deleteUser(){

  }

}