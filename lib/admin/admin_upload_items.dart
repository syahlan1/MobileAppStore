import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';

class AdminUploadItemsScreen extends StatefulWidget {
  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.black,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: const Text(
                  "Capture with Phone Camera",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: const Text(
                  "Pick Image From Phone Gallery",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        });
  }

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xff192a56),
                Color(0xff273c75),
              ],
            ),
          ),
        ),
        title: Text("Admin"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xff40739e),
              Color(0xff273c75),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.add_photo_alternate,
                color: Colors.white54,
                size: 200,
              ),

              //button
              Material(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(30),
                child: InkWell(
                  onTap: () {
                    showDialogBoxForImagePickingAndCapturing();
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 28,
                    ),
                    child: Text(
                      "Add New Item",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return defaultScreen();
  }
}
