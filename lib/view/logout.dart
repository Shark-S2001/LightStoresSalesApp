import 'package:flutter/material.dart';
import 'package:projects/view/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> logoutUser(context) async {
  //Clear all the memory keys
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.clear();
  //Navigate to Login Page
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
      LoginFunction()), (Route<dynamic> route) => false);
}