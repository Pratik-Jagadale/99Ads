import 'package:_99ads/forms/user_review_screen.dart';
import 'package:galleryimage/galleryimage.dart';

import '/providers/cat_provider.dart';
import '/services/firebase_service.dart';
import '/widgets/imagepicker_widget.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SellerCarForm extends StatefulWidget {
  static const String id = 'Car-Form';

  const SellerCarForm({Key? key}) : super(key: key);

  @override
  State<SellerCarForm> createState() => _SellerCarFormState();
}

class _SellerCarFormState extends State<SellerCarForm> {
  final _formKey = GlobalKey<FormState>();

  final FirebaseService _service = FirebaseService(); /*import class service*/

  final _brandController = TextEditingController();
  final _yearController = TextEditingController();
  final _priceController = TextEditingController();
  final _fuelController = TextEditingController();
  final _transmissionController = TextEditingController();
  final _kmController = TextEditingController();
  final _noOfOwnerController = TextEditingController();
  final _descController = TextEditingController();

  final _titleController = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formKey.currentState!.validate()) {
      //data add to real time database
      //
      if (provider.urlList.isNotEmpty) {
        provider.datatoDatabse.addAll({
          'category': provider.selectedCategory,
          'subcategory': provider.selectedSubCategory,
          'brand': _brandController.text,
          'year': _yearController.text,
          'price': _priceController.text,
          'fuel': _fuelController.text,
          'transmission': _transmissionController.text,
          'kmDrive': _kmController.text,
          'noOfOwners': _noOfOwnerController.text,
          'title': _titleController.text,
          'description': _descController.text,
          'sellerUid': _service.user!.uid,
          'images': provider.urlList,
          'postedat': DateTime.now()
        });

        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Images not uploaded'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('please complete required fields..'),
        ),
      );
    }
  }

  final List<String> _fuelList = ['Diesel', 'Petrol', 'Electric', 'LPG'];

  final List<String> _transmission = [
    'Manually',
    'Automatic',
  ];

  final List<String> _noOfOwner = [
    '1st',
    '2nd',
    '3rd',
    '4th',
    '4th+',
  ];

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldvalue) {
      return AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
        title: Text('$title > $fieldvalue',
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
            )),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // need to use this for somany times , So lets create another appBar
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                  itemCount: _catProvider.doc!['models'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      onTap: () {
                        setState(() {
                          _brandController.text =
                              _catProvider.doc!['models'][index];
                        });
                        Navigator.pop(context);
                      },
                      title: Text(_catProvider.doc!['models'][index]),
                    );
                  }),
            ),
          ],
        ),
      );
    }

    Widget _listview({fieldvalue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldvalue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                }),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        /*explicitely cont added*/
        elevation: 0.0,
        title: const Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    /*explicitely cont added*/
                    'CAR',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      //Lets show list of cars to select insted of manually typing
                      //List from Firebase. need to bring those lists here
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false, //cant enter manually now
                      decoration: const InputDecoration(
                          labelText: 'Brand / Model / Variant'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Year'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: 'Price', prefixText: 'Rs'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),

                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listview(
                                fieldvalue: 'Fuel',
                                list: _fuelList,
                                textController: _fuelController);
                          });
                    },
                    child: TextFormField(
                      autofocus: false,
                      enabled: false,
                      controller: _fuelController, //cant enter manually now
                      decoration: const InputDecoration(labelText: 'Fuel'),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listview(
                                fieldvalue: 'Transsmision',
                                list: _transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      autofocus: false,
                      enabled: false,
                      controller:
                          _transmissionController, //cant enter manually now
                      decoration:
                          const InputDecoration(labelText: 'Transsmision'),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _kmController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'KM Driven*'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listview(
                                fieldvalue: 'No. of Owner',
                                list: _noOfOwner,
                                textController: _noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      autofocus: false,
                      enabled: false,
                      controller:
                          _noOfOwnerController, //cant enter manually now
                      decoration:
                          const InputDecoration(labelText: 'No. of Controller'),

                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        labelText: 'Add title*',
                        counterText:
                            'Mention  the kay features(eg. brand , model)'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descController,
                    keyboardType: TextInputType.text,
                    maxLength: 50,
                    decoration: const InputDecoration(
                        labelText: 'Description',
                        counterText:
                            'Include condition, featuress, rason for selling'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ), //explicitely const added
                  const Divider(
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(5)),
                      child: _catProvider.urlList.isEmpty
                          ? const Text("No image selected ")
                          : GalleryImage(
                              imageUrls: _catProvider.urlList,
                            ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const ImagePickerWidget();
                          });
                    },
                    child: ClayContainer(
                      child: SizedBox(
                        height: 40,
                        child: Center(
                          child: Text(_catProvider.urlList.isEmpty
                              ? "Upload image"
                              : 'Upload image here'),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // background
                  onPrimary: Colors.white, // foreground
                ),
                child: const Padding(
                  padding: EdgeInsets.all(4.0),
                  child: Text(
                    'Next',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  validate(_catProvider);
              
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
