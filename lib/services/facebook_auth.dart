import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FasebookAuthentication {
  static SnackBar customSnackBar({required String content}) {
    return SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        content,
        style: const TextStyle(
          color: Colors.redAccent,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  static Future<User> signInWithFacebook(
      {required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    late User user;
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    if (loginResult.status == LoginStatus.success) {
    } else {
      customSnackBar(content: "${loginResult.status}+${loginResult.message}");
    }
    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    //return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

    try {
      final UserCredential userCredential =
          await auth.signInWithCredential(facebookAuthCredential);

      user = userCredential.user!;
      return user;
    } on FirebaseAuthException catch (e) {
      if (e.code == "account-exists-with-different-credential") {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'Error signing out.Try again'),
        );
      } else if (e.code == 'invalid-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
          customSnackBar(content: 'invalid-credential'),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(content: 'Login Failed'),
      );
    }
    return user;
  }
}
