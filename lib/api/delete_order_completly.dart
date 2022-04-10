import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:projects/view/pages/orders/view_order_history.dart';
import '../config/globals.dart';

Future<http.Response>  deleteWholeOrder(int orderNum,final context) async{
  var url = Uri.parse(baseUrl + "/delete_order_completely");
  final bodyParams = jsonEncode({"order_no":orderNum});

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

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const OrderHistory()));

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