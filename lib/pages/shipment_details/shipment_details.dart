import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/updatable_text_fields.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/payment/payment_details.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/timeline.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:provider/provider.dart';

class ShipmentDetails extends StatefulWidget {
  final String id;
  const ShipmentDetails({super.key, required this.id});

  @override
  State<ShipmentDetails> createState() => _ShipmentDetailsState();
}

class _ShipmentDetailsState extends State<ShipmentDetails> {

  late ShipmentsDetailsProvider shipmentsDetailsProvider;
  // late ChangeShipmentStatusProvider changeShipmentStatusProvider;


  @override
  void initState() {
    shipmentsDetailsProvider = ShipmentsDetailsProvider(widget.id);
    shipmentsDetailsProvider.getShipmentsDetails();
    // changeShipmentStatusProvider = ChangeShipmentStatusProvider(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShipmentsDetailsProvider>.value(
      value: shipmentsDetailsProvider,
      child: Consumer<ShipmentsDetailsProvider>(
        builder: (context,snapshot,child) {
          if(snapshot.shipment == null){
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          Shipment shipment = snapshot.shipment!;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(kCornerRadius)
            ),
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpdatableTextFields(
                    shipment: shipment,
                  ),
                  // _getTitle('Status details'),
                  FormWidgetContainer(
                    child: FormInputContainer(
                      title: AppLocalizations.of(context).trans("statusDetails"),
                      isMainTitle: true,
                      child: ProcessTimelineWidget(
                        uid: widget.id,
                        //statusHistory: snapshot.shipment!.statusHistory,
                      ),
                    ),
                  ),
                  FormWidgetContainer(
                    child: FormInputContainer(
                        title: "Payment details",
                        isMainTitle: true,
                        child: PaymentDetailsWidget(
                          uid: widget.id,
                          payment: shipment.payment,
                          key: UniqueKey(),
                        )
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  _getTitle(title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black
    ),);
  }
}
