import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';

class ShipmentsDetailsProvider extends ChangeNotifier {

  final String uid;

  ShipmentsDetailsProvider(this.uid);

  final _shipmentsCollection = FirebaseFirestore.instance.collection('shipments');

  Shipment? shipment;

  getShipmentsDetails() async {
    print("getShipmentsDetails");
    print(uid);
    var result = await _shipmentsCollection.doc(uid).get();
    if(result.exists){
      shipment = Shipment.fromDoc(result);
    }
    notifyListeners();
  }
}