import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';

class ShipmentsListProvider extends ChangeNotifier {

  final _shipmentsCollection = FirebaseFirestore.instance.collection('shipments');

  List<Shipment>? shipments;

  getShipmentsList() async {
    var result = await _shipmentsCollection.orderBy('createdAt',descending: true).limit(10).get();
    shipments = List<Shipment>.of(result.docs.map((elements){return Shipment.fromDoc(elements);}));
    notifyListeners();
  }


}