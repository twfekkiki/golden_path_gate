import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment_status.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/timeline_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_list/widget/filter_shipments.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';

class AddNewStageDialog extends StatefulWidget {

  final int current;

  static show(BuildContext context,int current){
    return showDialog(context: context, builder: (context){
      return AddNewStageDialog(
        current: current,
      );
    });
  }

  const AddNewStageDialog({super.key, required this.current});

  @override
  State<AddNewStageDialog> createState() => _AddNewStageDialogState();
}

class _AddNewStageDialogState extends State<AddNewStageDialog> {

  ShipmentStatusModel? status;
  String? note;

  final AppInfoService _appInfoService = AppInfoService();


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kCornerRadius),
      ),
      elevation: 0.8,
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: 400
              ),
              child: FilterItem(
                onSubmit: (key , value ) {
                  status = value;
                },
                title: AppLocalizations.of(context).trans("newStage"),
                type: 'dropdown',
                filterKey: 'shipmentNumber',
                values: _appInfoService.status!.sublist(widget.current + 1),//.map((e) => e.name).toList(),
              ),
            ),
            const SizedBox(height: 8,),
            Container(
              constraints: BoxConstraints(
                  maxWidth: 400
              ),
              child: FilterItem(
                onSubmit: (key , value ) {
                  note = value;
                },
                title: AppLocalizations.of(context).trans('note'),
                type: 'text-field',
                filterKey: 'shipmentNumber',
                hint: AppLocalizations.of(context).trans('yourNote'),
                lines: 3,
                //values: ['new','delivered','in-progress','delivery'],
              ),
            ),
            const SizedBox(height: 8,),
            ElevatedButton(
                onPressed: (){
                  if(status != null){
                    Navigator.of(context).pop(
                        ChangeStatusModel(status: status!, note: note??'')
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff008000),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    )
                ),
                child: Text(
                  AppLocalizations.of(context).trans('add'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 14
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
