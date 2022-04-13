import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminShiftOrders.dart';
import 'package:e_shop/Widgets/loadingWidget.dart';
import 'package:e_shop/main.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage>
    with AutomaticKeepAliveClientMixin<UploadPage> {
  bool get wantKeepAlive => true;
  File file;
  TextEditingController _descriptionTextEditingController =
      TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _shortInfoTextEditingController =
      TextEditingController();
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  Future<bool> backToHome() async {
    final shouldPop = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to logout?'),
        actions: <Widget>[
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          // ignore: deprecated_member_use
          FlatButton(
            onPressed: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => SplashScreen())),
            child: Text('Yes'),
          ),
        ],
      ),
    );

    return shouldPop ?? true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return file == null
        ? displayAdminHomeScreen()
        : displayAdminUploadFormScreen();
  }

  displayAdminHomeScreen() {
    return WillPopScope(
      onWillPop: backToHome,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Colors.white,
            ),
            onPressed: () {
              Route route =
                  MaterialPageRoute(builder: (c) => AdminShiftOrders());
              Navigator.pushReplacement(context, route);
            },
          ),
          actions: [
            ElevatedButton(
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (c) => SplashScreen());
                Navigator.pushReplacement(context, route);
              },
            ),
          ],
        ),
        body: getAdminHomeScreenBody(),
      ),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: const BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.redAccent, Colors.blueAccent],
          begin: const FractionalOffset(0.0, 0.0),
          end: const FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shop_two,
              color: Colors.white,
              size: 200.0,
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
              // ignore: deprecated_member_use
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0)),
                  primary: Colors.blueAccent,
                ),
                child: Text(
                  "Add New Items",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
                onPressed: () => takeImage(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
        context: mContext,
        builder: (con) {
          return SimpleDialog(
            title: Text(
              "Item Image",
              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
            ),
            children: [
              SimpleDialogOption(
                child: Text(
                  "Capture with Camera",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text(
                  "Select from Gallery",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: pickPhotoFromGallery,
              ),
              SimpleDialogOption(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().pickImage(
        source: ImageSource.camera, maxHeight: 680.0, maxWidth: 970.0);

    setState(() {
      file = File(imageFile.path);
    });
  }

  pickPhotoFromGallery() async {
    Navigator.pop(context);
    final imageFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    setState(() {
      file = File(imageFile.path);
    });
  }

  String category = 'Men';
  displayAdminUploadFormScreen() {
    return WillPopScope(
      onWillPop: () async {
        Route route = MaterialPageRoute(builder: (context) => UploadPage());
        Navigator.push(context, route);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Colors.redAccent,
                  Colors.blueAccent,
                ],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: clearFormInfo,
          ),
          title: Text(
            "New Product",
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            // ignore: deprecated_member_use
            FlatButton(
              onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
              child: Text(
                "Add",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        body: ListView(
          children: [
            uploading ? circularProgress() : Text(""),
            Container(
              height: 230.0,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Center(
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(file), fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 12.0)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: DropdownButtonFormField(
                  hint: Text(
                    'Select Category',
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  // value: value,
                  items: ['Men', 'Women', 'Child']
                      .map<DropdownMenuItem<String>>((e) =>
                          DropdownMenuItem<String>(
                            child: Text(
                              e,
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            value: e,
                          ))
                      .toList(),
                  onChanged: (String e) {
                    setState(() {
                      category = e.toLowerCase();
                    });
                    print(e);
                  }),
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.red,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _shortInfoTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Short Info",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.red,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _titleTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Title",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.red,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _descriptionTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Description",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.red,
            ),
            ListTile(
              leading: Icon(
                Icons.perm_device_information,
                color: Colors.red,
              ),
              title: Container(
                width: 250.0,
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: _priceTextEditingController,
                  decoration: InputDecoration(
                    hintText: "Price",
                    hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Divider(
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _titleTextEditingController.clear();
    });
  }

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });

    String imageDownloadUrl = await uploadItemImage(file);

    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    final Reference storageReference =
        FirebaseStorage.instance.ref().child("Items");
    UploadTask uploadTask =
        storageReference.child("product_$productId.jpg").putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  saveItemInfo(String downloadUrl) {
    final itemsRef = FirebaseFirestore.instance.collection(category);
    itemsRef.doc(productId).set({
      "shortInfo": _shortInfoTextEditingController.text.trim(),
      "longDescription": _descriptionTextEditingController.text.trim(),
      "price": int.parse(_priceTextEditingController.text),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
      "title": _titleTextEditingController.text.trim(),
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _shortInfoTextEditingController.clear();
      _priceTextEditingController.clear();
    });
  }
}
