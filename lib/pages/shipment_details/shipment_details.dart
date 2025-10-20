import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/attachments_area.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/updatable_text_fields.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/payment/payment_details.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/timeline.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/custom_app_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'widget/attachments/attachment_section_details.dart';
import 'widget/attachments/attachments_view.dart';

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

  List<FileModel> attachments = [];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ShipmentsDetailsProvider>.value(
      value: shipmentsDetailsProvider,
      child: Consumer<ShipmentsDetailsProvider>(
        builder: (context, snapshot, child) {
          if (snapshot.shipment == null) {
            return Center(child: CircularProgressIndicator());
          }
          Shipment shipment = snapshot.shipment!;
          return ModalProgressHUD(
            inAsyncCall: snapshot.loading,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(kCornerRadius),
              ),
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    UpdatableTextFields(shipment: shipment),
                    // _getTitle('Status details'),
                    FormWidgetContainer(
                      child: FormInputContainer(
                        title: AppLocalizations.of(
                          context,
                        ).trans("statusDetails"),
                        isMainTitle: true,
                        child: ProcessTimelineWidget(
                          uid: widget.id,
                          customerId: shipment.customerId,
                          //statusHistory: snapshot.shipment!.statusHistory,
                        ),
                      ),
                    ),
                    FormWidgetContainer(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: AttachmentSectionDetails(
                                  title: AppLocalizations.of(
                                    context,
                                  ).trans("invoice"),
                                  label: 'invoice',
                                  shipment: shipment,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AttachmentSectionDetails(
                                  title: AppLocalizations.of(
                                    context,
                                  ).trans("billOfLoading"),
                                  label: 'billOfLoading',
                                  shipment: shipment,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: AttachmentSectionDetails(
                              title: AppLocalizations.of(
                                context,
                              ).trans("attachments"),
                              shipment: shipment,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FormWidgetContainer(
                      child: FormInputContainer(
                        title: AppLocalizations.of(
                          context,
                        ).trans("paymentDetails"),
                        isMainTitle: true,
                        child: PaymentDetailsWidget(
                          uid: widget.id,
                          payment: shipment.payment,
                          key: UniqueKey(),
                          userId: shipment.customerId,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  _getTitle(title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }
}
