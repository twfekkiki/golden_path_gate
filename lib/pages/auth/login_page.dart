import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_path_gate_admin_portal/constants.dart';
import 'package:golden_path_gate_admin_portal/pages/MainAppWrapper.dart';
import 'package:golden_path_gate_admin_portal/pages/auth/login_provider.dart';
import 'package:golden_path_gate_admin_portal/pages/create_shipment/create_shipment.dart';
import 'package:golden_path_gate_admin_portal/pages/widgets/appErrorWidget.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final LoginProvider loginProvider = LoginProvider();

  void _login() async {
    // Navigator.of(context).push(MaterialPageRoute(builder: (context){
    //   return MainAppWrapper();
    // }));
    // context.go('/create-shipment');
    // return;
    if (_formKey.currentState!.validate()) {
      loginProvider.userNameAndPasswordLogin(_usernameController.text.trim(), _passwordController.text);
    }
  }


  _navigateToHomePage(){
    if(loginProvider.done){
      context.go('/create-shipment');
    }
  }

  @override
  void initState() {
    loginProvider.addListener(_navigateToHomePage);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginProvider>.value(
      value: loginProvider,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: Consumer<LoginProvider>(
          builder: (context,state,child) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      AppColors.primary,AppColors.secondary
                    ]
                )
              ),
              child: LayoutBuilder(
                builder: (context,constrains) {
                  double canvasWidth = 500;
                  if(canvasWidth > constrains.maxWidth){
                    canvasWidth = constrains.maxWidth;
                  }
                  return Center(
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ClipOval(
                                child: Image.asset(
                                    "assets/icons/icon1.jpg",
                                  width: 300,
                                  height: 300,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              TextFormField(
                                controller: _usernameController,
                                decoration: getInputDecoration(label: 'Username'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Please enter your username'
                                    : null,
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible = !_isPasswordVisible;
                                      });
                                    },
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
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Please enter your password'
                                    : null,

                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: (){
                                  if(state.loading || state.done) {
                                    return;
                                  }
                                  _login();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(kCornerRadius)
                                  )
                                ),
                                child: state.loading ? Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                ) : Text('Login'),
                              ),
                              const SizedBox(height: 12,),
                              if(state.error != null)
                                ErrorAppWidget(error: state.error)
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }

  InputDecoration getInputDecoration({String? label}) {
    return InputDecoration(
      label: Text(label??''),
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
  
  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    loginProvider.removeListener(_navigateToHomePage);
    super.dispose();
  }
}
