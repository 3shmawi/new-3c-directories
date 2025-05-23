import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class AppToast {
  static void showError(String message) => _toast(message, Colors.red);

  static void showSuccess(String message) => _toast(message);

  //component
  static _toast(String msg, [Color color = Colors.green]) =>
      Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0,
      );
}
