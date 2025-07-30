import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/localization/AppLocal.dart';
import 'package:golden_path_gate_admin_portal/models/user.dart';
import 'package:golden_path_gate_admin_portal/pages/users/create_user/create_user_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormInputContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/FormWidgetContainer.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appErrorWidget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class CreateUserPage extends StatefulWidget {
  const CreateUserPage({super.key});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {

  final CreateUserProvider _createUserProvider = CreateUserProvider();
  final _formKey = GlobalKey<FormState>();
  // Controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  PortalUserRole? _role;


  void _createUser() async {
    if (_formKey.currentState!.validate()) {
      // return;
      var result = await _createUserProvider.createUser(
          _usernameController.text.trim(),
          _passwordController.text,
          _role!
      );

      if(result != null){
        Navigator.of(context).pop(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CreateUserProvider>.value(
      value: _createUserProvider,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<CreateUserProvider>(
            builder: (context,snapshot,child) {
              return LayoutBuilder(
                  builder: (context,constrains) {
                    double canvasWidth = 700;
                    if(canvasWidth > constrains.maxWidth){
                      canvasWidth = constrains.maxWidth;
                    }
                    double fieldWidth = ((canvasWidth - (16 + 16 + 36 + 2)) / 2)  ;
                    if(canvasWidth < 600){
                      // canvasWidth = 600;
                      fieldWidth = canvasWidth - 44;
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
                                                  validator: (value) => value == null || value.isEmpty ? AppLocalizations.of(context).trans("pleaseEnterThePassword") : null,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:fieldWidth,
                                              child: FormInputContainer(
                                                title: AppLocalizations.of(context).trans("role"),
                                                child: DropdownButtonFormField(
                                                  decoration: getInputDecoration(
                                                    hint: AppLocalizations.of(context).trans("role"),
                                                  ),
                                                  validator: (value) => value == null ? AppLocalizations.of(context).trans("pleaseEnterTheRole") : null,
                                                  items: PortalUserRole.values.map(
                                                          (e) => DropdownMenuItem(
                                                              value: e,
                                                              child: Text(AppLocalizations.of(context).trans(e.name))
                                                          )
                                                  ).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _role = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _createUser,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.secondary,
                                          foregroundColor: Colors.white,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(kCornerRadius)
                                          )
                                      ),
                                      child: Text(AppLocalizations.of(context).trans("createUser")),
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
          AppLocalizations.of(context).trans("creatingUser"),
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.secondary,
              fontSize: 30
          ),
        )
      ],
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
