import 'package:cloud_firestore/cloud_firestore.dart';

class ShipmentPayment {
  DateTime? paymentDate;
  bool? isPayed;
  String? POD;
  String? note;

  ShipmentPayment({this.paymentDate, this.isPayed, this.POD,this.note});

  factory ShipmentPayment.fromDoc(Map<String,dynamic> data){
    return ShipmentPayment(
      paymentDate: data['paymentDate'] == null ? null : (data['paymentDate'] as Timestamp).toDate(),
      isPayed: data['isPayed']??false,
      note: data['note']??""
    );
  }

  Map<String,dynamic> get toMap => {
    if(paymentDate != null)
      "paymentDate": Timestamp.fromDate(paymentDate!),
    if(isPayed != null)
      "isPayed":isPayed,
    if(note != null)
      "note":note
    // if(POD != null)
    //   "POD"
  };
}