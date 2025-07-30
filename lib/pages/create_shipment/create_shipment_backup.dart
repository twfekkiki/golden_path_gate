/*
backup(){
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
                              title: AppLocalizations.of(context).trans("shipmentNumber"),
                              child: TextFormField(
                                controller: _shipmentNumberController,
                                cursorHeight: 16,
                                cursorWidth: 2,
                                decoration: getInputDecoration(
                                  hint: '#123000555',
                                ),
                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("shipmentNumberValidation") : null,
                              ),
                            ),
                          ),
                          SizedBox(
                            width:fieldWidth,
                            child: FormInputContainer(
                              title: AppLocalizations.of(context).trans("customer"),
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
                                  hint: AppLocalizations.of(context).trans("clickToSelect"),
                                ),
                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseSelectCustomer") : null,
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
}*/
