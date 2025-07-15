// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class ChangeStatusModel {
//   final String status;
//   final String note;
//
//   ChangeStatusModel({
//     required this.status,
//     required this.note
//   });
// }
//
// class ChangeShipmentStatusProvider extends ChangeNotifier {
//
//   final String uid;
//
//   ChangeShipmentStatusProvider(this.uid);
//
//   final _shipmentsCollection = FirebaseFirestore.instance.collection('shipments');
//
//   bool loading = false;
//   bool done = false;
//
//   changeStatus(ChangeStatusModel request ) async {
//     try{
//       loading = true;
//       notifyListeners();
//
//       final docRef = _shipmentsCollection.doc(uid);
//       final statusHistoryRef = docRef.collection('statusHistory').doc(); // Auto-ID
//
//       await FirebaseFirestore.instance.runTransaction((transaction) async {
//         // 1. Update the shipment status
//         transaction.update(docRef, {
//           'status': request.status,
//         });
//
//         // 2. Add new status history entry with server timestamp
//         transaction.set(statusHistoryRef, {
//           'name': request.status,
//           'createdAt': FieldValue.serverTimestamp(),
//           'note': request.note,
//         });
//       });
//       loading = false;
//       done = true;
//       notifyListeners();
//     } catch(error) {
//       print(error);
//       loading = false;
//       notifyListeners();
//     }
//   }
// }