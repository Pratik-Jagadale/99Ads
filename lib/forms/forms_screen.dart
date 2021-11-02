import 'package:_99ads/forms/form_class.dart';
import 'package:_99ads/forms/user_review_screen.dart';
import 'package:_99ads/providers/cat_provider.dart';
import 'package:_99ads/services/firebase_service.dart';
import 'package:_99ads/widgets/imagepicker_widget.dart';
import 'package:clay_containers/widgets/clay_container.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:provider/provider.dart';

class FormsScreen extends StatefulWidget {
  static const String id = "form-screen";
  const FormsScreen({Key? key}) : super(key: key);

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseService _service = FirebaseService();

  final _brandController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  final _typeController = TextEditingController();
  final _conststatusController = TextEditingController();
  final _furnstatusController = TextEditingController();
  final FormClass _formClass = FormClass();
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    validate(CategoryProvider provider) {
      if (_formKey.currentState!.validate()) {
        //data add to real time database
        //
        if (provider.urlList.isNotEmpty) {
          provider.datatoDatabse.addAll({
            'category': provider.selectedCategory,
            'subcategory': provider.selectedSubCategory,
            if (provider.selectedSubCategory == 'Accessories' ||
                provider.selectedSubCategory == 'Tablets' ||
                provider.selectedSubCategory == 'Rent:House &Building' ||
                provider.selectedSubCategory == 'Sell:House &Building')
              'type': _typeController.text,
            if (_provider.selectedSubCategory == 'Mobile Phone' ||
                _provider.selectedSubCategory == 'Laptop')
              'brand': _brandController.text,
            if (_provider.selectedCategory == 'Properties')
              'status': _conststatusController.text,
            'price': _priceController.text,
            'title': _titleController.text,
            'description': _descController.text,
            'sellerUid': _service.user!.uid,
            'images': provider.urlList,
            'postedat': DateTime.now(),
            'favourites':[]
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

    showFormDialog(list, _brandController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int i) {
                          return ListTile(
                            onTap: () {
                              _brandController.text = list[i];

                              Navigator.pop(context);
                            },
                            title: Text(
                              list[i],
                            ),
                          );
                        }), //ListView.builder
                  ), //Expanded
                ],
              ), //Column
            ); //Dialog
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  '${_provider.selectedCategory} > ${_provider.selectedSubCategory}'),

              if (_provider.selectedSubCategory == 'Mobile Phone' ||
                  _provider.selectedSubCategory == 'Laptop')
                InkWell(
                  onTap: () {
                    showFormDialog(_provider.doc?['brands'], _brandController);
                  },
                  child: TextFormField(
                    controller: _brandController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Brands*',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField
              if (_provider.selectedSubCategory == 'Accessories')
                InkWell(
                  onTap: () {
                    showFormDialog(_formClass.accessories, _typeController);
                  },
                  child: TextFormField(
                    controller: _typeController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Types',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField
              if (_provider.selectedSubCategory == 'Tablets')
                InkWell(
                  onTap: () {
                    showFormDialog(_formClass.tabType, _typeController);
                  },
                  child: TextFormField(
                    controller: _typeController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Types',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField

              if (_provider.selectedCategory == 'Properties')
                InkWell(
                  onTap: () {
                    showFormDialog(
                        _formClass.consStatus, _conststatusController);
                  },
                  child: TextFormField(
                    controller: _conststatusController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField

              if (_provider.selectedCategory == 'Furniture')
                InkWell(
                  onTap: () {
                    showFormDialog(
                        _formClass.furnishing, _furnstatusController);
                  },
                  child: TextFormField(
                    controller: _furnstatusController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField

              if (_provider.selectedSubCategory == 'Rent:House &Building' ||
                  _provider.selectedSubCategory == 'Sell:House &Building')
                InkWell(
                  onTap: () {
                    showFormDialog(_formClass.apartmentType, _typeController);
                  },
                  child: TextFormField(
                    controller: _typeController,
                    enabled: false,
                    decoration: const InputDecoration(
                      labelText: 'Types',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    }, //InputDecoration
                  ),
                ), //TextFormField

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _titleController,
                      keyboardType: TextInputType.text,
                      // autofocus: true,
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
                  ],
                ),
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
                  child: _provider.urlList.isEmpty
                      ? const Text("No image selected ")
                      : GalleryImage(
                          imageUrls: _provider.urlList,
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
                      child: Text(_provider.urlList.isEmpty
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
                  validate(_provider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
