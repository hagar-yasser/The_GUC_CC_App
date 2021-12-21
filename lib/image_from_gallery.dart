import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class ImageFromGallery extends StatefulWidget {
  @override
  ImageFromGalleryState createState() => ImageFromGalleryState();
}

class ImageFromGalleryState extends State<ImageFromGallery> {
  var _image;
  var imagePicker;

  

  ImageFromGalleryState();

  @override
  void initState() {
    super.initState();
    imagePicker = new ImagePicker();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topLeft,
      padding: EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () async {
          var source = ImageSource.gallery;
          XFile image = await imagePicker.pickImage(
              source: source,
              imageQuality: 50,
              preferredCameraDevice: CameraDevice.front);

          final String path = (await getApplicationDocumentsDirectory()).path;    
          setState(() {
            _image = File(image.path);
          });
        },
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(color: Colors.grey[300]),
          child: _image != null
              ? Image.file(
                  _image,
                  width: 150.0,
                  height: 150.0,
                  fit: BoxFit.fitHeight,
                )
              : Container(
                  decoration: BoxDecoration(color: Colors.grey[300]),
                  width: 150,
                  height: 150,
                  child: Icon(
                    Icons.camera_alt,
                    color: Colors.grey[800],
                  ),
                ),
        ),
      ),
    );
  }
}
