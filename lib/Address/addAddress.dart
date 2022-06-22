import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
import 'package:e_shop/Models/address.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddAddress extends StatefulWidget {
  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final formKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final cName = TextEditingController();

  final cPhoneNumber = TextEditingController();

  final cFlatHomeNumber = TextEditingController();

  final cCity = TextEditingController();

  final cState = TextEditingController();

  final cPinCode = TextEditingController();

  String phone = '';
  @override
  void dispose() {
    cName.dispose();
    cPhoneNumber.dispose();
    cFlatHomeNumber.dispose();
    cCity.dispose();
    cState.dispose();
    cPinCode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: MyAppBar(),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (formKey.currentState.validate()) {
              final model = AddressModel(
                name: cName.text.trim(),
                state: cState.text.trim(),
                pincode: cPinCode.text,
                phoneNumber: cPhoneNumber.text,
                flatNumber: cFlatHomeNumber.text,
                city: cCity.text.trim(),
              ).toJson();

              // add to firestore
              EcommerceApp.firestore
                  .collection(EcommerceApp.collectionUser)
                  .doc(EcommerceApp.sharedPreferences
                      .getString(EcommerceApp.userUID))
                  .collection(EcommerceApp.subCollectionAddress)
                  .doc(DateTime.now().millisecondsSinceEpoch.toString())
                  .set(model)
                  .then((value) {
                final snack = SnackBar(
                  content: Text("New Address Added Successfully"),
                );
                // ignore: deprecated_member_use
                scaffoldKey.currentState.showSnackBar(snack);
                FocusScope.of(context).requestFocus(FocusNode());
                formKey.currentState.reset();
              });

              Route route = MaterialPageRoute(builder: (c) => StoreHome());
              Navigator.pushReplacement(context, route);
            }
          },
          label: Text("Done"),
          backgroundColor: Colors.red,
          icon: Icon(Icons.check),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Add New Address",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0),
                  ),
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    MyTextField(
                      hint: "Name",
                      controller: cName,
                      isName: true,
                      isObsecure: false,
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(6.0, 2.0, 6.0, 0.0),
                      child: TextFormField(
                        controller: cPhoneNumber,
                        decoration: InputDecoration(
                          labelText: 'Enter Number',
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.blue, width: 5.0),
                          ),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: validatePhone,
                        onSaved: (String val) {
                          phone = val;
                        },
                      ),
                    ),
                    MyTextField(
                      hint: "Flat Number / House Number",
                      controller: cFlatHomeNumber,
                    ),
                    MyTextField(
                      hint: "City",
                      controller: cCity,
                      isName: true,
                      isObsecure: false,
                    ),
                    MyTextField(
                      hint: "State / Country",
                      isName: true,
                      isObsecure: false,
                      controller: cState,
                    ),
                    // MyTextField(
                    //   hint: "Pin Code",
                    //   controller: cPinCode,
                    // ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String validatePhone(String value) {
    if (value.length != 11)
      return 'Mobile Number must be of 11 digit';
    else
      return null;
  }
}

class MyTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final bool isName;
  final bool isObsecure;

  MyTextField({
    Key key,
    this.hint,
    this.controller,
    this.isName = false,
    this.isObsecure,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 5.0),
          ),
          hintText: hint,
        ),
        validator: (val) {
          return val.isEmpty ? "Field can not be empty" : null;
        },
        keyboardType: isName ? TextInputType.name : TextInputType.text,
        onChanged: (value) {
          var integers = RegExp(r"[^0-9]");
          if (isName == true) {
            // print(double.tryParse(value.substring(0)) == null);
            if (double.tryParse(value.substring(0, 1)) != null) {
              controller.text = '';
              controller.text.trim();
              Fluttertoast.showToast(
                  msg: "You Can't start a name with Integer",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            if (value.contains(integers, value.length - 1) == false) {
              // controller.text = '';
              controller.text.trim();
              // print(value.length);
              // value.replaceAll(integers, '');
              String val = value.substring(0, value.length - 1);

              // print("$val  " 'what is text');
              controller.text = val;
              // controller.value = TextEditingValue(text: val);
              controller.selection = TextSelection.fromPosition(
                  TextPosition(offset: controller.text.length));
              Fluttertoast.showToast(
                  msg: "No number allowed",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
//
      ),
    );
  }
}
