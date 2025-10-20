import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/models/shipment_status.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/change_shipment_status_provider.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';
import 'package:golden_path_gate_admin_portal/services/notifications_service.dart';

class ChangeStatusModel {
  final ShipmentStatusModel status;
  final String note;

  ChangeStatusModel({
    required this.status,
    required this.note
  });
}


class TimelineProvider extends ChangeNotifier {

  final String uid;
  final String customerId;

  TimelineProvider(this.uid,this.customerId);

  List<ShipmentStatusHistory>? statusHistory;

  getTimeline() async {
    var result = await FirebaseFirestore.instance
        .collection('shipments/$uid/statusHistory')
        .orderBy('createdAt').get();

    statusHistory = result.docs.map((e){
      return ShipmentStatusHistory.fromMap(e.data());
    }).toList();


    notifyListeners();

  }

  bool loading = false;
  bool done = false;



  changeStatus(ChangeStatusModel request,Shipment shipment ) async {
    try{
      loading = true;
      notifyListeners();

      final docRef = FirebaseFirestore.instance
          .collection('shipments').doc(uid);
      final statusHistoryRef = docRef.collection('statusHistory').doc(); // Auto-ID

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // 1. Update the shipment status
        transaction.update(docRef, {
          'status': request.status.index,
        });

        // 2. Add new status history entry with server timestamp
        transaction.set(statusHistoryRef, {
          'status': request.status.index,
          'createdAt': FieldValue.serverTimestamp(),
          'note': request.note,
        });
      });
      var notificationService = NotificationsService();
      notificationService.sendPushNotification(
          topic: customerId,
          title: "Shipment #${shipment.shipmentNumber}",
          body: "${ AppInfoService().getStatusName(request.status.index,pickUpDate: shipment.pickupDate) }"
      );
      loading = false;
      done = true;
      notifyListeners();
    } catch(error) {
      print(error);
      loading = false;
      notifyListeners();
    }
  }

  reset(){
    done = false;
    loading = false;
    notifyListeners();
  }

}