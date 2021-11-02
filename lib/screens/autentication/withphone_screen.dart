import 'package:_99ads/services/phone_auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone-authscreen';

  const PhoneAuthScreen({Key? key}) : super(key: key);

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool validate1 = false;
  bool validate2 = false;
  var countryCode = TextEditingController();
  var phonenumber = TextEditingController();

  late BuildContext dialogcontext;
  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.cyan.shade900),
          ),
          const SizedBox(
            width: 8,
          ),
          const Text('please wait')
        ],
      ),
    );
    showDialog(
        context: context,
        builder: (BuildContext dialogcontext) {
          return alert;
        });
  }

  final PhoneAuthService _service = PhoneAuthService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Padding(
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
              const Text(
                'Enter your Phone',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "we will send you varification code to your phone",
                style: TextStyle(color: Colors.grey),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        setState(() {
                          if (value.length == 3) {
                            validate1 = true;
                          } else {
                            validate1 = false;
                          }
                        });
                      },
                      maxLength: 3,
                      controller: countryCode,
                      decoration: const InputDecoration(labelText: 'Country'),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: phonenumber,
                      onChanged: (value) {
                        setState(() {
                          if (value.length == 10) {
                            validate2 = true;
                          } else {
                            validate2 = false;
                          }
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Number',
                        hintText: 'Enter your phone number',
                        hintStyle: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AbsorbPointer(
              absorbing: (validate1 && validate2) ? false : true,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: (validate1 && validate2)
                        ? MaterialStateProperty.all(
                            Theme.of(context).primaryColor)
                        : MaterialStateProperty.all(Colors.grey)),
                onPressed: () {
                  String number = '${countryCode.text}${phonenumber.text}';
                  showAlertDialog(context);
                  _service.verifyPhoneNumber(context, number);
                },
                child: const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
