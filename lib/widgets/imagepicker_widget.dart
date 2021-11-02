import 'dart:io';

import 'package:_99ads/providers/cat_provider.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({Key? key}) : super(key: key);

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _image;

  final picker = ImagePicker();
  bool _uploading = false;
  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    Future<String> uploadFile() async {
      File file = File(_image!.path);
      String imageName =
          'productImage/${DateTime.now().microsecondsSinceEpoch}';
      String downloadUrl = "";
      try {
        await FirebaseStorage.instance.ref(imageName).putFile(file);
        downloadUrl =
            await FirebaseStorage.instance.ref(imageName).getDownloadURL();
        if (downloadUrl != "") {
          setState(() {
            _image = null;
            _provider.addurl(downloadUrl);
          });
        }
      } on FirebaseException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.code),
          ),
        );
      }
      return downloadUrl;
    }

    Future getImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        }
      });
    }

    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            elevation: 2,
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color: Colors.black),
            title: const Text(
              "Upload images",
              style: TextStyle(color: Colors.black),
            ),
          ),
          Column(
            children: [
              Stack(
                children: [
                  if (_image != null)
                    Positioned(
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              _image = null;
                            });
                          },
                        )),
                  SizedBox(
                    height: 120,
                    width: MediaQuery.of(context).size.width,
                    child: FittedBox(
                      child: _image == null
                          ? const Icon(
                              CupertinoIcons.photo_on_rectangle,
                              color: Colors.grey,
                            )
                          : Image.file(_image!),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.green, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                setState(() {
                                  _uploading = true;
                                  uploadFile().then((url) {
                                    if (url.isNotEmpty) {
                                      _uploading = false;
                                    }
                                  });
                                });
                              },
                              child: const Text("Save"))),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red, // background
                                onPrimary: Colors.white, // foreground
                              ),
                              onPressed: () {
                                setState(() {
                                  _image = null;
                                });
                              },
                              child: const Text("Cancel"))),
                    ],
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: getImage,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClayContainer(
                          color: Colors.cyan,
                          //curveType: CurveType.concave,
                          spread: 0,
                          borderRadius: 20,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Center(
                              child: ClayText(
                                "Upload Images",
                                size: 20,
                                spread: 0,
                                textColor: Colors.white,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              if (_uploading)
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                )
            ],
          ),
          if (_provider.urlList.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5)),
                child: GalleryImage(
                  imageUrls: _provider.urlList,
                ),
              ),
            ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
