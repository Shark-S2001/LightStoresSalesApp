import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../config/globals.dart';

Future<http.Response>  updateItemInCart(int productCode,double quantity,double unitPrice,double productVat,
    double amount,String username,context) async{

  Map data = {
    "product_code": productCode,
    "qty": quantity,
    "unit_price" : unitPrice,
    "product_vat": productVat,
    "amount": amount,
    "username": username,
  };

  var body = json.encode(data);

  var url = Uri.parse(baseUrl + "/update_product_in_cart");

  http.Response response = await http.post(url,headers: headers , body: body);

  final responseMessage = json.decode(response.body);

  if(response.statusCode == 200){
    Fluttertoast.showToast(
        msg: responseMessage["long_message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.pink,
        textColor: Colors.white,
        fontSize: 16.0
    );
    Navigator.pop(context);

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