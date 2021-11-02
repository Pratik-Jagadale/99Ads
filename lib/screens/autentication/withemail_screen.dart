import 'package:_99ads/services/emailauth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../location_screen.dart';

void message(String msg, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
    ),
  );
}

class EmailAuthScreen extends StatefulWidget {
  static const String id = 'Eamil-auth-screen';
  const EmailAuthScreen({Key? key}) : super(key: key);

  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  final _auth = EmailAuthentication();
  final _formKey = GlobalKey<FormState>();

  bool validate = false;
  bool _login = false;
  bool _loading = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  Future<void> _submit(BuildContext context) async {
    setState(() {
      _loading = true;
    });
    try {
      if (_login) {
        await _auth
            .signin(_emailController.text, _passwordController.text)
            .then((value) {
          Navigator.pushReplacementNamed(context, Location_screen.id);
        });
      } else {
        await _auth.signup(_emailController.text, _passwordController.text);
        setState(() {
          _login = true;
        });
      }
    } catch (error) {
      var errorMessage = "Authentication failed";
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = "This email address is already in use";
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = "This is not a valid email address";
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage =
            "This password is too weak,Password should be at least 6 characters";
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid Password';
      }
      message(errorMessage, context);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          'Login',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.red.shade200,
                child: const Icon(CupertinoIcons.person_alt_circle,
                    color: Colors.red, size: 60),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Enter ${_login ? 'Login' : 'Registration'} Email',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Enter Email and Password to ${_login ? 'Login' : 'Register'}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10),
                  labelText: 'Email',
                  filled: true,
                ),
                controller: _emailController,
                onChanged: (value) {
                  setState(() {
                    final bool isValid =
                        EmailValidator.validate(_emailController.text);
                    if (value.isEmpty) {
                      validate = false;
                    } else if (value.isNotEmpty && isValid == false) {
                      validate = false;
                    } else {
                      validate = true;
                    }
                  });
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.only(left: 10),
                  labelText: 'Password',
                  filled: true,
                  fillColor: Colors.grey.shade300,
                ),
                obscureText: true,
                onChanged: (value) {
                  if (_emailController.text.isNotEmpty) {
                    setState(() {
                      if (value.length > 3) {
                        validate = true;
                      } else {
                        validate = false;
                      }
                    });
                  }
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(_login
                      ? 'New Registration ?'
                      : 'Already has an account?'),
                  TextButton(
                    child: Text(
                      _login ? 'Register' : 'Login',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _login = !_login;
                        _emailController.text = '';
                        _passwordController.text = '';
                      });
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: (validate)
                      ? MaterialStateProperty.all(
                          Theme.of(context).primaryColor)
                      : MaterialStateProperty.all(Colors.grey)),
              onPressed: () async {
                _submit(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: _loading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        _login ? 'Login' : 'Register',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
