import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/models/file_model.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/create_shipment_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/select_customer_view.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';
import 'package:golden_path_gate_admin_portal/services/firebase_storage_handler.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'HSCodeList.dart';
import 'attachments_area.dart';
import 'dimensions_list.dart';

class ShipmentFormPage extends StatefulWidget {
  const ShipmentFormPage({super.key});

  @override
  State<ShipmentFormPage> createState() => _ShipmentFormPageState();
}

class _ShipmentFormPageState extends State<ShipmentFormPage> {
  final CreateShipmentProvider createShipmentProvider = CreateShipmentProvider();
  final AppInfoService appInfoServiceProvider = AppInfoService();

  final _formKey = GlobalKey<FormState>();

  // Controllers
  final TextEditingController _shipmentNumberController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _senderInfoController = TextEditingController();
  final TextEditingController _receiverInfoController = TextEditingController();
  final TextEditingController _shippingCompanyController = TextEditingController();
  final TextEditingController _piecesCountController = TextEditingController();
  final TextEditingController _grossWeightController = TextEditingController();
  final TextEditingController _chargeableWeightController = TextEditingController();
  final TextEditingController _cbmController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  // Dropdown values
  String? _shipmentTransportType;
  String? _shipmentLoadType;
  String? _packagingType;
  int? _shipmentServiceType;
  Customer? _customer;

  List<ShipmentDimension> dimensions = [];
  List<String> hsCodes = [];

  List<FileModel> attachments = [];

  @override
  void initState() {
    appInfoServiceProvider.loadCreateShipmentData();
    super.initState();
  }

  void _createShipment() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final shipment = ShipmentCreateModel(
        shipmentTransportType: _shipmentTransportType!,
        shipmentNumber: _shipmentNumberController.text,
        senderInfo: _senderInfoController.text,
        receiverInfo: _receiverInfoController.text,
        shippingCompany: _shippingCompanyController.text,
        shipmentLoadType: _shipmentLoadType,
        packagingType: _packagingType!,
        shipmentServiceType: _shipmentServiceType,
        piecesCount: int.tryParse(_piecesCountController.text) ?? 0,
        grossWeight: double.tryParse(_grossWeightController.text) ?? 0.0,
        chargeableWeight: double.tryParse(_chargeableWeightController.text) ?? 0.0,
        cbm: double.tryParse(_cbmController.text) ?? 0.0,
        dimensions: dimensions.where((e) => !e.isEmpty).toList(),
        hsCodes: hsCodes.where((e) => e.isNotEmpty).toList(),
        note: _noteController.text.trim(),
        customerId: _customer!.uid,
        customerName: _customer!.fullName,
        attachments:attachments,
      );

      // Process the shipment object as needed
      print(shipment.toMap);

      var result = await createShipmentProvider.createShipment(shipment);

      print(result);


      if(result != null && createShipmentProvider.done){

        context.go('/shipment-list/details/$result');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: appInfoServiceProvider,
      child: ChangeNotifierProvider.value(
        value: createShipmentProvider,
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,//AppColors.background,
          body: Consumer2<AppInfoService,CreateShipmentProvider>(
            builder: (context,appInfoService,snapshot,child) {
              if(appInfoService.status == null){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return LayoutBuilder(
                builder: (context,constrains) {
                  double canvasWidth = 800;
                  if(canvasWidth > constrains.maxWidth){
                    canvasWidth = constrains.maxWidth;
                  }
                  double fieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2)  ;
                  double minFieldWidth = ((canvasWidth - (16 + 16 + 60 + 2)) / 4)  ;
                  if(canvasWidth < 600){
                    // canvasWidth = 600;
                    fieldWidth = canvasWidth - 44;
                    minFieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2);
                  }
                  return ModalProgressHUD(
                    inAsyncCall: snapshot.loading,
                    progressIndicator: _progressIndicator,
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Center(
                          child: Container(
                            width: canvasWidth,
                            margin: EdgeInsets.symmetric(vertical: 36),
                            decoration: BoxDecoration(
                              color: Theme.of(context).canvasColor,//AppColors.background,
                              borderRadius: BorderRadius.circular(kCornerRadius),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                )
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  FormWidgetContainer(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("shipmentNumber"),
                                            child: TextFormField(
                                              controller: _shipmentNumberController,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("shipmentNumberHint"),
                                              ),
                                              validator: (value) => value == null || value.isEmpty
                                                  ? AppLocalizations.of(context).trans("shipmentNumberValidation")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("customer"),
                                            child: TextFormField(
                                              controller: _customerNameController,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              readOnly: true,
                                              onTap: () async {
                                                var result = await SelectCustomerView.show(context);
                                                if (result != null) {
                                                  _customer = (result as Customer);
                                                  _customerNameController.text = _customer!.fullName;
                                                }
                                              },
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("clickToSelect"),
                                              ),
                                              validator: (value) => value == null || value.isEmpty
                                                  ? AppLocalizations.of(context).trans("pleaseSelectCustomer")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("shipmentTransportType"),
                                            child: DropdownButtonFormField<String>(
                                              value: _shipmentTransportType,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("airLandSea"),
                                              ),
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                              items: TransportType.values
                                                  .map(
                                                      (type) => DropdownMenuItem(
                                                        value: type,
                                                        child: Text(
                                                            AppLocalizations.of(context).trans(type),
                                                            style: TextStyle(fontSize: 12, color: Colors.black)
                                                        ),
                                                      )).toList(),
                                              onChanged: (value) =>
                                                  setState(() => _shipmentTransportType = value),
                                              validator: (value) => value == null
                                                  ? AppLocalizations.of(context)
                                                  .trans("pleaseSelectTransportType")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("shipmentServiceType"),
                                            child: DropdownButtonFormField<int>(
                                              value: _shipmentServiceType,
                                              isExpanded:true,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context)
                                                    .trans("portToPortWarehouseToPort"),
                                              ),
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                              items: appInfoService.shipmentServices!
                                                  .map(
                                                      (type) => DropdownMenuItem(
                                                        value: type.index,
                                                        child: Text(
                                                            type.name,
                                                            style: TextStyle(
                                                                fontSize: 12,
                                                                color: Colors.black,
                                                            ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      )).toList(),
                                              onChanged: (value) =>
                                                  setState(() => _shipmentServiceType = value),
                                              validator: (value) => value == null
                                                  ? AppLocalizations.of(context)
                                                  .trans("pleaseSelectServiceType")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FormWidgetContainer(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("senderInfo"),
                                            child: TextFormField(
                                              controller: _senderInfoController,
                                              decoration: getInputDecoration(
                                                  hint: AppLocalizations.of(context).trans("tradingCompany")),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              validator: (value) => value == null || value.isEmpty
                                                  ? AppLocalizations.of(context).trans("pleaseEnterSenderInfo")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("receiverInfo"),
                                            child: TextFormField(
                                              controller: _receiverInfoController,
                                              decoration: getInputDecoration(
                                                  hint: AppLocalizations.of(context).trans("tradingCompany")),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              validator: (value) => value == null || value.isEmpty
                                                  ? AppLocalizations.of(context).trans("pleaseEnterReceiverInfo")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("shippingLine"),
                                            child: TextFormField(
                                              controller: _shippingCompanyController,
                                              decoration: getInputDecoration(
                                                  hint: AppLocalizations.of(context).trans("shippingLineName")),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              validator: (value) => value == null || value.isEmpty
                                                  ? AppLocalizations.of(context)
                                                  .trans("pleaseEnterShippingLineName")
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FormWidgetContainer(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("shipmentLoadType"),
                                            child: DropdownButtonFormField<String>(
                                              value: _shipmentLoadType,
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("shipmentLoadType"),
                                              ),
                                              items: shipmentLoadTypes
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                                  .toList(),
                                              onChanged: (value) =>
                                                  setState(() => _shipmentLoadType = value),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("packagingType"),
                                            child: DropdownButtonFormField<String>(
                                              value: _packagingType,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("packagingType"),
                                              ),
                                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400),
                                              items: PackagingType.values
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                                  .toList(),
                                              onChanged: (value) =>
                                                  setState(() => _packagingType = value),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: minFieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("piecesCount"),
                                            child: TextFormField(
                                              controller: _piecesCountController,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("piecesCount"),
                                              ),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: minFieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("grossWeight"),
                                            child: TextFormField(
                                              controller: _grossWeightController,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("grossWeight"),
                                              ),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: minFieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("chargeableWeight"),
                                            child: TextFormField(
                                              controller: _chargeableWeightController,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("chargeableWeight"),
                                              ),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: minFieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("cbm"),
                                            child: TextFormField(
                                              controller: _cbmController,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("cbmHint"),
                                              ),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("dimensions"),
                                            child: ShipmentDimensionsField(
                                              onSaved: (value) {
                                                dimensions = value ?? [];
                                              },
                                              validator: (value) {
                                                return ShipmentDimensionsField.validateDimensions(value);
                                              },
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("hsCode"),
                                            child: HSCodeListField(
                                              onSaved: (value) {
                                                hsCodes = value ?? [];
                                              },
                                              // validator: (value) {},
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  FormWidgetContainer(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width: canvasWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("notes"),
                                            child: TextFormField(
                                              controller: _noteController,
                                              decoration: getInputDecoration(
                                                hint: AppLocalizations.of(context).trans("notesAboutShipment"),
                                              ),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  FormWidgetContainer(
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      crossAxisAlignment: WrapCrossAlignment.start,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("billOfLoading"),
                                            child: SizedBox(
                                              height: 200,
                                              child: AttachmentsArea(
                                                label: 'billOfLoading',
                                                max: 1,
                                                onChanged: (files){
                                                  attachments.removeWhere((f) => f.label == 'billOfLoading');
                                                  attachments.addAll(files);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("invoice"),
                                            child: SizedBox(
                                              height: 200,
                                              child: AttachmentsArea(
                                                label: 'invoice',
                                                max: 1,
                                                onChanged: (files){
                                                  attachments.removeWhere((f) => f.label == 'invoice');
                                                  attachments.addAll(files);
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: canvasWidth,
                                          child: FormInputContainer(
                                            title: AppLocalizations.of(context).trans("attachments"),
                                            child: SizedBox(
                                              height: 200,
                                              child: AttachmentsArea(
                                                onChanged: (files){
                                                  attachments.removeWhere((f) => f.label == null);
                                                  attachments.addAll(files);
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _createShipment,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      foregroundColor: Colors.white,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(kCornerRadius),
                                      ),
                                    ),
                                    child: Text(AppLocalizations.of(context).trans("createShipment")),
                                  ),
                                  if (snapshot.error != null)
                                    Center(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade50,
                                          borderRadius: BorderRadius.circular(kCornerRadius),
                                          border: Border.all(color: Colors.black),
                                        ),
                                        padding: EdgeInsets.all(16),
                                        margin: EdgeInsets.symmetric(vertical: 12),
                                        child: Text(
                                          AppLocalizations.of(context).trans("errorSample"),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );

                }
              );
            }
          ),
        ),
      ),
    );
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
              color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.white12,
              width: 0.8
          )
      ),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.white12,
              width: 0.8
          )
      ),
      disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.white12,
              width: 0.8
          )
      ),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kCornerRadius),
          borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light ? Colors.black12 : Colors.white12,
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


  Widget get _progressIndicator {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitThreeInOut(
          color: AppColors.secondary,
        ),
        const SizedBox(height: 8,),
        Text(
          AppLocalizations.of(context).trans("creatingShipment"),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 30
          ),
        )
      ],
    );
  }


  List<String> get shipmentLoadTypes {
    if(_shipmentTransportType == 'Land'){
      return ShipmentLoadType.landLines;
    }
    if(_shipmentTransportType == 'Sea'){
      return ShipmentLoadType.seaLines;
    }
    return ShipmentLoadType.airLines;
  }


}



