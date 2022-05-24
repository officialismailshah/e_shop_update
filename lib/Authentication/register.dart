import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameTextEditingController =
      TextEditingController();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
  final TextEditingController _cPasswordTextEditingController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String userImageUrl = "";
  final ImagePicker imageFile = ImagePicker();
  File imgFile;
  Image imgForWeb;
   bool _showPassword = false;
      

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;
    // _screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 10.0,
            ),
            InkWell(
              onTap:
                  // kIsWeb ? _selectAndPickImageForWeb :
                  _selectAndPickImage,
              child: CircleAvatar(
                radius: _screenWidth * 0.15,
                backgroundColor: Colors.white,
                backgroundImage: imgFile == null
                    ? null
                    : kIsWeb
                        ? Image.network(imgFile.path)
                        : FileImage(imgFile),
                child: imgFile == null
                    ? Icon(
                        Icons.add_photo_alternate,
                        size: _screenWidth * 0.15,
                        color: Colors.grey,
                      )
                    : null,
              ),
            ),
            SizedBox(
              height: 8.0,
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    isName: true,
                    controller: _nameTextEditingController,
                    data: Icons.person,
                    hintText: "Name",
                    isObsecure: false,
                  ),
                  CustomTextField(
                    controller: _emailTextEditingController,
                    data: Icons.email,
                    hintText: "Email",
                    isObsecure: false,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      autofocus: false,
                      controller: _passwordTextEditingController,
                      obscureText: !this._showPassword,
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.done,
                     
                      decoration: InputDecoration(
                        
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => {
                            setState(
                                () => this._showPassword = !this._showPassword)
                          },
                          icon: Icon(_showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.all(10.0),
                    child: TextFormField(
                      autofocus: false,
                      controller: _cPasswordTextEditingController,
                      obscureText: !this._showPassword,
                      cursorColor: Theme.of(context).primaryColor,
                      textInputAction: TextInputAction.done,
                     
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Theme.of(context).primaryColor,
                        ),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          onPressed: () => {
                            setState(
                                () => this._showPassword = !this._showPassword)
                          },
                          icon: Icon(_showPassword
                              ? Icons.visibility
                              : Icons.visibility_off),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                uploadAndSaveImage();
              },
              color: Colors.red,
              child: Text(
                "Sign up",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 15.0,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectAndPickImage() async {
    final file = await imageFile.pickImage(source: ImageSource.gallery);
    setState(() {
      imgFile = File(file.path);
    });
  }

  // Future<void> _selectAndPickImageForWeb() async {
  //   Image file = await ImagePickerWeb.getImage(outputType: ImageType.widget);

  //   if (file != null) {
  //     setState(() {
  //       // file.clear();
  //       // _pickedImages.add(fromPicker);
  //       imgForWeb = file;
  //     });
  //   }
  // }

  Future<void> uploadAndSaveImage() async {
    _passwordTextEditingController.text == _cPasswordTextEditingController.text
        ? _emailTextEditingController.text.isNotEmpty &&
                _passwordTextEditingController.text.isNotEmpty &&
                _cPasswordTextEditingController.text.isNotEmpty &&
                _nameTextEditingController.text.isNotEmpty
            ? uploadToStorage()
            : displayDialog("Please fill up the registration complete form..")
        : displayDialog("Password do not match.");
    // if (imgFile == null) {
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return ErrorAlertDialog(
    //           message: "Please select an image file.",
    //         );
    //       });
    // } else {

    // }
  }

  displayDialog(String msg) {
    showDialog(
        context: context,
        builder: (c) {
          return ErrorAlertDialog(
            message: msg,
          );
        });
  }

  uploadToStorage() async {
    if (imgFile == null) {
      showDialog(
          context: context,
          builder: (c) {
            return LoadingAlertDialog(
              message: "'Registering, Please wait.....'",
            );
          });
      _registerUser();
    } else {
      String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();

      Reference storageReference =
          FirebaseStorage.instance.ref().child(imageFileName);

      UploadTask storageUploadTask = storageReference.putFile(imgFile);

      TaskSnapshot taskSnapshot = await storageUploadTask;

      await taskSnapshot.ref.getDownloadURL().then((urlImage) {
        userImageUrl = urlImage;

        _registerUser();
      });
    }
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void _registerUser() async {
    User firebaseUser;

    await _auth
        .createUserWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((auth) {
      firebaseUser = auth.user;
    }).catchError((error) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (c) {
            return ErrorAlertDialog(
              message: error.message.toString(),
            );
          });
    });

    if (firebaseUser != null) {
      saveUserInfoToFireStore(firebaseUser).then((value) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future saveUserInfoToFireStore(User fUser) async {
    FirebaseFirestore.instance.collection("users").doc(fUser.uid).set({
      "uid": fUser.uid,
      "email": fUser.email,
      "name": _nameTextEditingController.text.trim(),
      "url": userImageUrl,
      EcommerceApp.userCartList: ["garbageValue"],
    });

    await EcommerceApp.sharedPreferences.setString("uid", fUser.uid);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userEmail, fUser.email);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userName, _nameTextEditingController.text);
    await EcommerceApp.sharedPreferences
        .setString(EcommerceApp.userAvatarUrl, userImageUrl);
    await EcommerceApp.sharedPreferences
        .setStringList(EcommerceApp.userCartList, ["garbageValue"]);
  }
}
