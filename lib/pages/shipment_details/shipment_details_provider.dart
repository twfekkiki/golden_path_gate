import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/services/firebase_storage_handler.dart';

class ShipmentsDetailsProvider extends ChangeNotifier {
  final String uid;

  ShipmentsDetailsProvider(this.uid);

  final _shipmentsCollection = FirebaseFirestore.instance.collection(
    'shipments',
  );

  Shipment? shipment;
  bool loading = false;
  dynamic error;

  getShipmentsDetails() async {
    var result = await _shipmentsCollection.doc(uid).get();
    if (result.exists) {
      shipment = Shipment.fromDoc(result);
    }
    notifyListeners();
  }

  final FirebaseFileHandler firebaseFileHandler = FirebaseFileHandler();

  deleteAttachment(FileModel file) async {
    loading = true;
    notifyListeners();
    try {
      var result = await firebaseFileHandler.deleteFile(file.path!);
      if (result) {
        final docRef = FirebaseFirestore.instance
            .collection('shipments')
            .doc(shipment!.uid);
        await docRef.update({
          'attachments': FieldValue.arrayRemove([file.toMap]),
        });
        shipment!.attachments.remove(file);
        loading = false;
        notifyListeners();
      }
    } catch (error) {
      loading = false;
      notifyListeners();
      print(error);
    }
  }

  uploadNewAttachment(List<FileModel> attachments) async {
    try {
      loading = true;
      notifyListeners();
      if (attachments.isNotEmpty) {
        List<String> attachmentsPaths = await firebaseFileHandler.uploadFiles(
          attachments,
        );
        for (int i = 0; i < attachmentsPaths.length; i++) {
          attachments[i].path = attachmentsPaths[i];
        }
      }
      final docRef = FirebaseFirestore.instance
          .collection('shipments')
          .doc(shipment!.uid);
      await docRef.update({
        'attachments': FieldValue.arrayUnion(attachments.map((element)=>element.toMap).toList()),
      });
      shipment!.attachments.addAll(attachments);
      loading = false;
      notifyListeners();

    } catch (error) {
      await firebaseFileHandler.deleteFiles(
        attachments
            .where((value) => value.path != null)
            .map((value) => value.path!)
            .toList(),
      );
      loading = false;
      this.error = error;
      notifyListeners();
      return null;
    }
  }
}
