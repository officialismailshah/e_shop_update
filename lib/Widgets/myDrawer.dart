// ignore_for_file: deprecated_member_use

import 'package:e_shop/Authentication/authenication.dart';
import 'package:e_shop/Config/config.dart';
import 'package:e_shop/Address/addAddress.dart';
import 'package:e_shop/Store/Search.dart';
import 'package:e_shop/Store/cart.dart';
import 'package:e_shop/Orders/myOrders.dart';
import 'package:e_shop/Store/storehome.dart';
// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/services.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                Material(
                  borderRadius: BorderRadius.all(Radius.circular(80.0)),
                  elevation: 8.0,
                  child: Container(
                    height: 160.0,
                    width: 160.0,
                    child: CircleAvatar(
                      backgroundImage: EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userAvatarUrl) ==
                              null
                          ? Image.asset('assets/images/person.png').image
                          : NetworkImage(
                              EcommerceApp.sharedPreferences
                                  .getString(EcommerceApp.userAvatarUrl),
                            ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userName) ==
                        null
                    ? Text(
                        'Guest',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            fontFamily: "Signatra"),
                      )
                    : Text(
                        EcommerceApp.sharedPreferences
                            .getString(EcommerceApp.userName),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35.0,
                            fontFamily: "Signatra"),
                      ),
              ],
            ),
          ),
          SizedBox(
            height: 12.0,
          ),
          Container(
            padding: EdgeInsets.only(top: 1.0),
            decoration: const BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.redAccent, Colors.blueAccent],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Home",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => StoreHome());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.reorder,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (EcommerceApp.auth.currentUser == null) {
                      Fluttertoast.showToast(
                        msg: "Please Login First",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity
                            .BOTTOM, // also possible "TOP" and "CENTER"
                        backgroundColor: Colors.red[900],
                        textColor: Colors.white,
                      );
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (c) => MyOrders());
                      Navigator.pushReplacement(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  title: Text(
                    "My Cart",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (EcommerceApp.auth.currentUser == null) {
                      Fluttertoast.showToast(
                        msg: "Please Login First",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity
                            .BOTTOM, // also possible "TOP" and "CENTER"
                        backgroundColor: Colors.red[900],
                        textColor: Colors.white,
                      );
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (c) => CartPage());
                      Navigator.pushReplacement(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Search",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Route route =
                        MaterialPageRoute(builder: (c) => SearchProduct());
                    Navigator.pushReplacement(context, route);
                  },
                ),
                  Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                ListTile(
                  leading: Icon(
                    Icons.add_location,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Add New Address",
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    if (EcommerceApp.auth.currentUser == null) {
                      Fluttertoast.showToast(
                        msg: "Please Login First",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity
                            .BOTTOM, // also possible "TOP" and "CENTER"
                        backgroundColor: Colors.red[900],
                        textColor: Colors.white,
                      );
                    } else {
                      Route route =
                          MaterialPageRoute(builder: (c) => AddAddress());
                      Navigator.pushReplacement(context, route);
                    }
                  },
                ),
                Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ),
                EcommerceApp.auth.currentUser != null ? ListTile(
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Colors.white,
                    ),
                    title: Text(
                      "Logout",
                      style: TextStyle(color: Colors.white),
                    ),
                    onTap: () {
                      if (EcommerceApp.auth.currentUser == null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (c) => AuthenticScreen()));
                      } else {
                        EcommerceApp.auth.signOut().then((c) {
                          Route route = MaterialPageRoute(
                              builder: (c) => AuthenticScreen());
                          Navigator.pushReplacement(context, route);
                        });
                      }
              
                     } )
                :SizedBox(),

                EcommerceApp.auth.currentUser !=null ? Divider(
                  height: 10.0,
                  color: Colors.white,
                  thickness: 6.0,
                ):SizedBox(),
                  EcommerceApp.auth.currentUser==null ? RaisedButton(child: Text("SignUp"),color: Colors.white,onPressed: (){
                    Route route = MaterialPageRoute(
                              builder: (c) => AuthenticScreen());
                          Navigator.pushReplacement(context, route);

                }):SizedBox()

              ]
            ),
          ),
        ],
      ),
    );
  }
}
