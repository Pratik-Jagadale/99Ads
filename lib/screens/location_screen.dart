import '/services/firebase_service.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart' as loc;
import 'package:location/location.dart';
import 'package:csc_picker/csc_picker.dart';

// ignore: camel_case_types
class Location_screen extends StatefulWidget {
  static const String id = 'location-screen';

  const Location_screen({Key? key}) : super(key: key);

  @override
  State<Location_screen> createState() => _Location_screenState();
}

// ignore: camel_case_types
class _Location_screenState extends State<Location_screen> {
  // ignore: prefer_final_fields
  FirebaseService _service = FirebaseService();
  Location location = Location();
  bool _loading = false;
  String _countryValue = "";
  String _stateValue = "";
  String _cityValue = "";
  String _currrentAddress = "";
  String _manualAddress = "";
  double _logitude = 0.0;
  double _lattitude = 0.0;
  late bool _serviceEnabled;

  late PermissionStatus _permissionGranted;

  late LocationData _locationData;

  getLocation() async {
    String address = "";
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    List<loc.Placemark> placemarks = await loc.placemarkFromCoordinates(
      _locationData.latitude as double,
      _locationData.longitude as double,
    );

    _logitude = _locationData.longitude as double;
    _lattitude = _locationData.latitude as double;

    address = (placemarks[0].subLocality.toString() +
        " " +
        placemarks[0].locality.toString() +
        "," +
        placemarks[0].administrativeArea.toString() +
        '(' +
        placemarks[0].postalCode.toString() +
        ')' +
        placemarks[0].country.toString());

    _cityValue = placemarks[0].locality.toString();
    _stateValue = placemarks[0].administrativeArea.toString();
    _countryValue = placemarks[0].country.toString();

    return address;
  }

  @override
  Widget build(BuildContext context) {
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
            const Text('Fetching location....')
          ],
        ),
      );
      showDialog(
          context: context,
          builder: (BuildContext dialogcontext) {
            return alert;
          });
    }

    showBottomScreen(BuildContext context) {
      getLocation().then((value) async {
        _currrentAddress = value;
        _manualAddress = _currrentAddress;
        ////////////////////////////////////////////////
        if (_manualAddress != "") {
          Navigator.of(context).pop();
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    const SizedBox(height: 40),
                    AppBar(
                      iconTheme: const IconThemeData(
                        color: Colors.black,
                      ),
                      elevation: 5,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: const [
                          SizedBox(width: 10),
                          Text(
                            'Location',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: TextFormField(
                          decoration: const InputDecoration(
                              hintText: 'Search City ,area or neighbourhood',
                              hintStyle: TextStyle(color: Colors.grey),
                              icon: Icon(Icons.search)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      onTap: () {
                        _service.updateUser({
                          'address': _currrentAddress,
                          'country': _countryValue,
                          'state': _stateValue,
                          'city': _cityValue,
                          'location': {
                            'logitude': _logitude,
                            'lattitude': _lattitude,
                          }
                        }, context);
                      },
                      horizontalTitleGap: 0.0,
                      leading: const Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: InkWell(
                        onTap: () {},
                        child: const Text(
                          'Use current location',
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                      subtitle: Text(
                        _currrentAddress == ""
                            ? "Fetching location"
                            : _currrentAddress,
                        style: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 10, bottom: 4, top: 4),
                        child: Text(
                          'choose city',
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: CSCPicker(
                        showStates: true,
                        showCities: true,
                        countrySearchPlaceholder: _countryValue,
                        stateSearchPlaceholder: _stateValue,
                        citySearchPlaceholder: _cityValue,
                        layout: Layout.vertical,
                        flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,
                        dropdownDecoration:
                            const BoxDecoration(shape: BoxShape.rectangle),
                        defaultCountry: DefaultCountry.India,
                        onCountryChanged: (value) {
                          setState(() {
                            _countryValue = value.toString();
                          });
                        },
                        onStateChanged: (value) {
                          setState(() {
                            _stateValue = value.toString();
                            if (_stateValue.isEmpty) {
                              _stateValue = " ";
                            }
                            // is_city = true;
                          });
                        },
                        onCityChanged: (value) {
                          setState(() {
                            _cityValue = value.toString();
                            if (_cityValue.isEmpty) {
                              _cityValue = " ";
                            }
                            _manualAddress =
                                '$_cityValue,$_stateValue,$_countryValue';
                          });
                        },
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          if (_cityValue == 'null') {
                            //add dialog
                          } else {
                            _service.updateUser({
                              'address': _manualAddress,
                              'country': _countryValue,
                              'state': _stateValue,
                              'city': _cityValue,
                              'location': {
                                'logitude': _logitude,
                                'lattitude': _lattitude,
                              }
                            }, context);
                          }
                        },
                        child: const Text("Use this address"))
                  ],
                );
              });
        }
      });
    }

    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Image.asset(
              'assets/images/map.jpg',
            ),
            //Image.asset('assets/images/location.jpg'),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Where do you want\n to buy/sell products',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'To enjoy all that we have to offer you\n we need to know where to look them',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
              child: Row(children: [
                Expanded(
                  child: _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                        )
                      : ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor)),
                          icon: const Icon(CupertinoIcons.location),
                          label: const Padding(
                            padding: EdgeInsets.only(top: 15, bottom: 15),
                            child: Text(
                              "Around me",
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              _loading = true;
                            });

                            getLocation().then((value) {
                              if (value != null) {
                                _service.updateUser({
                                  "address": value,
                                  'country': _countryValue,
                                  'state': _stateValue,
                                  'city': _cityValue,
                                  'location': {
                                    'logitude': _logitude,
                                    'lattitude': _lattitude,
                                  }
                                }, context);
                              }
                            });
                          },
                        ),
                ),
              ]),
            ),

            InkWell(
              onTap: () {
                showAlertDialog(context);

                showBottomScreen(context);
              },
              child: const Text(
                "Set location manually",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                ),
              ),
            )
          ],
        ));
  }
}
