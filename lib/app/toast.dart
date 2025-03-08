import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class ToastHandler {
  /// Displays a success toast with a green background.
  /// [webHexColor] accepts a hex string like "#28a745".
  static void showSuccess(String message) {
    _showToast(
      message,
      backgroundColor: Colors.green,
      webHexColor: "#28a745",
    );
  }

  /// Displays an error toast with a red background.
  /// [webHexColor] accepts a hex string like "#dc3545".
  static void showError(String message) {
    _showToast(
      message,
      backgroundColor: Colors.red,
      webHexColor: "#dc3545",
    );
  }

  /// Displays an info toast with a grey background.
  /// [webHexColor] accepts a hex string like "#6c757d".
  static void showInfo(String message) {
    _showToast(
      message,
      backgroundColor: Colors.grey[400] ?? Colors.grey,
      webHexColor: "#6c757d",
    );
  }

  /// Helper method to display a toast.
  static void _showToast(
    String message, {
    required Color backgroundColor,
    required String webHexColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
      webBgColor: webHexColor,
      webPosition: "bottom",
    );
  }
}
