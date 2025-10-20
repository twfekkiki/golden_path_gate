import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/attachments_area.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/custom_app_button.dart';
import 'package:provider/provider.dart';

class AttachmentSectionDetails extends StatefulWidget {
  final String title;
  final String? label;
  final Shipment shipment;
  const AttachmentSectionDetails({super.key, required this.title, this.label, required this.shipment});

  @override
  State<AttachmentSectionDetails> createState() => _AttachmentSectionDetailsState();
}

class _AttachmentSectionDetailsState extends State<AttachmentSectionDetails> {
  List<FileModel> newAttachments = [];


  @override
  Widget build(BuildContext context) {
    List<FileModel> attachments = widget.shipment.attachments
        .where(
          (file) =>
      file.label == widget.label,
    ).toList();
    final shipmentsDetailsProvider = Provider.of<ShipmentsDetailsProvider>(context,listen: false);
    return FormInputContainer(
      title: widget.title,
      titleSide: CustomAppButton(
        onPressed: newAttachments.isNotEmpty
            ? () async {
          await shipmentsDetailsProvider.uploadNewAttachment(newAttachments);

        }
            : null,
        text: AppLocalizations.of(
          context,
        ).trans("publish"),
      ),
      child: SizedBox(
        height: 200,
        child: AttachmentsArea(
          label: widget.label,
          max: 1,
          initialFiles: newAttachments + attachments,
          onChanged: (files) {
            newAttachments.removeWhere(
                  (f) => f.label == widget.label,
            );
            newAttachments.addAll(files);
          },
        ),
      ),
    );
  }
}
