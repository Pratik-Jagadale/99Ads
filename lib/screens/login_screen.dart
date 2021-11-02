// ignore_for_file: avoid_print

import '/widgets/auth_ui.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'login-screen';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan.shade900,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 100,
                    ),
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                      width: 100,
                      color: Colors.cyan.shade900,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      '99Adds',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan.shade900),
                    )
                  ],
                ),
              ),
            ),
            const Expanded(child: AuthUi()),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'If yout continue,you are accepting\nTerms and Conditions and Privacy Policy ',
                style: TextStyle(color: Colors.white, fontSize: 8),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ));
  }
}
