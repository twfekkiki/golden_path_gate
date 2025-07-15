import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/payment.dart';

class ShipmentPaymentProvider extends ChangeNotifier {

  final String uid;

  ShipmentPaymentProvider(this.uid);

  bool done = false;
  bool loading = false;

  dynamic error;

  updatePayment(ShipmentPayment payment) async {
    try {
      loading = true;
      notifyListeners();
      await FirebaseFirestore.instance
          .collection("shipments").doc(uid)
          .update({
            'payment':payment.toMap
          });
      loading = false;
      done = true;
    } catch (error) {
      this.error = error;
      loading = false;
      done = false;
      notifyListeners();
    }
  }

  reset(){
    loading = false;
    done = false;
    notifyListeners();
  }
}