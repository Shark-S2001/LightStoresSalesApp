import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projects/view/login.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState(){
    super.initState();

    connectionState();
  }

  Future<void> connectionState() async {
    //Check internet connection by pinging alpac servers
    final result = await InternetAddress.lookup('alpac.xyz');

    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      RedirectToLogin();
    } else {
      Fluttertoast.showToast(
          msg: "Please Check your Internet Connection!!",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 30,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    }
  }

  void RedirectToLogin(){
    Future.delayed(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginFunction()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset("images/logo.png",height: 180,width: 180,),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            const Text(
              "Splash Screen",
              style: TextStyle(
                  fontSize: 20.0,
                  color: Color.fromRGBO(250,250,235,0),
              ),
            ),
            const Padding(padding: EdgeInsets.only(top: 20.0)),
            const CircularProgressIndicator(
              backgroundColor: Colors.deepOrange,
              strokeWidth: 5,
            ),
          ],
        ),
      ),
    );
  }
}
