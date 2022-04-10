import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:projects/config/globals.dart';

Future<http.Response>  saveNewOrder(int customerNum,int orderStatus,
    int orgId,int userID,userName,context) async{

  Map data = {
      "customer_num" : customerNum,
      "order_status": orderStatus,
      "org_id" : orgId,
      "user_id": userID,
      "username":userName
    };

    var body = json.encode(data);
    var url = Uri.parse(baseUrl+"/add_new_order");

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