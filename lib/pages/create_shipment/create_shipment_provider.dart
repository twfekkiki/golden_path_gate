import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';

class CreateShipmentProvider extends ChangeNotifier {

  final shipmentsCollection = FirebaseFirestore
      .instance.collection("shipments");

  bool loading = false;
  bool done = false;

  dynamic error;

  Future<String?> createShipment(ShipmentCreateModel shipment) async {
    try {
      if(loading || done) return null;
      loading = true;
      notifyListeners();
      var result = await shipmentsCollection.add(shipment.toMap);

      await shipmentsCollection.doc(result.id)
          .collection("statusHistory").add(
          {
            'name':'start',
            'note':shipment.note,
            'createdAt':FieldValue.serverTimestamp()
          }
      );
      done = true;
      notifyListeners();
      return result.id;
    } catch (error){
      done = false;
      loading = false;
      this.error = error;
      notifyListeners();
      return null;
    }
  }
}