import 'package:cloud_firestore/cloud_firestore.dart';

class Customer {
  String uid;
  final String userName;
  final String firstName;
  final String lastName;
  final String? companyName;
  final String phone;
  final String? email;
  final String password;

  Customer({
    required this.uid,
    required this.firstName,
    required this.lastName,
    this.companyName,
    required this.phone,
    this.email,
    required this.userName,
    required this.password
  });


  factory Customer.fromDoc(DocumentSnapshot doc){
    final data = doc.data() as Map<String,dynamic>;
    return Customer(
        uid: doc.id,
        firstName: data['firstName'],
        lastName: data['lastName'],
        companyName: data['companyName'],
        phone: data['phone'],
        email: data['email'],
        userName: data['userName'],
        password: data['password']??""
    );
  }

  get toMap => {
    'uid':uid,
    "firstName": firstName,
    "lastName": lastName,
    "phone": phone,
    if(email != null)
      "email": email,
    "userName": userName,
    if(email != null)
      "companyName": companyName,
    "password":password
  };


  get fullName {
    return "$firstName $lastName";
  }
}