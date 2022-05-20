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
            // print(double.tryParse(value.substring(0)) == null);
            if (double.tryParse(value.substring(0,1)) != null) {
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
            // if (integers.hasMatch(value) == false) {
            //   controller.text = '';
            //   controller.text.trim();
            //   Fluttertoast.showToast(
            //       msg: "You Can't start a name with Integer 223",
            //       toastLength: Toast.LENGTH_SHORT,
            //       gravity: ToastGravity.BOTTOM,
            //       timeInSecForIosWeb: 1,
            //       backgroundColor: Colors.red,
            //       textColor: Colors.white,
            //       fontSize: 16.0);
            // }

            // print("${value.contains(integers)}" "firstone");
            // print("${value.contains(integers, value.length)}"
            //     "wofwofhow??????????hofhwohohwo");
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
