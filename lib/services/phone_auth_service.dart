import 'package:_99ads/screens/autentication/otp_screen.dart';
import 'package:_99ads/screens/location_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(BuildContext context, User user) async {
    final QuerySnapshot result =
        await users.where('uid', isEqualTo: user.uid).get();
    List<DocumentSnapshot> document = result.docs;

    if (document.isEmpty) {
      return users.doc(user.uid).set({
        'uid': user.uid, // John Doe
        'mobile': user.phoneNumber, // Stokes and Sons
        'email': user.email, // 42
        'name': null,
        'address':null
      }).then((value) {
        Navigator.pushReplacementNamed(context, Location_screen.id);
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add user: $error"),
          ),
        );
      });
    }
    Navigator.pushReplacementNamed(context, Location_screen.id);
  }

  Future<void> verifyPhoneNumber(BuildContext context, String number) async {
    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("The provided phone number is not valid."),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The errors is ${e.code}"),
          ),
        );
      }
    };

    // ignore: prefer_function_declarations_over_variables
    final PhoneCodeSent codeSent =
        (String verificationId, int? resendToken) async {
      //to remove dialog box
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPScreen(number, verificationId),
        ),
      );
    };

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
