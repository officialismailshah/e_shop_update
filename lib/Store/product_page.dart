import 'dart:math';

import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Widgets/customAppBar.dart';
// import 'package:e_shop/Widgets/myDrawer.dart';
import 'package:e_shop/Models/item.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/Store/storehome.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../Widgets/dialog.dart';
import '../Widgets/itemquantity_selector.dart';

class ProductPage extends StatefulWidget {
  final ItemModel itemModel;
  final String category;
  ProductPage({this.itemModel, this.category});

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int quantityOfItems = 1;
  

  @override
  Widget build(BuildContext context) {
     const availableQuantity = 5;
    // Size screenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Route route = MaterialPageRoute(builder: (context) => StoreHome());
          Navigator.push(context, route);
          return true;
        },
        child: Scaffold(
          appBar: MyAppBar(),
          // drawer: MyDrawer(),
          body: ListView(
            children: [
              Container(
                padding: EdgeInsets.all(15.0),
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Center(
                          child: Image.network(widget.itemModel.thumbnailUrl),
                        ),
                        Container(
                          color: Colors.grey[300],
                          child: SizedBox(
                            height: 1.0,
                            width: double.infinity,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.itemModel.title,
                              style: boldTextStyle,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.itemModel.longDescription,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              "Rs " + widget.itemModel.price.toString(),
                              style: boldTextStyle,
                            ),
                            Row(
                               mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Quantity:'),
            ItemQuantitySelector(
              // TODO: plug in state
              quantity: 1,
              // let the user choose up to the available quantity or
              // 10 items at most
              maxQuantity: min(availableQuantity, 6),
              // TODO: Implement onChanged
              onChanged: (value) {
                showNotImplementedAlertDialog(context: context);
              },
            ),
          ],
        ),
                            
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Center(
                        child: InkWell(
                          onTap: () {
                            if (EcommerceApp.auth.currentUser == null) {
                              Fluttertoast.showToast(
                                msg: 'Please Login First',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity
                                    .BOTTOM, // also possible "TOP" and "CENTER"
                                backgroundColor: Colors.red[900],
                                textColor: Colors.white,
                              );
                            } else {
                              checkItemInCart(widget.itemModel.shortInfo,
                                  context, );
                            }
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Colors.redAccent, Colors.blueAccent],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(1.0, 0.0),
                                stops: [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            width: MediaQuery.of(context).size.width - 40.0,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Add to Cart",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const boldTextStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 20);
const largeTextStyle = TextStyle(fontWeight: FontWeight.normal, fontSize: 20);
