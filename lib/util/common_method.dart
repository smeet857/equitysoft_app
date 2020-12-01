import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';

navigateTo(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

Future<bool> isInternetConnected() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

snackBarAlert(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.redAccent,
  ));
}

snackBarSuccess(GlobalKey<ScaffoldState> scaffoldKey, String message) {
  scaffoldKey.currentState.showSnackBar(SnackBar(
    content: Text(
      message,
      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),
    backgroundColor: Colors.green,
  ));
}
