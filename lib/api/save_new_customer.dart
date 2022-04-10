import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:projects/config/globals.dart';

Future<http.Response>  saveNewCustomer(String customerName,String phoneNumber,String town,int routeId,
    int userID,int orgId,context) async{

  //Model data mapping
  Map data = {
    "customer_name" : customerName,
    "phone_number": phoneNumber,
    "town": town,
    "route_id" : routeId,
    "user_id":userID,
    "org_id": orgId
  };

  var body = json.encode(data);
  var url = Uri.parse(baseUrl+"/create_new_customer");

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