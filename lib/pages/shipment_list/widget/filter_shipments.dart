import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';

class FilterShipments extends StatefulWidget {
  const FilterShipments({super.key});

  @override
  State<FilterShipments> createState() => _FilterShipmentsState();
}

class _FilterShipmentsState extends State<FilterShipments> {

  final AppInfoService _appInfoService = AppInfoService();


  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context,constrains) {
        int rowCount = 3;
        if(constrains.maxWidth < 600){
          rowCount = 2;
        }
        if(constrains.maxWidth < 400){
          rowCount = 1;
        }

        double width = (constrains.maxWidth - (12 * (rowCount - 1)))/rowCount;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: width,
              child: FilterItem(
                onSubmit: (key , value ) {

                },
                title: AppLocalizations.of(context).trans("shipmentNumber"),
                type: 'text-field',
                filterKey: 'shipmentNumber',
              ),
            ),
            SizedBox(
              width: width,
              child: FilterItem(
                onSubmit: (key , value ) {

                },
                title: AppLocalizations.of(context).trans('transportType'),
                type: 'dropdown',
                filterKey: 'transportType',
                values: TransportType.values,
              ),
            ),
            SizedBox(
              width: width,
              child: FilterItem(
                onSubmit: (key , value ) {

                },
                title: AppLocalizations.of(context).trans("status"),
                type: 'dropdown',
                filterKey: 'status',
                values: _appInfoService.status!.map((e) => e.name).toList()
                // ShipmentStatus.values.map((e) => e.name).toList(),
              ),
            )
          ],
        );
      }
    );
  }
}

class FilterItem extends StatefulWidget {
  final Function(String,dynamic) onSubmit;
  final String title;
  final String type;
  final String filterKey;
  final List<dynamic>? values;
  final String? hint;
  final int lines;
  const FilterItem({super.key, required this.onSubmit, required this.title, required this.type, required this.filterKey, this.values, this.hint, this.lines = 1});

  @override
  State<FilterItem> createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  dynamic value;

  @override
  Widget build(BuildContext context) {
    if(widget.type == 'text-field'){
      return FormInputContainer(
        title: widget.title,
        child: TextFormField(
          // controller: _shipmentNumberController,
          cursorHeight: 16,
          cursorWidth: 2,
          maxLines: widget.lines,
          decoration: getInputDecoration(
            hint: widget.hint ?? '#123000555',
          ),
          onChanged: (value){
            widget.onSubmit(widget.filterKey,value);
          },
          // validator: (value) => value == null || value.isEmpty ? 'Please enter a shipment number' : null,
        ),
      );
    }
    else if(widget.type == 'dropdown'){
      return FormInputContainer(
        title: widget.title,
        child: DropdownButtonFormField<dynamic>(
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.8
                )
            ),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.8
                )
            ),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide(
                    color: Colors.black12,
                    width: 0.8
                )
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 0.8
                )
            ),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kCornerRadius),
                borderSide: BorderSide(
                    color: Colors.red,
                    width: 0.8
                )
            ),
          ),
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w400
          ),
          items: widget.values!
              .map((value) => DropdownMenuItem(value: value, child: Text(AppLocalizations.of(context).trans(value.toString()))))
              .toList(),
          onChanged: (val) {
            setState(() => value = val);
            widget.onSubmit(widget.filterKey,val??"");
          } ,
          // validator: (value) => value == null ? 'Please select a transport type' : null,
        ),
      );
    }
    return const SizedBox();
  }

  InputDecoration getInputDecoration({String? hint}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w300,
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.black12,
              width: 0.8
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: AppColors.primary,
              width: 0.8
          )
      ),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Colors.red,
              width: 0.8
          )
      ),
    );
  }
}

