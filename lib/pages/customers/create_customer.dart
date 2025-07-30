import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appErrorWidget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'create_customer_provider.dart';

class CreateCustomerFormPage extends StatefulWidget {
  final String? id;
  const CreateCustomerFormPage({super.key, this.id});

  @override
  State<CreateCustomerFormPage> createState() => _CreateCustomerFormPageState();
}

class _CreateCustomerFormPageState extends State<CreateCustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final CreateCustomerProvider createCustomerProvider = CreateCustomerProvider();

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _companyNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;


  @override
  void initState() {
   initControllers();
    super.initState();
  }

  initControllers() async {
    Customer? customer;
    if(widget.id!=null && widget.id!.isNotEmpty){
      customer = await createCustomerProvider.getCustomerDetails(widget.id!);
    }
    _firstNameController = TextEditingController(
        text: customer?.firstName??""
    );
    _lastNameController = TextEditingController(
        text: customer?.lastName??""
    );
    _companyNameController = TextEditingController(
        text: customer?.companyName??""
    );
    _phoneController = TextEditingController(
        text: customer?.phone??""
    );
    _emailController = TextEditingController(
        text: customer?.email??""
    );
    _usernameController = TextEditingController(
        text: customer?.userName??""
    );
    _passwordController = TextEditingController(
        text: customer?.password??""
    );

    WidgetsBinding.instance.addPostFrameCallback((timestamp){
      createCustomerProvider.initiate();
    });
  }

  void _createCustomer() async {
    if (_formKey.currentState!.validate()) {
      var result = await createCustomerProvider.createCustomer(
          Customer(
              uid: widget.id??"",
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              userName: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
              companyName: _companyNameController.text.trim()
          )
      );
      if (result != null){
        context.go('/customer-list');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateCustomerProvider>.value(
      value: createCustomerProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<CreateCustomerProvider>(
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

                  if(!snapshot.initiated){
                    return Center(
                      child: CircularProgressIndicator(),
                    );
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
                                              title: AppLocalizations.of(context).trans("firstName"),
                                              child: TextFormField(
                                                controller: _firstNameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Ahmad ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterTheFirstName") : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: AppLocalizations.of(context).trans("lastName"),
                                              child: TextFormField(
                                                controller: _lastNameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterTheLastname") : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: AppLocalizations.of(context).trans("companyName"),
                                              child: TextFormField(
                                                controller: _companyNameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: AppLocalizations.of(context).trans("companyName"),
                                                ),
                                                // validator: (value) => value == null || value.isEmpty ? 'Please enter the last name' : null,
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
                                              title: AppLocalizations.of(context).trans("phone"),
                                              child: TextFormField(
                                                controller: _phoneController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: '964750xxxxxxx ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterThePhone") : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: AppLocalizations.of(context).trans("email"),
                                              child: TextFormField(
                                                controller: _emailController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterTheEmail"): null,
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
                                              title: AppLocalizations.of(context).trans("username"),
                                              child: TextFormField(
                                                controller: _usernameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'ahmad.salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterTheUsername") : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: AppLocalizations.of(context).trans("password"),
                                              child: TextFormField(
                                                controller: _passwordController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: AppLocalizations.of(context).trans("strongPassword"),
                                                ),
                                                validator: (value) => (widget.id == null) && (value == null || value.isEmpty) ? AppLocalizations.of(context).trans("pleaseEnterThePassword") : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                  ),
                                  SizedBox(height: 20),
                                  ElevatedButton(
                                    onPressed: _createCustomer,
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.secondary,
                                        foregroundColor: Colors.white,
                                        elevation: 1,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(kCornerRadius)
                                        )
                                    ),
                                    child: Text(
                                      widget.id == null || widget.id!.isEmpty?
                                        'Create customer':"Update customer"
                                    ),
                                  ),
                                  if(snapshot.error != null)
                                    ErrorAppWidget(error: snapshot.error,)
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
          "Working...",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 30
          ),
        )
      ],
    );
  }
}



