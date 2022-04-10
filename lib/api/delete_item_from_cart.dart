import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../config/globals.dart';

Future<http.Response>  deleteItemFromCart(String productCodeParam,String usernameParam) async{
  var url = Uri.parse(baseUrl + "/delete_product_from_cart");
  final bodyParams = jsonEncode({"product_code":productCodeParam,"username":usernameParam});

  http.Response response = await http.post(url,headers: headers , body: bodyParams);

  final responseMessage = json.decode(response.body);

  if(response.statusCode == 200){
    Fluttertoast.showToast(
        msg: responseMessage["long_message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }else{
    Fluttertoast.showToast(
        msg: responseMessage["long_message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  return response;
}