import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/HSCodeList.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/dimensions_list.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/theme.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class UpdatableTextFields extends StatefulWidget {

  final Shipment shipment;

  const UpdatableTextFields({super.key, required this.shipment});

  @override
  State<UpdatableTextFields> createState() => _UpdatableTextFieldsState();
}

class _UpdatableTextFieldsState extends State<UpdatableTextFields> {

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

  // Dropdown values
  String? _shipmentLoadType;
  String? _packagingType;
  String? _shipmentServiceType;

  List<ShipmentDimension> dimensions = [];
  List<String> hsCodes = [];

  bool isChanged = false;


  @override
  void initState() {
    super.initState();
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
    _shipmentLoadType = widget.shipment.shipmentLoadType;
    _packagingType = widget.shipment.packagingType;
    _shipmentServiceType = widget.shipment.shipmentServiceType;

    dimensions = widget.shipment.dimensions;
    hsCodes = widget.shipment.hsCodes;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context,constrains) {

          double canvasWidth = constrains.maxWidth;
          // if(canvasWidth > constrains.maxWidth){
          //   canvasWidth = constrains.maxWidth;
          // }
          double fieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2)  ;
          double minFieldWidth = ((canvasWidth - (16 + 16 + 60 + 2)) / 4)  ;
          if(canvasWidth < 600){
            // canvasWidth = 600;
            fieldWidth = canvasWidth - 44;
            minFieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2);
          }

          return ModalProgressHUD(
            inAsyncCall: false,//snapshot.loading,
            //progressIndicator: _progressIndicator,
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
                              "Shipment number #${widget.shipment.shipmentNumber}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.secondary,
                                  fontSize: 16
                              ),
                            )
                        ),
                        ElevatedButton(
                            onPressed: isChanged ? () async {

                            } : null ,
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Color(0xff008000),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)
                                )
                            ),

                            child: Text(
                              "Update",
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
                                title: 'Sender Info',
                                child: TextFormField(
                                  controller: _senderInfoController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Trading company..'),
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
                                title: 'Receiver Info',
                                child: TextFormField(
                                  controller: _receiverInfoController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Trading company..'),
                                  maxLines: 3,
                                  cursorHeight: 16,
                                  cursorWidth: 2,
                                  onChanged: (val){
                                    _checkIfUpdated();
                                  },
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter receiver info' : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width:fieldWidth,
                              child: FormInputContainer(
                                title: 'Shipping Line',
                                child: TextFormField(
                                  controller: _shippingCompanyController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Shipping line name..'),
                                  maxLines: 3,
                                  cursorHeight: 16,
                                  cursorWidth: 2,
                                  onChanged: (val){
                                    _checkIfUpdated();
                                  },
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter shipping line name' : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              width:fieldWidth,
                              child: FormInputContainer(
                                title: 'Shipment Service Type',
                                child: DropdownButtonFormField<String>(
                                  value: _shipmentServiceType,
                                  decoration: AppTheme.getInputDecoration(
                                    hint: 'Port to Port, Warehouse to Port',
                                  ),
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400
                                  ),
                                  items: ShipmentServiceType.values
                                      .map((type) => DropdownMenuItem(value: type, child: Text(type,style: TextStyle(fontSize: 12,color: Colors.black),)))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() => _shipmentServiceType = value);
                                    _checkIfUpdated();
                                  } ,
                                  validator: (value) => value == null ? 'Please select a service type' : null,
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
                                title: 'Shipment Load Type',
                                child: DropdownButtonFormField<String>(
                                  value: _shipmentLoadType,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400
                                  ),
                                  decoration: AppTheme.getInputDecoration(hint: 'Shipment load type'),
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
                                title: 'Packaging Type',
                                child: DropdownButtonFormField<String>(
                                  value: _packagingType,
                                  decoration: AppTheme.getInputDecoration(hint: 'Packaging type'),
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
                                title: 'Pieces Count',
                                child: TextFormField(
                                  controller: _piecesCountController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Pieces Count'),
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
                                title: 'Gross Weight',
                                child: TextFormField(
                                  controller: _grossWeightController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Gross Weight'),
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
                                title: 'Chargeable Weight',
                                child: TextFormField(
                                  controller: _chargeableWeightController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Chargeable Weight'),
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
                                title: 'CBM',
                                child: TextFormField(
                                  controller: _cbmController,
                                  decoration: AppTheme.getInputDecoration(hint: '12'),
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
                                  title: 'Dimensions',
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
                                title: 'HS Code',
                                child: HSCodeListField(
                                  onSaved: (value){
                                    hsCodes = value ?? [];
                                  },
                                  initialValue: widget.shipment.hsCodes,
                                  onChanged: (value){
                                    print("hsCodes");
                                    print(hsCodes);
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
                                title: 'Notes',
                                child: TextFormField(
                                  controller: _noteController,
                                  decoration: AppTheme.getInputDecoration(hint: 'Notes about the shipment'),
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
        (!areListsEqual(hsCodes,widget.shipment.hsCodes))
    ;
    setState(() {

    });

  }

  bool areListsEqual(List list1, List list2) {
    if (list1.length != list2.length) return false;

    for (int i = 0; i < list1.length; i++) {
      print(list1[i]);
      print(list2[i]);
      print(list1[i] != list2[i]);

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


    super.dispose();
  }
}
