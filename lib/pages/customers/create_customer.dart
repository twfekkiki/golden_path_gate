import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appErrorWidget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'create_customer_provider.dart';

class CreateCustomerFormPage extends StatefulWidget {
  const CreateCustomerFormPage({super.key});

  @override
  State<CreateCustomerFormPage> createState() => _CreateCustomerFormPageState();
}

class _CreateCustomerFormPageState extends State<CreateCustomerFormPage> {
  final _formKey = GlobalKey<FormState>();
  final CreateCustomerProvider createCustomerProvider = CreateCustomerProvider();

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  void _createCustomer() async {
    if (_formKey.currentState!.validate()) {
      var result = await createCustomerProvider.createCustomer(
          Customer(
              uid: '',
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              phone: _phoneController.text.trim(),
              email: _emailController.text.trim(),
              userName: _usernameController.text.trim(),
              password: _passwordController.text.trim()
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateCustomerProvider>.value(
      value: createCustomerProvider,
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
                                              title: 'First name',
                                              child: TextFormField(
                                                controller: _firstNameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Ahmad ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the first name' : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: 'Last name',
                                              child: TextFormField(
                                                controller: _lastNameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the last name' : null,
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
                                              title: 'phone number',
                                              child: TextFormField(
                                                controller: _phoneController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: '964750xxxxxxx ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the first name' : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: 'Email',
                                              child: TextFormField(
                                                controller: _emailController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'Salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the last name' : null,
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
                                              title: 'User name',
                                              child: TextFormField(
                                                controller: _usernameController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'ahmad.salem ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the first name' : null,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:fieldWidth,
                                            child: FormInputContainer(
                                              title: 'Password',
                                              child: TextFormField(
                                                controller: _passwordController,
                                                cursorHeight: 16,
                                                cursorWidth: 2,
                                                decoration: getInputDecoration(
                                                  hint: 'strong password ',
                                                ),
                                                validator: (value) => value == null || value.isEmpty ? 'Please enter the last name' : null,
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
                                    child: Text('Create Customer'),
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
          "Creating Customer...",
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



