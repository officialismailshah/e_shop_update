// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:e_shop/Orders/myOrders.dart';
//  import 'package:fluttertoast/fluttertoast.dart';

import '../Config/config.dart';

String getOrderId = "";

class FeedbackScreen extends StatefulWidget {
  final String orderId;
  final String uniqueShortInfo;
  final String email;
  const FeedbackScreen({
    Key key,
    @required this.orderId,
    @required this.uniqueShortInfo,
    @required this.email,
  }) : super(key: key);

  @override
  FeedbackScreenstate createState() => FeedbackScreenstate();
}

class FeedbackScreenstate extends State<FeedbackScreen> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String userfeedback;

  @override
  Widget build(BuildContext context) {
    // MediaQuery.of(context).size.height * 0.5;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        elevation: 2.0,
        centerTitle: true,
        title: Text(
          "Feedback",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            MaterialPageRoute route =
                MaterialPageRoute(builder: (_) => MyOrders());
            Navigator.push(context, route);
          },
        ),
      ),
      body: Padding(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10.0,
              ),
              AlertDialog(
                  content: Form(
                    key: _formkey,
                    child: TextFormField(
                      controller: _controller,
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Enter your feedback here",
                        filled: true,
                      ),
                      maxLines: 5,
                      maxLength: 4096,
                      textInputAction: TextInputAction.done,
                      validator: (String text) {
                        if (text == null || text.isEmpty) {
                          return "Please enter a value";
                        }
                        return null;
                      },
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Send'),
                      onPressed: () async {
                        feedbackReceived(context, getOrderId);

                        if (_formkey.currentState.validate()) {
                          // We will use this var to show the result
                          // of this operation to the user
                          String message;

                          try {
                            // Get a reference to the `feedback` collection

                            FirebaseFirestore.instance
                                .collection('feedback')
                                .add({
                              'feedback': _controller.text.trim(),
                              'shortInfo': widget.uniqueShortInfo,
                              'orderId': widget.orderId,
                              'email': EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userEmail),
                            });

                            // Write the server's timestamp and the user's feedback

                            message = 'Feedback sent successfully';
                          } catch (e) {
                            message = 'Error when sending feedback';
                          }

                          // Show a snackbar with the result
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(content: Text(message)));
                          Navigator.pop(context);
                        }
                      },
                    )
                  ]),
            ]),
          )),
    );
  }
}

feedbackReceived(BuildContext context, String mOrderId) {
  EcommerceApp.firestore
      .collection(EcommerceApp.collectionUser)
      .doc(EcommerceApp.sharedPreferences.getString(EcommerceApp.userUID))
      .collection(EcommerceApp.collectionOrders);
  // .doc(mOrderId)
  // .delete();

  getOrderId = "";

  // Route route = MaterialPageRoute(builder: (c) => FeedbackScreen());
  // Navigator.pushReplacement(context, route);

  // Fluttertoast.showToast(msg: "Order has been Received, Confirmed");
}
