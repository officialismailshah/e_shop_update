import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_shop/StockManager/StockLogin.dart';
import 'package:e_shop/Widgets/customTextField.dart';
import 'package:e_shop/DialogBox/errorDialog.dart';
import 'package:e_shop/DialogBox/loadingDialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Store/storehome.dart';
import 'package:e_shop/Config/config.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final TextEditingController _passwordTextEditingController =
      TextEditingController();
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
            Container(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "images/login.png",
                height: 240.0,
                width: 240.0,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Login to your account",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                ],
              ),
            ),
            // ignore: deprecated_member_use
            RaisedButton(
              onPressed: () {
                _emailTextEditingController.text.isNotEmpty &&
                        _passwordTextEditingController.text.isNotEmpty
                    ? loginUser()
                    : showDialog(
                        context: context,
                        builder: (c) {
                          return ErrorAlertDialog(
                            message: "Please write email and password.",
                          );
                        });
              },
              color: Colors.red,
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
            ),
         SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () {
               
                 if(EcommerceApp.auth.currentUser==null)
                {
                    EcommerceApp.auth.signOut();
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StoreHome(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text(
                "Login As Guest",
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              height: 4.0,
              width: _screenWidth * 0.8,
              color: Colors.red,
            ),
            SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              // ignore: deprecated_member_use
              child: FlatButton.icon(
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AdminSignInPage())),
                icon: (Icon(
                  Icons.nature_people,
                  color: Colors.red,
                )),
                label: Text(
                  "I'm StockManager",
                  style:
                      TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(0.0),
            // ignore: deprecated_member_use
            //   child: FlatButton.icon(
            //     onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //             builder: (context) => StockManagerSignInPage())),
            //     icon: (Icon(
            //       Icons.inventory,
            //       color: Colors.red,
            //     )),
            //     label: Text(
            //       "i'm Stock Manager",
            //       style:
            //           TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  void loginUser() async {
    showDialog(
        context: context,
        builder: (c) {
          return LoadingAlertDialog(
            message: "Authenticating, Please wait...",
          );
        });
    User firebaseUser;
    await _auth
        .signInWithEmailAndPassword(
      email: _emailTextEditingController.text.trim(),
      password: _passwordTextEditingController.text.trim(),
    )
        .then((authUser) {
      firebaseUser = authUser.user;
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
      readData(firebaseUser).then((s) {
        Navigator.pop(context);
        Route route = MaterialPageRoute(builder: (c) => StoreHome());
        Navigator.pushReplacement(context, route);
      });
    }
  }

  Future readData(User fUser) async {
    FirebaseFirestore.instance
        .collection("users")
        .doc(fUser.uid)
        .get()
        .then((dataSnapshot) async {
      await EcommerceApp.sharedPreferences
          .setString("uid", dataSnapshot[EcommerceApp.userUID]);

      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userEmail, dataSnapshot[EcommerceApp.userEmail]);

      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userName, dataSnapshot[EcommerceApp.userName]);

      await EcommerceApp.sharedPreferences.setString(
          EcommerceApp.userAvatarUrl, dataSnapshot[EcommerceApp.userAvatarUrl]);

      List<String> cartList =
          dataSnapshot[EcommerceApp.userCartList].cast<String>();
      await EcommerceApp.sharedPreferences
          .setStringList(EcommerceApp.userCartList, cartList);
    });
  }
}
