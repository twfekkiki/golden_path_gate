import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/payment.dart';

class ShipmentPaymentProvider extends ChangeNotifier {

  final String uid;
  final String userId;


  ShipmentPaymentProvider(this.uid,this.userId);

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
      if(payment.paymentDate != null && !(payment.isPayed??false)){
        DateTime notificationDate = payment.paymentDate!.subtract(Duration(days: 1));
        if(notificationDate.compareTo(DateTime.now()) > 0){

          var deleteDocs = await FirebaseFirestore.instance.collection("notificationsQueue")
          .where('objectId',isEqualTo: uid)
          .where('sent',isEqualTo: false)
          .where('uid',isEqualTo: userId)
          .get();

          if (deleteDocs.docs.isNotEmpty) {
            WriteBatch batch = FirebaseFirestore.instance.batch();
            for (var doc in deleteDocs.docs) {
              batch.delete(doc.reference);
            }
            await batch.commit();
          }

          await FirebaseFirestore.instance.collection("notificationsQueue").add({
            'uid': userId,
            'title': "Payment reminder",
            "body": "We would like to remind you about your shipment payment",
            "scheduledAt": Timestamp.fromDate(notificationDate),
            "sent": false,
            'objectId':uid
          });
        }

      }
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