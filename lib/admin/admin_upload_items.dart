import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:store_app/api_connection/api_connection.dart';

class AdminUploadItemsScreen extends StatefulWidget {
  @override
  State<AdminUploadItemsScreen> createState() => _AdminUploadItemsScreenState();
}

class _AdminUploadItemsScreenState extends State<AdminUploadItemsScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? pickedImageXFile;

  var formKey = GlobalKey<FormState>();
  var nameController = TextEditingController();
  var ratingController = TextEditingController();
  var tagsController = TextEditingController();
  var priceController = TextEditingController();
  var sizesController = TextEditingController();
  var colorsController = TextEditingController();
  var descriptionController = TextEditingController();
  var imageLink = "";

//defaultScreen methods
  captureImageWithPhoneCamera() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.camera);

    Get.back();

    setState(() => pickedImageXFile);
  }

  pickImageFromPhoneGallery() async {
    pickedImageXFile = await _picker.pickImage(source: ImageSource.gallery);

    Get.back();
    setState(() => pickedImageXFile);
  }

  showDialogBoxForImagePickingAndCapturing() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Item Image",
              style: TextStyle(
                color: Color(0xff2f3542),
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              SimpleDialogOption(
                onPressed: () {
                  captureImageWithPhoneCamera();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera_alt,
                      color: Color(0xff636e72),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Ambil dengan Kamera HandPhone",
                      style: TextStyle(
                        color: Color(0xff636e72),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  pickImageFromPhoneGallery();
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.image,
                      color: Color(0xff636e72),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    const Text(
                      "Ambil Gambar dari Galeri",
                      style: TextStyle(
                        color: Color(0xff636e72),
                      ),
                    ),
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Get.back();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
//end defaultScreen methods

  Widget defaultScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text("Upload Produk"),
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                image: AssetImage("images/up_produk_icon.png"),
                width: 200,
              ),

              SizedBox(
                height: 50,
              ),

              //button
              Material(
                color: Color(0xff6b83bc),
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
                      "Tambah Produk",
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

  //uploadItemFormScreen methods
  uploadItemImage() async {
    var requestImgurApi = http.MultipartRequest(
        "POST", Uri.parse("https://api.imgur.com/3/image"));

    String imageName = DateTime.now().millisecondsSinceEpoch.toString();
    requestImgurApi.fields['title'] = imageName;
    requestImgurApi.headers['Authorization'] = "Client-ID " + "93482787e16e939";

    var imageFile = await http.MultipartFile.fromPath(
      'image',
      pickedImageXFile!.path,
      filename: imageName,
    );

    requestImgurApi.files.add(imageFile);
    var responseFromImgurApi = await requestImgurApi.send();

    var responseDataFromImgurApi = await responseFromImgurApi.stream.toBytes();
    var resultFromImgurApi = String.fromCharCodes(responseDataFromImgurApi);

    print("Result :: "); //testing
    print(resultFromImgurApi); //testing

    Map<String, dynamic> jsonRes = json.decode(resultFromImgurApi);
    imageLink = (jsonRes["data"]["link"]).toString();
    String deleteHash = (jsonRes["data"]["deletehash"]).toString();

    print("imageLink :: "); //testing
    print(imageLink); //testing

    SaveItemInfoToDatabase();
  }

  SaveItemInfoToDatabase() async {
    List<String> tagsList = tagsController.text.split(',');
    List<String> sizesList = sizesController.text.split(',');
    List<String> colorsList = colorsController.text.split(',');

    try {
      var response = await http.post(
        Uri.parse(API.uploadNewItems),
        body: {
          'item_id': '1',
          'name': nameController.text.trim().toString(),
          'rating': ratingController.text.trim().toString(),
          'tags': tagsList.toString(),
          'price': priceController.text.trim().toString(),
          'sizes': sizesList.toString(),
          'colors': colorsList.toString(),
          'description': descriptionController.text.trim().toString(),
          'image': imageLink.toString(),
        },
      );

      if (response.statusCode == 200) {
        var resBodyOfValidateEmail = jsonDecode(response.body);

        if (resBodyOfValidateEmail['success'] == true) {
          Fluttertoast.showToast(msg: "New item uploaded successfully");

          setState(() {
            pickedImageXFile = null;
            nameController.clear();
            ratingController.clear();
            tagsController.clear();
            priceController.clear();
            sizesController.clear();
            colorsController.clear();
            descriptionController.clear();
          });

          Get.to(AdminUploadItemsScreen());
        } else {
          Fluttertoast.showToast(msg: "Item not uploaded. Error, Try Again");
        }
      } else {
        Fluttertoast.showToast(msg: "Status is not 200");
      }
    } catch (errorMsg) {
      print("Error:: " + errorMsg.toString());
    }
  }

  Widget uploadItemFormScreen() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Upload Form"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            setState(() {
              pickedImageXFile = null;
              nameController.clear();
              ratingController.clear();
              tagsController.clear();
              priceController.clear();
              sizesController.clear();
              colorsController.clear();
              descriptionController.clear();
            });
            Get.to(AdminUploadItemsScreen());
          },
          icon: Icon(
            Icons.clear,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Fluttertoast.showToast(msg: "Uploading now..");

              uploadItemImage();
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          //image
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(
                  File(pickedImageXFile!.path),
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          //upload item
          Padding(
            padding: const EdgeInsets.fromLTRB(1, 8, 8, 1),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                children: [
                  //email-password-login button
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        //title
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Isikan Detail Produk",
                              style: TextStyle(
                                color: Color(0xff2f3542),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //item name
                        TextFormField(
                          controller: nameController,
                          validator: (val) =>
                              val == "" ? "Please write item name" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.title,
                              color: Colors.grey,
                            ),
                            hintText: "nama produk...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item ratings
                        TextFormField(
                          controller: ratingController,
                          validator: (val) =>
                              val == "" ? "Please give item ratings" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.rate_review,
                              color: Colors.grey,
                            ),
                            hintText: "item ratings...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item tags
                        TextFormField(
                          controller: tagsController,
                          validator: (val) =>
                              val == "" ? "Please write item tags" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.tag,
                              color: Colors.grey,
                            ),
                            hintText: "item tags...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item price
                        TextFormField(
                          controller: priceController,
                          validator: (val) =>
                              val == "" ? "Please write item price" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.price_change_outlined,
                              color: Colors.grey,
                            ),
                            hintText: "harga...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item sizes
                        TextFormField(
                          controller: sizesController,
                          validator: (val) =>
                              val == "" ? "Please write item sizes" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.picture_in_picture,
                              color: Colors.grey,
                            ),
                            hintText: "ukuran...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item colors
                        TextFormField(
                          controller: colorsController,
                          validator: (val) =>
                              val == "" ? "Please write item colors" : null,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.color_lens,
                              color: Colors.grey,
                            ),
                            hintText: "warna...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //item description
                        TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 10,
                          controller: descriptionController,
                          validator: (val) => val == ""
                              ? "Please write item description"
                              : null,
                          decoration: InputDecoration(
                            hintText: "deskripsi...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Colors.grey,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            fillColor: Colors.white,
                            filled: true,
                          ),
                        ),

                        const SizedBox(
                          height: 18,
                        ),

                        //button
                        Material(
                          color: Color(0xff6b83bc),
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            onTap: () {
                              if (formKey.currentState!.validate()) {
                                Fluttertoast.showToast(msg: "Uploading now..");
                                uploadItemImage();
                              }
                            },
                            borderRadius: BorderRadius.circular(30),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 120,
                              ),
                              child: Text(
                                "Upload Now",
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

                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return pickedImageXFile == null ? defaultScreen() : uploadItemFormScreen();
  }
}
