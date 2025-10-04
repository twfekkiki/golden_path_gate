import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/payment.dart';
import 'package:golden_path_gate_admin_portal/models/shipment_status.dart';
import 'package:intl/intl.dart' as intl;

class TransportType {
  static String air = 'Air';
  static String land = 'Land';
  static String sea = 'Sea';
  static List<String> values = [air, land, sea];
}

class ShipmentLoadType {
  static String ftl = 'FTL';
  static String ltl = 'LTL';
  static String fcl = 'FCL';
  static String lcl = 'LCL';

  static List<String> values = [ftl, ltl, fcl, lcl];

  static List<String> airLines = [];
  static List<String> landLines = [ftl, ltl];
  static List<String> seaLines = [fcl, lcl];
}

class PackagingType {
  static String cartoons = 'Cartoons';
  static String pallets = 'Pallets';
  static String pieces = 'Pieces';
  static List<String> values = [cartoons, pallets, pieces];
}

// class ShipmentServiceType {
//   static String portToPort = 'Port to Port';
//   static String warehouseToPort = 'Warehouse to Port';
//   static List<String> values = [portToPort, warehouseToPort];
// }

// enum ShipmentStatus {
//   start,preparing,packaging,delivery,delivered,cancelled
// }

class ShipmentDimension {
  final double? l, w, h;
  final int? count;

  ShipmentDimension({
    this.l,
    this.w,
    this.h,
    this.count,
  });

  factory ShipmentDimension.fromMap(Map<String,dynamic> data){
    return ShipmentDimension(
      l: data['l'],
      w: data['w'],
      h: data['h'],
      count: data['count'],
    );
  }

  Map<String, dynamic> get toMap => {'l': l, 'w': w, 'h': h, 'count': count};

  bool get isEmpty {
    return l == null && w == null && h == null && count == null;
  }

  bool get isCompleted {
    return l != null && w != null && h != null && count != null;
  }

  @override
  String toString() {
    return 'ShipmentDimension{l: $l, w: $w, h: $h, count: $count}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShipmentDimension &&
        l == other.l &&
        w == other.w &&
        h == other.h &&
        count == other.count;
  }

  // Override hashCode when overriding ==
  @override
  int get hashCode => Object.hash(l, w, h, count);
}

class ShipmentCreateModel {
  final String shipmentTransportType;
  final String shipmentNumber;
  final String? senderInfo;
  final String? receiverInfo;
  final String? shippingCompany;
  final String? shipmentLoadType;
  final int? shipmentServiceType;
  final String? packagingType;
  final int? piecesCount;
  final double? grossWeight;
  final double? chargeableWeight;
  final double? cbm;
  final List<String> hsCodes;
  final List<ShipmentDimension> dimensions;
  final String note;
  final String customerName;
  final String customerId;
  final List<FileModel> attachments;
  // final DateTime createdAt;


  ShipmentCreateModel({
    required this.shipmentTransportType,
    required this.shipmentNumber,
    required this.senderInfo,
    required this.receiverInfo,
    required this.shippingCompany,
    required this.shipmentLoadType,
    required this.shipmentServiceType,
    required this.packagingType,
    required this.piecesCount,
    required this.grossWeight,
    required this.chargeableWeight,
    required this.cbm,
    required this.dimensions,
    required this.hsCodes,
    required this.note,
    required this.customerId,
    required this.customerName,
    required this.attachments
  });

  @override
  String toString() {
    return 'Shipment(transportType: $shipmentTransportType, number: $shipmentNumber, senderInfo: $senderInfo, receiverInfo: $receiverInfo, shippingCompany: $shippingCompany, loadType: $shipmentLoadType, packagingType: $packagingType, piecesCount: $piecesCount, grossWeight: $grossWeight, chargeableWeight: $chargeableWeight, cbm: $cbm)';
  }

  Map<String, dynamic> get toMap {
    return {
      "shipmentNumber": shipmentNumber,
      "shipmentTransportType": shipmentTransportType,
      "senderInfo": senderInfo,
      "receiverInfo": receiverInfo,
      "shippingCompany": shippingCompany,
      "shipmentLoadType": shipmentLoadType,
      "shipmentServiceType": shipmentServiceType,
      "packagingType": packagingType,
      "piecesCount": piecesCount,
      "grossWeight": grossWeight,
      "chargeableWeight": chargeableWeight,
      "cbm": cbm,
      "hsCode": hsCodes,
      "dimensions": dimensions.map((e){return e.toMap;}).toList(),
      "note": note,
      "createdAt": FieldValue.serverTimestamp(),
      "status": 0,
      "customerName": customerName,
      "customerId": customerId,
      "attachments": attachments.map((e) => e.toMap).toList()
      // "statusHistory":{
      //   "createdAt":FieldValue.serverTimestamp(),
      //   "note":note,
      //   "name":"start"
      // }
    };
  }
}

class Shipment {
  final String uid;
  final String shipmentTransportType;
  final String shipmentNumber;
  final String? senderInfo;
  final String? receiverInfo;
  final String? shippingCompany;
  final String? shipmentLoadType;
  final int? shipmentServiceType;
  final String? packagingType;
  final int? piecesCount;
  final double? grossWeight;
  final double? chargeableWeight;
  final double? cbm;
  final List<String> hsCodes;
  final List<ShipmentDimension> dimensions;
  final String note;
  final DateTime createdAt;
  final String formatedDatetime;
  final int status;
  final String customerName;
  final String customerId;
  final ShipmentPayment? payment;
  final String? origin;
  final DateTime? pickupDate;
  final String? hub;
  final String? destinationPort;
  List<FileModel> attachments;
  // final List<ShipmentStatusHistory> statusHistory;


  Shipment({
    required this.uid,
    required this.shipmentTransportType,
    required this.shipmentNumber,
    required this.senderInfo,
    required this.receiverInfo,
    required this.shippingCompany,
    required this.shipmentLoadType,
    required this.shipmentServiceType,
    required this.packagingType,
    required this.piecesCount,
    required this.grossWeight,
    required this.chargeableWeight,
    required this.cbm,
    required this.dimensions,
    required this.hsCodes,
    required this.createdAt,
    required this.formatedDatetime,
    required this.status,
    required this.note,
    required this.customerId,
    required this.customerName,
    required this.attachments,
    this.payment,
    this.destinationPort,
    this.origin,
    this.pickupDate,
    this.hub,
  });

  factory Shipment.fromDoc(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;
    return Shipment(
      uid: doc.id,
      shipmentTransportType: data['shipmentTransportType'],
      shipmentNumber: data['shipmentNumber'],
      senderInfo: data['senderInfo'],
      receiverInfo: data['receiverInfo'],
      shippingCompany: data['shippingCompany'],
      shipmentLoadType: data['shipmentLoadType'],
      shipmentServiceType: data['shipmentServiceType'],
      packagingType: data['packagingType'],
      piecesCount: data['piecesCount'],
      grossWeight: data['grossWeight'],
      chargeableWeight: data['chargeableWeight'],
      cbm: data['cbm'],
      dimensions: ((data['dimensions']??[])as List)
          .map<ShipmentDimension>((element){
            return ShipmentDimension.fromMap(element);
          }).toList(),
      note: data['note'] ?? "",
      hsCodes: (data['hsCode'] as List).map((e){return e.toString();}).toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      formatedDatetime: intl.DateFormat('d-MMM-y').format((data['createdAt'] as Timestamp).toDate()),
      status: data['status'],//ShipmentStatusModel(data['status'], data['statusName']),// ShipmentStatus.values.firstWhere((element){return element.name == data['status'];}),
      customerName: data['customerName'],
      customerId: data['customerId'],
      payment: data['payment'] == null ? null : ShipmentPayment.fromDoc(data['payment']),
      origin: data['origin'],
      destinationPort: data['destinationPort'],
      hub: data['hub'],
      pickupDate: data['pickupDate'] == null ? null : (data['pickupDate'] as Timestamp).toDate(),
      attachments: data['attachments'] == null ? [] : data['attachments'].map<FileModel>((value){
        return FileModel.fromJson(value);
      }).toList()
    );
  }

  @override
  String toString() {
    return 'Shipment(transportType: $shipmentTransportType, number: $shipmentNumber, senderInfo: $senderInfo, receiverInfo: $receiverInfo, shippingCompany: $shippingCompany, loadType: $shipmentLoadType, packagingType: $packagingType, piecesCount: $piecesCount, grossWeight: $grossWeight, chargeableWeight: $chargeableWeight, cbm: $cbm)';
  }
}

class ShipmentStatusHistory {
  // String name;
  DateTime createdAt;
  String formatedCreatedAt;
  String note;
  int status;

  ShipmentStatusHistory({
    // required this.name,
    required this.createdAt,
    required this.formatedCreatedAt,
    required this.note,
    required this.status
  });

  factory ShipmentStatusHistory.fromMap(Map<String,dynamic> data) {
    return ShipmentStatusHistory(
      // name: data['name'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      formatedCreatedAt: intl.DateFormat('d-MMM-y').format((data['createdAt'] as Timestamp).toDate()),
      note: data['note'] ?? '',
      status: data['status']//ShipmentStatus.values.firstWhere((e) => e.name == data['name'])
    );
  }

}

class ShipmentUpdateModel {
  final Shipment shipment;
  final String? senderInfo;
  final String? receiverInfo;
  final String? shippingCompany;
  final String? shipmentLoadType;
  final int? shipmentServiceType;
  final String? packagingType;
  final int? piecesCount;
  final double? grossWeight;
  final double? chargeableWeight;
  final double? cbm;
  final List<String>? hsCodes;
  final List<ShipmentDimension>? dimensions;
  final String? note;
  final String? origin;
  final DateTime? pickupDate;
  final String? hub;
  final String? destinationPort;

  ShipmentUpdateModel({
    required this.shipment,
    required this.senderInfo,
    required this.receiverInfo,
    required this.shippingCompany,
    required this.shipmentLoadType,
    required this.shipmentServiceType,
    required this.packagingType,
    required this.piecesCount,
    required this.grossWeight,
    required this.chargeableWeight,
    required this.cbm,
    required this.dimensions,
    required this.hsCodes,
    required this.note,
    required this.destinationPort,
    required this.hub,
    required this.origin,
    required this.pickupDate
  });

  Map<String, dynamic> get toMap {
    return {
      if(senderInfo != shipment.senderInfo)
        "senderInfo": senderInfo,
      if(receiverInfo != shipment.receiverInfo)
        "receiverInfo": receiverInfo,
      if(shippingCompany != shipment.shippingCompany)
        "shippingCompany": shippingCompany,
      if(shipmentLoadType != shipment.shipmentLoadType)
        "shipmentLoadType": shipmentLoadType,
      if(shipmentServiceType != shipment.shipmentServiceType)
        "shipmentServiceType": shipmentServiceType,
      if(packagingType != shipment.packagingType)
        "packagingType": packagingType,
      if(piecesCount != shipment.piecesCount)
        "piecesCount": piecesCount,
      if(grossWeight != shipment.grossWeight)
        "grossWeight": grossWeight,
      if(chargeableWeight != shipment.chargeableWeight)
        "chargeableWeight": chargeableWeight,
      if(cbm != shipment.cbm)
        "cbm": cbm,
      if(hsCodes != null)
        "hsCode": hsCodes,
      if(dimensions != null)
        "dimensions": dimensions?.map((e){return e.toMap;}).toList(),
      if((note??"") != shipment.note)
        "note": note,


      if(pickupDate != shipment.pickupDate)
        "pickupDate": pickupDate,
      if((origin??"") != shipment.origin)
        "origin": origin,
      if((destinationPort??"") != shipment.destinationPort)
        "destinationPort": destinationPort,
      if( (hub??"") != shipment.hub)
        "hub": hub,


    };
  }
}
