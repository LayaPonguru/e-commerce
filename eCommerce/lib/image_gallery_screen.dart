import 'dart:convert';
import 'dart:io';

import 'package:ecommerce/constant_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  String albumName = 'Media';
  String path = '';

  var imagePathList = [];

  @override
  void initState() {

    getImageList();

    super.initState();
  }

  // To load already stored images
  void getImageList() async {
    final prefs = await SharedPreferences.getInstance();

    if(prefs.getString("IMAGE_GALLERY") != null){
      setState(() {
        imagePathList =  jsonDecode(prefs.getString("IMAGE_GALLERY") ?? '[]');
        //print('imagePathList $imagePathList');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: primaryBlue,
          systemOverlayStyle:
              const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          title: Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  // To open camera
                  _takePhoto();
                },
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                ))
          ],
        ),
        body: (imagePathList.isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: GridView.builder(
                  itemCount: imagePathList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 0.0,
                      mainAxisSpacing: 0.0,
                      childAspectRatio: 1),
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: Image.file(
                            File(imagePathList[index]["imgPath"]),
                            fit: BoxFit.cover,
                          ),
                        ));
                  },
                ))
            : Align(
          alignment: Alignment.center,
              child: GestureDetector(
                onTap: () {
                  _takePhoto();
                },
                child: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                    size: 100,
                  ),
                ),
              ),
            )

        /*Center(
        child: path == "" ? const SizedBox() : Image.file(File(path)),
      ),*/
        );
  }

  void _takePhoto() async {

    final prefs = await SharedPreferences.getInstance();

    // To take photo
    ImagePicker()
        .getImage(source: ImageSource.camera)
        .then((PickedFile? recordedImage) {
      if (recordedImage != null && recordedImage.path != null) {
        //print("Path *********** ${recordedImage.path}");
        setState(() {
          path = recordedImage.path.toString();
          displaySnackBar("Saving in progress...", "f");

          imagePathList.add({"imgPath": path});

          //print("imagePathList***********$imagePathList");

          // To store the image path to sharedpreference
          prefs.setString("IMAGE_GALLERY", jsonEncode(imagePathList).toString());

        });

        // save image to phone's local storage
        GallerySaver.saveImage(recordedImage.path, albumName: albumName)
            .then((bool? success) {
          setState(() {
            displaySnackBar("Image saved!", "t");
          });
        });
      }
    });
  }

  displaySnackBar(String msg, String t_f) {
    SnackBar snackBar = SnackBar(
      duration: const Duration(seconds: 2),
      backgroundColor: t_f == 'f' ? primaryRed : primaryGreen,
      content: Text(
        msg,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
          fontSize: 14,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
