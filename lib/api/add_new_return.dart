import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

import '../config/globals.dart';

Future<http.Response>  addNewReturn(int orderNum,int productCode,int quantity,int unitPrice,
    String returnReason,String userID,final context) async{

  Map data = {
    "order_num":orderNum,
    "product_code": productCode,
    "qty": quantity,
    "unit_price" : unitPrice,
    "reason": returnReason,
    "user_id": userID,
  };

  var body = json.encode(data);

  var url = Uri.parse(baseUrl + "/add_item_to_returns");

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