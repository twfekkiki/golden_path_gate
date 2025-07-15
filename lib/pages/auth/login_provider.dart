import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  bool loading = false;
  bool done = false;
  dynamic error;

  reset(){
    done = false;
    loading = false;
  }

  userNameAndPasswordLogin(String username , String password) async {
    try{
      loading = true;
      error = null;
      notifyListeners();
      var result = await _firebaseAuth
          .signInWithEmailAndPassword(
          email: "$username@goldenpathgate-iq.com",
          password: password
      );
      print(result.user);
      print(result.additionalUserInfo);
      print(result.credential?.accessToken??"");
      loading = false;
      done = true;
      notifyListeners();
    } catch (error){
      loading = false;
      this.error = error;
      notifyListeners();
      print(error);
      print(error.runtimeType);
    }



  }

}