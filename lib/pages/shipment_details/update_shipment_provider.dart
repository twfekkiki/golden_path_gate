import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';

class UpdateShipmentDetailsProvider extends ChangeNotifier {

  final String uid;

  UpdateShipmentDetailsProvider(this.uid);

  bool loading = false;
  bool done = false;
  dynamic error;

  updateShipment(ShipmentUpdateModel request ) async {
    try{
      loading = true;
      notifyListeners();
      final docRef = FirebaseFirestore.instance
          .collection('shipments')
          .doc(uid);
      await docRef.update(request.toMap);
      loading = false;
      done = true;
      notifyListeners();
    } catch(error) {
      loading = false;
      this.error = error;
      notifyListeners();
    }
  }



}