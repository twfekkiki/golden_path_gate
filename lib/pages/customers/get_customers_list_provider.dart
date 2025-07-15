import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';

class GetCustomersListProvider extends ChangeNotifier {

  final _customersCollection = FirebaseFirestore.instance.collection("customers");

  List<Customer>? customers;
  bool loading = false;
  bool done = false;


  getCustomersList({String? searchKey}) async {
    var query = _customersCollection;
    if(searchKey != null && searchKey.isNotEmpty){
      // query = query.where('firstName',is)
    }

    var result = await _customersCollection.get();

    customers = result.docs.map((element){return Customer.fromDoc(element);}).toList();

    notifyListeners();
  }

}