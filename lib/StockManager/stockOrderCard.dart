import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/StockManager/stockOrderDetails.dart';
import 'package:e_shop/Models/item.dart';
import 'package:e_shop/Widgets/orderCard.dart';
import 'package:flutter/material.dart';

// import '../Store/storehome.dart';

int counter = 0;

class AdminOrderCard extends StatelessWidget {
  final int itemCount;
  final List<DocumentSnapshot> data;
  final String orderID;
  final String addressID;
  final String orderBy;

  AdminOrderCard({
    Key key,
    this.itemCount,
    this.data,
    this.orderID,
    this.addressID,
    this.orderBy,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Route route;

        route = MaterialPageRoute(
          builder: (c) => AdminOrderDetails(
            orderID: orderID,
            orderBy: orderBy,
            addressID: addressID,
          ),
        );
        counter = counter + 1;

        Navigator.push(context, route);
      },
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            colors: [Colors.redAccent, Colors.blueAccent],
            begin: const FractionalOffset(0.0, 0.0),
            end: const FractionalOffset(1.0, 0.0),
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp,
          ),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        height: itemCount * 190.0,
        child: ListView.builder(
          itemCount: itemCount,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (c, index) {
            ItemModel model = ItemModel.fromJson(data[index].data());
            return SourceOrderInfo(
              model: model,
              orderID: orderID,
            );
          },
        ),
      ),
    );
  }
}
