import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:golden_path_gate_admin_portal/models/customer.dart';

class CreateCustomerProvider extends ChangeNotifier {

  final firebaseAuth = FirebaseAuth.instance;
  final _customersCollection = FirebaseFirestore.instance.collection("customers");

  bool loading = false;
  bool done = false;
  dynamic error;

  Future<String?> createCustomer(Customer customer) async {
    loading = true;
    notifyListeners();

    UserCredential? userCredential;
    try {
      userCredential = await firebaseAuth.createUserWithEmailAndPassword(
          email: "${customer.userName}@goldenpathgate-iq.com",
          password: customer.password
      );

      print("User created: ${userCredential.user?.uid}");
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
        error ='The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
        error = 'The account already exists for that email.';
      } else {
        print("FirebaseAuth error: ${e.message}");
        error = e.message;
      }
      loading = false;
      notifyListeners();
      return null;
    } catch (e) {
      print(e);
      loading = false;
      error = e;
      notifyListeners();
      return null;
    }
    customer.uid = userCredential!.user!.uid;
    await _customersCollection.doc(customer.uid).set(customer.toMap);

    loading = false;
    done = true;
    notifyListeners();
    return customer.uid;
  }
}