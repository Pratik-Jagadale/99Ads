import 'dart:async';

import 'package:_99ads/screens/location_screen.dart';
import 'package:_99ads/screens/login_screen.dart';
import 'package:_99ads/screens/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

// ignore: must_be_immutable
class SplashScreen extends StatefulWidget {
  static const String id = "Splash-screen";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const colorizeColors = [
    Colors.white,
    Colors.cyan,
  ];

  static const colorizeTextStyle = TextStyle(
    fontSize: 30.0,
  );

  @override
  void initState() {
    Timer(const Duration(seconds: 3), () {
      FirebaseAuth.instance.authStateChanges().listen((User? user) {
        if (user == null) {
          // ignore: void_checks
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get()
              .then((DocumentSnapshot documentSnapshot) {
            Map<String, dynamic> data =
                documentSnapshot.data() as Map<String, dynamic>;
            if (data['address'] == null) {
              Navigator.pushReplacementNamed(context, Location_screen.id);
            } else {
              Navigator.pushReplacementNamed(context, MainScreen.id);
            }
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              color: Colors.white,
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 10,
            ),
            AnimatedTextKit(
              isRepeatingAnimation: false,
              totalRepeatCount: 0,
              animatedTexts: [
                ColorizeAnimatedText(
                  '99Adds',
                  textStyle: colorizeTextStyle,
                  colors: colorizeColors,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
