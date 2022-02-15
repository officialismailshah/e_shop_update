import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/Admin/adminOrderCard.dart';
import 'package:e_shop/Admin/uploadItems.dart';
import 'package:e_shop/Config/config.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import '../Widgets/loadingWidget.dart';
// import '../Widgets/orderCard.dart';

class AdminShiftOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<AdminShiftOrders> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Route route = MaterialPageRoute(builder: (context) => UploadPage());
        Navigator.push(context, route);
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.white),
            flexibleSpace: Container(
              decoration: new BoxDecoration(
                gradient: new LinearGradient(
                  colors: [Colors.redAccent, Colors.blueAccent],
                  begin: const FractionalOffset(0.0, 0.0),
                  end: const FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp,
                ),
              ),
            ),
            centerTitle: true,
            title: Text(
              "My Customer Orders",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Route route =
                    MaterialPageRoute(builder: (context) => UploadPage());
                Navigator.push(context, route);
              },
            ),
          ),
          body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection("orders").snapshots(),
            builder: (c, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (c, index) {
                        return FutureBuilder<QuerySnapshot>(
                          future: FirebaseFirestore.instance
                              .collection("items")
                              .where("shortInfo",
                                  whereIn: snapshot.data.docs[index]
                                      [EcommerceApp.productID])
                              .get(),
                          builder: (c, snap) {
                            return snap.hasData
                                ? AdminOrderCard(
                                    itemCount: snap.data.docs.length,
                                    data: snap.data.docs,
                                    orderID: snapshot.data.docs[index].id,
                                    orderBy: snapshot.data.docs[index]
                                        ["orderBy"],
                                    addressID: snapshot.data.docs[index]
                                        ["addressID"],
                                  )
                                : Center(
                                    child: circularProgress(),
                                  );
                          },
                        );
                      },
                    )
                  : Center(
                      child: circularProgress(),
                    );
            },
          ),
        ),
      ),
    );
  }
}
