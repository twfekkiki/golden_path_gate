import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/models/shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/create_shipment_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/customers/select_customer_view.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
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
  String? _shipmentServiceType;
  Customer? _customer;

  List<ShipmentDimension> dimensions = [];
  List<String> hsCodes = [];


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
        customerName: _customer!.fullName
      );

      // Process the shipment object as needed
      print(shipment.toMap);

      var result = await createShipmentProvider.createShipment(shipment);

      print(result);

      if(result != null && createShipmentProvider.done){
        context.go('/shipments-list/details/$result');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: createShipmentProvider,
      child: Scaffold(
        // appBar: AppBar(
        //   title: Text('Create Shipment'),
        //   actions: [
        //     IconButton(
        //       icon: Icon(Icons.home),
        //       onPressed: () {
        //         // Navigate to home or another page
        //         Navigator.pop(context);
        //       },
        //     ),
        //   ],
        // ),
        backgroundColor: AppColors.background,
        body: Consumer<CreateShipmentProvider>(
          builder: (context,snapshot,child) {
            return LayoutBuilder(
              builder: (context,constrains) {

                double canvasWidth = 700;
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
                          margin: EdgeInsets.symmetric(
                            vertical: 36,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(kCornerRadius),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                spreadRadius: 1,
                                blurRadius: 5
                              )
                            ]
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
                                          width:fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Form Number #',
                                            child: TextFormField(
                                              controller: _shipmentNumberController,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              decoration: getInputDecoration(
                                                hint: '#123000555',
                                              ),
                                              validator: (value) => value == null || value.isEmpty ? 'Please enter a shipment number' : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Customer',
                                            child: TextFormField(
                                              controller: _customerNameController,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              readOnly: true,
                                              onTap: () async {
                                                var result = await SelectCustomerView.show(context);
                                                if(result != null){
                                                  _customer = (result as Customer);
                                                  _customerNameController.text = _customer!.fullName;
                                                }
                                              },
                                              decoration: getInputDecoration(
                                                hint: 'click to select',
                                              ),
                                              validator: (value) => value == null || value.isEmpty ? 'Please select a customer' : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Shipment Transport Type',
                                            child: DropdownButtonFormField<String>(
                                              value: _shipmentTransportType,
                                              decoration: getInputDecoration(
                                                hint: 'Air, Land, Sea',
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              items: TransportType.values
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type,style: TextStyle(fontSize: 12,color: Colors.black),)))
                                                  .toList(),
                                              onChanged: (value) => setState(() => _shipmentTransportType = value),
                                              validator: (value) => value == null ? 'Please select a transport type' : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width:fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Shipment Service Type',
                                            child: DropdownButtonFormField<String>(
                                              value: _shipmentServiceType,
                                              decoration: getInputDecoration(
                                                hint: 'Port to Port, Warehouse to Port',
                                              ),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              items: ShipmentServiceType.values
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type,style: TextStyle(fontSize: 12,color: Colors.black),)))
                                                  .toList(),
                                              onChanged: (value) => setState(() => _shipmentServiceType = value),
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
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 12,
                                      runSpacing: 12,
                                      children: [
                                        SizedBox(
                                          width:fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Sender Info',
                                            child: TextFormField(
                                              controller: _senderInfoController,
                                              decoration: getInputDecoration(hint: 'Trading company..'),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
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
                                              decoration: getInputDecoration(hint: 'Trading company..'),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
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
                                              decoration: getInputDecoration(hint: 'Shipping line name..'),
                                              maxLines: 3,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              validator: (value) => value == null || value.isEmpty ? 'Please enter shipping line name' : null,
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
                                              decoration: getInputDecoration(hint: 'Shipment load type'),
                                              items: shipmentLoadTypes
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                                  .toList(),
                                              onChanged: (value) => setState(() => _shipmentLoadType = value),
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
                                              decoration: getInputDecoration(hint: 'Packaging type'),
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w400
                                              ),
                                              items: PackagingType.values
                                                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                                                  .toList(),
                                              onChanged: (value) => setState(() => _packagingType = value),
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
                                              decoration: getInputDecoration(hint: 'Pieces Count'),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
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
                                              decoration: getInputDecoration(hint: 'Gross Weight'),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
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
                                              decoration: getInputDecoration(hint: 'Chargeable Weight'),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
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
                                              decoration: getInputDecoration(hint: '12'),
                                              keyboardType: TextInputType.number,
                                              cursorHeight: 16,
                                              cursorWidth: 2,
                                              // validator: (value) => value == null || value.isEmpty ? 'Please enter CBM' : null,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: fieldWidth,
                                          child: FormInputContainer(
                                            title: 'Dimensions',
                                            child: ShipmentDimensionsField(
                                              onSaved: (value){
                                                dimensions = value??[];
                                              },
                                              validator: (value){
                                                return ShipmentDimensionsField.validateDimensions(value);
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
                                              validator: (value){

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
                                                decoration: getInputDecoration(hint: 'Notes about the shipment'),
                                                maxLines: 3,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
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
                                          width: canvasWidth,
                                          child: FormInputContainer(
                                            title: 'Attachments',
                                            child: AttachmentsArea(),
                                          ),
                                        )
                                      ],
                                    )
                                ),
                                SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: _createShipment,
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.secondary,
                                      foregroundColor: Colors.white,
                                      elevation: 1,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(kCornerRadius)
                                      )
                                  ),
                                  child: Text('Create Shipment'),
                                ),
                                if(snapshot.error != null)
                                  Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.red.shade50,
                                        borderRadius: BorderRadius.circular(kCornerRadius),
                                        border: Border.all(
                                          color: Colors.black
                                        )
                                      ),
                                      padding: EdgeInsets.all(16),
                                      margin: EdgeInsets.symmetric(
                                        vertical: 12
                                      ),
                                      child: Text(
                                        'error with the error in the error but erroring the error need more errors to error the thing out of the error zone!',
                                        // snapshot.error.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600
                                        ),
                                      ),
                                    ),
                                  )
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


  Widget get _progressIndicator {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SpinKitThreeInOut(
          color: AppColors.secondary,
        ),
        const SizedBox(height: 8,),
        Text(
          "Creating Shipment...",
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



