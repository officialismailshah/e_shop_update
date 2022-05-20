import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final IconData data;
  final String hintText;
  final bool isObsecure;
  final bool isName;
  

  CustomTextField(
      {Key key,
      this.controller,
      this.data,
      this.hintText,
      this.isObsecure,
      this.isName = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      padding: EdgeInsets.all(8.0),
      margin: EdgeInsets.all(10.0),
      child: TextFormField(
        keyboardType: isName ? TextInputType.name : TextInputType.text,
        onChanged: (value) {
          var integers = RegExp(r"[^0-9]");
          if (isName == true) {
            print(integers.hasMatch(value));
            if (integers.hasMatch(value) == false
                // int.parse(value) == 2 ||
                // int.parse(value) == 3 ||
                // int.parse(value) == 4 ||
                // int.parse(value) == 5 ||
                // int.parse(value) == 6 ||
                // int.parse(value) == 7 ||
                // int.parse(value) == 8 ||
                // int.parse(value) == 9
                ) {
              controller.text = '';
              controller.text.trim();
              Fluttertoast.showToast(
                  msg: "Name should start with a letter",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        controller: controller,
        obscureText: isObsecure,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: Theme.of(context).primaryColor,
          ),
          focusColor: Theme.of(context).primaryColor,
          hintText: hintText,
        ),
      ),
    );
  }
}
