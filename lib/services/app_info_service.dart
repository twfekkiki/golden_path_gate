import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:golden_path_gate_admin_portal/models/shipment_status.dart';
import 'package:intl/intl.dart' as intl;
class AppInfoService extends ChangeNotifier{

  static final AppInfoService _instance = AppInfoService._internal();

  AppInfoService._internal(){
    loadCreateShipmentData();
  }

  factory AppInfoService(){
    return _instance;
  }

  List<ShipmentStatusModel>? status;
  List<ShipmentServiceTypeModel>? shipmentServices;

  loadCreateShipmentData() async {
    try{
      var doc = await FirebaseFirestore.instance
          .doc("settings/W1pJP3GegXh6oH1aEksB")
          .get();

      if(doc.exists){
        status = (doc['status'] as List<dynamic>).map((element) => ShipmentStatusModel.fromMap(element)).toList();
        shipmentServices = (doc['shipmentTypes'] as List<dynamic>).map((element) => ShipmentServiceTypeModel.fromMap(element)).toList();

        notifyListeners();
      }
    } catch (error) {
      print(error);
    }
  }


  getStatusName(int index,{DateTime? pickUpDate, String? origin, String? hub, String? destinationPort}){
    if(status == null){
      return "";
    }
    try {
      ShipmentStatusModel statusModel = status!.firstWhere((value){
        return value.index == index;
      });

      String statusName = statusModel.name.
      replaceAllMapped(RegExp(r'<(.*?)>'), (value){
        String tag = statusModel.name
            .substring(value.start,value.end);
        switch(tag){
          case "<pickupDate>":
            final formater = intl.DateFormat("d-MM-y");
            if(pickUpDate != null){
              return formater.format(pickUpDate);
            }
            break;
          case "<origin>":
            if(origin != null){
              return origin;
            }
            break;
          case "<hub>":
            if(hub != null){
              return hub;
            }
            break;
          case "<destinationPort>":
            if(destinationPort != null){
              return destinationPort;
            }
            break;
        }
        return '';
      });
      return statusName;
    } catch(error) {
      return "";
    }
  }

  getServiceTypeName(int index){
    if(shipmentServices == null){
      return "";
    }
    try {
      ShipmentServiceTypeModel serviceTypeModel = shipmentServices!.firstWhere((value){
        return value.index == index;
      });

      return serviceTypeModel.name;

    } catch(error) {
      return "";
    }
  }

  /*insertShipmentTypeList(){
    List<Map<String, dynamic>> shipmentTypes = [
      {"index": 0, "name": "EX-W DOOR TO DESTINATION PORT"},
      {"index": 1, "name": "EX-W DOOR TO DESTINATION AIR PORT"},
      {"index": 2, "name": "EX-W DOOR TO CLIENT DOOR"},
      {"index": 3, "name": "AGENT DOOR TO ORIGIN PORT"},
      {"index": 4, "name": "AGENT DOOR TO DESTINATION PORT"},
      {"index": 5, "name": "AGENT DOOR TO DESTINATION AIR PORT"},
      {"index": 6, "name": "AGENT DOOR TO CLIENT DOOR"},
      {"index": 7, "name": "FOB TO DESTINATION PORT"},
      {"index": 8, "name": "FOB TO DESTINATION AIR PORT"},
      {"index": 9, "name": "FOB TO CLIENT DOOR"},
      {"index": 10, "name": "DESTINATION PORT CUSTOM CLEARANCE"},
      {"index": 11, "name": "DESTINATION PORT CUSTOM CLEARANCE AND DELIVERY"},
      {"index": 12, "name": "DESTINATION AIR PORT CUSTOM CLEARANCE"},
      {"index": 13, "name": "DESTINATION AIR PORT CUSTOM CLEARANCE AND DELIVERY"},
      {"index": 14, "name": "LOCAL DELIVERY"},
      {"index": 15, "name": "WAREHOUSING"},
      {"index": 16, "name": "TRANSPORTATION AND WAREHOUSING"},
      {"index": 17, "name": "ALL IN - DOOR TO DOOR"},
    ];
    FirebaseFirestore.instance.doc("settings/W1pJP3GegXh6oH1aEksB").update({
      "shipmentTypes": shipmentTypes
    });
  }*/

}