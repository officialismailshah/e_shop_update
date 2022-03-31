import 'package:flutter/foundation.dart';
import 'package:e_shop/Config/config.dart';

class CartItemCounter extends ChangeNotifier {
  int _counter;
  int get count => _counter;

  displayResult() async {
    _counter = EcommerceApp.sharedPreferences
            .getStringList(EcommerceApp.userCartList)
            .length -
        1;
    notifyListeners();
    return _counter;
    // await Future.delayed(const Duration(milliseconds: 100), () {
    // });
  }
}
