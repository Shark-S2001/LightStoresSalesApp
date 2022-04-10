import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/view/Dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<http.Response> login(username,password,context) async
{
  Map data = {
    'username': username,
    'password': password
  };

  final  response= await http.post(
      Uri.parse(baseUrl+"/login"),
     headers: headers,
      body: json.encode(data),
      encoding: Encoding.getByName("utf-8")
  );

  if (response.statusCode == 200) {

    Map<String,dynamic>responses=jsonDecode(response.body);

    if("error".compareTo(responses["status"].toString())!=0)
    {
      savePref(responses['username'],responses["userID"],responses["orgID"]);

      //Redirect to the dashboard
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const DashboardPage()));

    }else{
      Fluttertoast.showToast(
          msg: "${responses['long_message']}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }
  return response;
}

//Sessions
savePref(String username,int userID,int orgID) async {
  final preferences = await SharedPreferences.getInstance();
  //Save the keys in session
  await preferences.setString("loggedInUserName", username);
  await  preferences.setInt("org_id", orgID);
  await  preferences.setInt("loggedInUserId", userID);
}
