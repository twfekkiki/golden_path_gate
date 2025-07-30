import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/payment.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/shipment_details_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/shipment_details/widget/payment/payment_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/theme.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class PaymentDetailsWidget extends StatefulWidget {
  final String uid;
  final ShipmentPayment? payment;
  const PaymentDetailsWidget({super.key, required this.uid, required this.payment});

  @override
  State<PaymentDetailsWidget> createState() => _PaymentDetailsWidgetState();
}

class _PaymentDetailsWidgetState extends State<PaymentDetailsWidget> {

  bool _isPayed = false;
  DateTime? _selectedDate;
  late TextEditingController _shipmentNoteController;

  bool _isChanged = false;

  late ShipmentPaymentProvider shipmentPaymentProvider;

  @override
  void initState() {
    shipmentPaymentProvider = ShipmentPaymentProvider(widget.uid);
    _isPayed = widget.payment?.isPayed ?? false;
    _selectedDate = widget.payment?.paymentDate ;
    _shipmentNoteController = TextEditingController(
      text: widget.payment?.note??""
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat("d-MMM-y");

    return ChangeNotifierProvider.value(
      value: shipmentPaymentProvider,
      child: Consumer<ShipmentPaymentProvider>(
        builder: (BuildContext context, ShipmentPaymentProvider value, Widget? child) {
          return SizedBox(
            height: value.loading ? 260 : null,
            child: ModalProgressHUD(
              inAsyncCall: value.loading,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () async {
                                DateTime? value = await showDatePicker(
                                    context: context,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(Duration(days: 500))
                                );
                                if(value != null) {
                                  _selectedDate = value;
                                  _checkChanges();
                                }

                              },
                              child: FormInputContainer(
                                  title: AppLocalizations.of(context).trans("paymentDate"),
                                  child: FormWidgetContainer(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12
                                        ),
                                        child: Text(
                                          _selectedDate == null ? AppLocalizations.of(context).trans("clickToSelect") :  dateFormatter.format(_selectedDate!),
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 12
                                          ),
                                        ),
                                      )
                                  )
                              ),
                            ),
                            const SizedBox(width: 8,),
                            FormInputContainer(
                                title: AppLocalizations.of(context).trans("paymentDone"),
                                child: Switch.adaptive(
                                    value: _isPayed,
                                    onChanged: (value){
                                      _isPayed = value;
                                      _checkChanges();
                                    }
                                )
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: _isChanged ? () async {
                            ShipmentsDetailsProvider shipmentsDetailsProvider = Provider.of<ShipmentsDetailsProvider>(context,listen: false);
                            if(value.loading){
                              return;
                            }
                            await shipmentPaymentProvider.updatePayment(
                                ShipmentPayment(
                                  paymentDate: _selectedDate,
                                  isPayed: _isPayed,
                                  note: _shipmentNoteController.text
                                )
                            );
                            if(shipmentPaymentProvider.done){
                              await shipmentsDetailsProvider.getShipmentsDetails();
                              shipmentPaymentProvider.reset();
                              _checkChanges();
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
                          child: value.loading ?
                              Center(
                                child: SpinKitThreeBounce(
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ):
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
                  FormInputContainer(
                    title: AppLocalizations.of(context).trans("paymentNote"),
                    child: TextFormField(
                      controller: _shipmentNoteController,
                      decoration: AppTheme.getInputDecoration(context,hint: AppLocalizations.of(context).trans("paymentNote")),
                      maxLines: 3,
                      cursorHeight: 16,
                      cursorWidth: 2,
                      onChanged: (val){
                        _checkChanges();
                      },
                      // validator: (value) => value == null || value.isEmpty ? 'Please enter shipping line name' : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  _checkChanges(){
    _isChanged =
        (_isPayed != (widget.payment?.isPayed??false)) ||
            (_selectedDate != widget.payment?.paymentDate ) ||
            (_shipmentNoteController.text != widget.payment?.note)
    ;
    setState(() {

    });
  }

  @override
  void dispose() {
    _shipmentNoteController.dispose();
    super.dispose();
  }
}
