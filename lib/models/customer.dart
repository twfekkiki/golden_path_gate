

import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String uid;
  final String userName;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  Customer({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.userName,
    required this.password
  });


  factory Customer.fromDoc(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;
    return Customer(
        uid: doc.id,
        firstName: data['firstName'],
        lastName: data['lastName'],
        phone: data['phone'],
        email: data['email'],
        userName: data['userName'],
        password: ''
    );
  }

  get toMap => {
    'uid':uid,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    "email": email,
    "userName": userName,
  };


  get fullName {
    return "$firstName $lastName";
  }
}