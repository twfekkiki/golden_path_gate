import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/services/firebase_storage_handler.dart';

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

      final List<FileModel> attachments = shipment.attachments;
      FirebaseFileHandler fileHandler = FirebaseFileHandler();
      try {
        if(attachments.isNotEmpty){
          List<String> attachmentsPaths = await fileHandler.uploadFiles(attachments);
          for (int i = 0; i < attachmentsPaths.length; i++) {
            attachments[i].path = attachmentsPaths[i];
          }
        }
      } catch (error) {
        await fileHandler.deleteFiles(attachments.where((value) => value.path != null).map((value) => value.path!).toList());
        loading = false;
        this.error = error;
        notifyListeners();
        return null;
      }

      var result = await shipmentsCollection.add(shipment.toMap);

      await shipmentsCollection.doc(result.id)
          .collection("statusHistory").add(
          {
            'status': 0,
            'note': shipment.note,
            'createdAt': FieldValue.serverTimestamp()
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