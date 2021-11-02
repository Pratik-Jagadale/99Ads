import 'package:_99ads/screens/autentication/withphone_screen.dart';
import 'package:_99ads/screens/main_screen.dart';
import 'package:_99ads/services/facebook_auth.dart';
import 'package:_99ads/services/google_auth.dart';
import 'package:_99ads/services/phone_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class AuthUi extends StatelessWidget {
  const AuthUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220,
            child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthScreen.id);
                },
                child: Row(
                  children: const [
                    Icon(
                      Icons.phone_android_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Continue with Phone',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                )),
          ),
          SignInButton(
            Buttons.Google,
            text: ("Continue with Google"),
            onPressed: () async {
              User user =
                  await GoogleAuthentication.signInWithGoogle(context: context);
              // ignore: unnecessary_null_comparison
              if (user != null) {
                PhoneAuthService _authentication = PhoneAuthService();
                _authentication.addUser(context, user);
              }
            },
          ),
          SignInButton(
            Buttons.Facebook,
            text: ("Continue with Facebook"),
            onPressed: () async {
              User user = await FasebookAuthentication.signInWithFacebook(
                  context: context);
              // ignore: unnecessary_null_comparison
              if (user != null) {
                PhoneAuthService _authentication = PhoneAuthService();
                _authentication.addUser(context, user);
              }
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              "Or",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              //Navigator.pushNamed(context, EmailAuthScreen.id);
              Navigator.pushNamed(context, MainScreen.id);
            },
            child: const Text(
              'as Guest',
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}
