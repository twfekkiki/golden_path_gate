import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/HSCodeList.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/dimensions_list.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/update_shipment_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/services/app_info_service.dart';
import 'package:golden_path_gate_admin_portal/theme.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class UpdatableTextFields extends StatefulWidget {

  final Shipment shipment;

  const UpdatableTextFields({super.key, required this.shipment});

  @override
  State<UpdatableTextFields> createState() => _UpdatableTextFieldsState();
}

class _UpdatableTextFieldsState extends State<UpdatableTextFields> {

  late UpdateShipmentDetailsProvider updateShipmentDetailsProvider;

  final _formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController _senderInfoController;
  late TextEditingController _receiverInfoController;
  late TextEditingController _shippingCompanyController;
  late TextEditingController _piecesCountController;
  late TextEditingController _grossWeightController;
  late TextEditingController _chargeableWeightController;
  late TextEditingController _cbmController;
  late TextEditingController _noteController;
  late TextEditingController _originController;
  late TextEditingController _destinationPortController;
  late TextEditingController _hubController;

  // Dropdown values
  String? _shipmentLoadType;
  String? _packagingType;
  int? _shipmentServiceType;
  DateTime? _pickUpDate;

  List<ShipmentDimension> dimensions = [];
  List<String> hsCodes = [];

  bool isChanged = false;

  final AppInfoService _appInfoService = AppInfoService();

  @override
  void initState() {
    super.initState();
    updateShipmentDetailsProvider = UpdateShipmentDetailsProvider(widget.shipment.uid);
    _senderInfoController = TextEditingController(
        text: widget.shipment.senderInfo??''
    );
    _receiverInfoController = TextEditingController(
        text: widget.shipment.receiverInfo??''
    );
    _shippingCompanyController = TextEditingController(
        text: widget.shipment.shippingCompany??''
    );
    _piecesCountController = TextEditingController(
        text: widget.shipment.piecesCount?.toString()??''
    );
    _grossWeightController = TextEditingController(
        text: widget.shipment.grossWeight?.toString()??''
    );
    _chargeableWeightController = TextEditingController(
        text: widget.shipment.chargeableWeight?.toString()??''
    );
    _cbmController = TextEditingController(
        text: widget.shipment.cbm?.toString()??''
    );
    _noteController = TextEditingController(
        text: widget.shipment.note
    );
    _originController = TextEditingController(
        text: widget.shipment.origin
    );
    _destinationPortController = TextEditingController(
        text: widget.shipment.destinationPort
    );
    _hubController = TextEditingController(
        text: widget.shipment.hub
    );

    _shipmentLoadType = widget.shipment.shipmentLoadType;
    _packagingType = widget.shipment.packagingType;
    _shipmentServiceType = widget.shipment.shipmentServiceType;

    dimensions = widget.shipment.dimensions;
    hsCodes = widget.shipment.hsCodes;
    _pickUpDate = widget.shipment.pickupDate;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat("d-MMM-y");
    return ChangeNotifierProvider<UpdateShipmentDetailsProvider>.value(
      value: updateShipmentDetailsProvider,
      child: LayoutBuilder(
          builder: (context,constrains) {
            double canvasWidth = constrains.maxWidth;
            double fieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2)  ;
            double minFieldWidth = ((canvasWidth - (16 + 16 + 60 + 2)) / 4)  ;
            if(canvasWidth < 600){
              fieldWidth = canvasWidth - 44;
              minFieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2);
            }
            return Consumer<UpdateShipmentDetailsProvider>(
              builder: (context,state,child) {
                return ModalProgressHUD(
                  inAsyncCall: false,//state.loading,
                  // progressIndicator: _progressIndicator,
                  child: Form(
                    key: _formKey,
                    child: Container(
                      width: canvasWidth,
                      margin: EdgeInsets.symmetric(
                        vertical: 12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                    "${AppLocalizations.of(context).trans("shipmentNumber")} #${widget.shipment.shipmentNumber}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                        fontSize: 16
                                    ),
                                  )
                              ),
                              ElevatedButton(
                                  onPressed: isChanged ? () async {
                                    if(_formKey.currentState!.validate()){
                                      _formKey.currentState!.save();
                                      updateShipmentDetailsProvider.updateShipment(
                                          ShipmentUpdateModel(
                                            shipment: widget.shipment,
                                            senderInfo: _senderInfoController.text,
                                            receiverInfo: _receiverInfoController.text,
                                            shippingCompany: _shippingCompanyController.text,
                                            shipmentLoadType: _shipmentLoadType,
                                            shipmentServiceType: _shipmentServiceType,
                                            packagingType: _packagingType,
                                            piecesCount: int.tryParse(_piecesCountController.text) ?? 0,
                                            grossWeight: double.tryParse(_grossWeightController.text) ?? 0.0,
                                            chargeableWeight: double.tryParse(_chargeableWeightController.text) ?? 0.0,
                                            cbm: double.tryParse(_cbmController.text) ?? 0.0,
                                            dimensions: dimensions,
                                            hsCodes: hsCodes,
                                            note: _noteController.text,
                                            destinationPort: _destinationPortController.text,
                                            hub: _hubController.text,
                                            pickupDate: _pickUpDate,
                                            origin: _originController.text
                                          )
                                      );
                                    }
                                  } : null ,
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      backgroundColor: Color(0xff008000),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5)
                                      )
                                  ),
                                  child:

                                  Text(
                                    AppLocalizations.of(context).trans("update"),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18
                                    ),
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: 12,),
                          FormWidgetContainer(
                              child: Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('senderInfo'),
                                      child: TextFormField(
                                        controller: _senderInfoController,
                                        decoration: AppTheme.getInputDecoration(context,hint: 'Trading company..'),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (val){
                                          _checkIfUpdated();
                                        },
                                        validator: (value) => value == null || value.isEmpty ? 'Please enter sender info' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('receiverInfo'),
                                      child: TextFormField(
                                        controller: _receiverInfoController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("tradingCompany")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (val){
                                          _checkIfUpdated();
                                        },
                                        validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterReceiverInfo") : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('shippingLine'),
                                      child: TextFormField(
                                        controller: _shippingCompanyController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("shippingLineName")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (val){
                                          _checkIfUpdated();
                                        },
                                        validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterShippingLineName") : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('shipmentServiceType'),
                                      child: DropdownButtonFormField<int>(
                                        value: _shipmentServiceType,
                                        isExpanded: true,
                                        decoration: AppTheme.getInputDecoration(context,
                                          hint: AppLocalizations.of(context).trans('portToPortWarehouseToPort'),
                                        ),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400,
                                            color: Theme.of(context).brightness == Brightness.light ?
                                            null : Colors.white
                                        ),
                                        items: _appInfoService.shipmentServices!
                                            .map((type) => DropdownMenuItem(
                                            value: type.index,
                                            child: Text(
                                              _appInfoService.getServiceTypeName(type.index),
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Theme.of(context).brightness == Brightness.light ?
                                                  null : Colors.white
                                              ),
                                            )))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() => _shipmentServiceType = value);
                                          _checkIfUpdated();
                                        } ,
                                        validator: (value) => value == null ? AppLocalizations.of(context).trans("pleaseSelectServiceType") : null,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),
                          FormWidgetContainer(
                              child: Wrap(
                                direction: Axis.horizontal,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                spacing: 12,
                                runSpacing: 12,
                                children: [
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('shipmentLoadType'),
                                      child: DropdownButtonFormField<String>(
                                        value: _shipmentLoadType,
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400
                                        ),
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans('shipmentLoadType')),
                                        items: shipmentLoadTypes
                                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() => _shipmentLoadType = value);
                                          _checkIfUpdated();
                                        } ,
                                        // validator: (value) => value == null ? 'Please select a load type' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('packagingType'),
                                      child: DropdownButtonFormField<String>(
                                        value: _packagingType,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans('packagingType')),
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w400
                                        ),
                                        items: PackagingType.values
                                            .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                            .toList(),
                                        onChanged: (value) {
                                          setState(() => _packagingType = value);
                                          _checkIfUpdated();
                                        } ,
                                        // validator: (value) => value == null ? 'Please select a packaging type' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:minFieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('piecesCount'),
                                      child: TextFormField(
                                        controller: _piecesCountController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans('piecesCount')),
                                        keyboardType: TextInputType.number,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        } ,
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter pieces count' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:minFieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('grossWeight'),
                                      child: TextFormField(
                                        controller: _grossWeightController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans('grossWeight')),
                                        keyboardType: TextInputType.number,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter gross weight' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:minFieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('chargeableWeight'),
                                      child: TextFormField(
                                        controller: _chargeableWeightController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans('chargeableWeight')),
                                        keyboardType: TextInputType.number,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter chargeable weight' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:minFieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('CBM'),
                                      child: TextFormField(
                                        controller: _cbmController,
                                        decoration: AppTheme.getInputDecoration(context,hint: '12'),
                                        keyboardType: TextInputType.number,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter CBM' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: FormInputContainer(
                                        title: AppLocalizations.of(context).trans('dimensions'),
                                        child: ShipmentDimensionsField(
                                          initialValue: widget.shipment.dimensions,
                                          onSaved: (value){
                                            dimensions = value??[];
                                          },
                                          validator: (value){
                                            return ShipmentDimensionsField.validateDimensions(value);
                                          },
                                          onChanged: (value){
                                            dimensions = value ??[];
                                            _checkIfUpdated();
                                          },
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('hsCode'),
                                      child: HSCodeListField(
                                        onSaved: (value){
                                          hsCodes = value ?? [];
                                        },
                                        initialValue: widget.shipment.hsCodes,
                                        onChanged: (value){
                                          hsCodes = value ??[];
                                          _checkIfUpdated();
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
                                      title: AppLocalizations.of(context).trans('notes'),
                                      child: TextFormField(
                                        controller: _noteController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("notesAboutTheShipment")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter the note' : null,
                                      ),
                                    ),
                                  )
                                ],
                              )
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
                                      title: AppLocalizations.of(context).trans('origin'),
                                      child: TextFormField(
                                        controller: _originController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("origin")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter the note' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('hub'),
                                      child: TextFormField(
                                        controller: _hubController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("hub")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter the note' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: FormInputContainer(
                                      title: AppLocalizations.of(context).trans('destinationPort'),
                                      child: TextFormField(
                                        controller: _destinationPortController,
                                        decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("destinationPort")),
                                        maxLines: 3,
                                        cursorHeight: 16,
                                        cursorWidth: 2,
                                        onChanged: (value) {
                                          _checkIfUpdated();
                                        },
                                        // validator: (value) => value == null || value.isEmpty ? 'Please enter the note' : null,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: fieldWidth,
                                    child: InkWell(
                                      borderRadius: BorderRadius.circular(kCornerRadius),
                                      onTap: () async {
                                        DateTime? value = await showDatePicker(
                                            context: context,
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime.now().add(Duration(days: 500))
                                        );
                                        if(value != null) {
                                          _pickUpDate = value;
                                          _checkIfUpdated();
                                        }
                                      },
                                      child: FormInputContainer(
                                        title: AppLocalizations.of(context).trans('pickupDate'),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12
                                          ),
                                          child: Text(
                                            _pickUpDate == null ?
                                            AppLocalizations.of(context).trans("clickToSelect") :
                                            dateFormatter.format(_pickUpDate!),
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 12
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                          ),

                          // FormWidgetContainer(
                          //     child: Wrap(
                          //       direction: Axis.horizontal,
                          //       crossAxisAlignment: WrapCrossAlignment.start,
                          //       spacing: 12,
                          //       runSpacing: 12,
                          //       children: [
                          //         SizedBox(
                          //           width: canvasWidth,
                          //           child: FormInputContainer(
                          //             title: 'Attachments',
                          //             child: AttachmentsArea(),
                          //           ),
                          //         )
                          //       ],
                          //     )
                          // ),
                          // SizedBox(height: 20),
                          // ElevatedButton(
                          //   onPressed: _createShipment,
                          //   style: ElevatedButton.styleFrom(
                          //       backgroundColor: AppColors.secondary,
                          //       foregroundColor: Colors.white,
                          //       elevation: 1,
                          //       shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(kCornerRadius)
                          //       )
                          //   ),
                          //   child: Text('Create Shipment'),
                          // ),
                          // if(snapshot.error != null)
                          //   Center(
                          //     child: Container(
                          //       decoration: BoxDecoration(
                          //           color: Colors.red.shade50,
                          //           borderRadius: BorderRadius.circular(kCornerRadius),
                          //           border: Border.all(
                          //               color: Colors.black
                          //           )
                          //       ),
                          //       padding: EdgeInsets.all(16),
                          //       margin: EdgeInsets.symmetric(
                          //           vertical: 12
                          //       ),
                          //       child: Text(
                          //         'error with the error in the error but erroring the error need more errors to error the thing out of the error zone!',
                          //         // snapshot.error.toString(),
                          //         style: TextStyle(
                          //             fontSize: 14,
                          //             color: Colors.red,
                          //             fontWeight: FontWeight.w600
                          //         ),
                          //       ),
                          //     ),
                          //   )
                        ],
                      ),
                    ),
                  ),
                );
              }
            );
          }
      ),
    );
  }

  _checkIfUpdated(){
    isChanged =
    _senderInfoController.text != (widget.shipment.senderInfo??"") ||
    _receiverInfoController.text != (widget.shipment.receiverInfo??'') ||
    _shippingCompanyController.text != (widget.shipment.shippingCompany??"") ||
    _shipmentLoadType != widget.shipment.shipmentLoadType ||
    _shipmentServiceType != widget.shipment.shipmentServiceType ||
    _noteController.text != widget.shipment.note ||
    _cbmController.text != (widget.shipment.cbm?.toString()??"") ||
    _grossWeightController.text != (widget.shipment.grossWeight?.toString()??"") ||
    _chargeableWeightController.text != (widget.shipment.chargeableWeight?.toString()??"") ||
    _piecesCountController.text != (widget.shipment.piecesCount?.toString()??"") ||
    _packagingType != widget.shipment.packagingType ||
        (!areListsEqual(dimensions,widget.shipment.dimensions)) ||
        (!areListsEqual(hsCodes,widget.shipment.hsCodes)) ||
        _pickUpDate != widget.shipment.pickupDate ||
        _originController.text != widget.shipment.origin ||
        _destinationPortController.text != widget.shipment.destinationPort ||
        _hubController.text != widget.shipment.hub
    ;
    setState(() {

    });

  }

  bool areListsEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      if (list1[i] != list2[i]) return false;
    }

    return true;
  }

  List<String> get shipmentLoadTypes {
    if(widget.shipment.shipmentTransportType == 'Land'){
      return ShipmentLoadType.landLines;
    }
    if(widget.shipment.shipmentTransportType == 'Sea'){
      return ShipmentLoadType.seaLines;
    }
    return ShipmentLoadType.airLines;
  }


  @override
  void dispose() {
    _senderInfoController.dispose();
    _receiverInfoController.dispose();
    _shippingCompanyController.dispose();
    _piecesCountController.dispose();
    _grossWeightController.dispose();
    _chargeableWeightController.dispose();
    _cbmController.dispose();
    _noteController.dispose();
    _originController.dispose();
    _hubController.dispose();
    _destinationPortController.dispose();
    super.dispose();
  }
}
