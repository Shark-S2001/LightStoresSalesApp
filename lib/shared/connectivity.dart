import 'dart:async';

import 'package:connectivity/connectivity.dart';

late Connectivity connectivity;
late StreamSubscription<ConnectivityResult> subscription;

@override
void initState() {
  connectivity = Connectivity();
  subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
    if(result == ConnectivityResult.mobile || result==ConnectivityResult.wifi){
      //print("Connected successfully");
    }else{
      //print("Please Check your Internet Connection");
    }
  });
}