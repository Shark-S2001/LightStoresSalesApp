import 'package:flutter/material.dart';
import 'package:projects/model/select_customer_data.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;
import 'package:fluttertoast/fluttertoast.dart';

class CustomersAction extends StatefulWidget {
  final FetchCustomers selectedCust;
  const CustomersAction({
    Key? key,
    required this.selectedCust,
  }) : super(key: key);

  @override
  _CustomersActionState createState() => _CustomersActionState();
}

class _CustomersActionState extends State<CustomersAction> {
  String greetingMes = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    greeting();

    greetingMes = greeting();
  }

  //Greet user on login
  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    }
    if (hour < 17) {
      return 'Good Afternoon';
    }
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    _textCustomer() async {
      // Android
      final uri =
          'sms: ${widget.selectedCust.phoneNumber}?body=$greetingMes %20${widget.selectedCust.customerName}%20...';
      if (await canLaunch(uri)) {
        await launch(uri);
      } else {
        // iOS
        final uri =
            'sms: ${widget.selectedCust.phoneNumber}?body=$greetingMes %20${widget.selectedCust.customerName}%20...';
        if (await canLaunch(uri)) {
          await launch(uri);
        } else {
          throw 'Could not launch $uri';
        }
      }
    }

    _messageCustomerwhatsapp() async {
      String strippedNumber = widget.selectedCust.phoneNumber.substring(1);
      var whatsapp = "+254$strippedNumber" ;
      var whatsappURl_android = "whatsapp://send?phone=" +
          whatsapp +
          "&text=${greetingMes} %20${widget.selectedCust.customerName}%20...";

      var whatappURL_ios =
          "https://wa.me/$whatsapp?text=${Uri.parse("$greetingMes %20${widget.selectedCust.customerName}%20...")}";
      if (Platform.isIOS) {
        // for iOS phone only
        if (await canLaunch(whatappURL_ios)) {
          await launch(whatappURL_ios, forceSafariVC: false);
        } else {
          Fluttertoast.showToast(
              msg: "WhatsApp is not installed on this device",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      } else {
        // android , web
        if (await canLaunch(whatsappURl_android)) {
          await launch(whatsappURl_android);
        } else {
          Fluttertoast.showToast(
              msg: "WhatsApp is not installed on this device",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.pink,
              textColor: Colors.white,
              fontSize: 16.0);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Customer Info",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Column(
        children: [
          SizedBox(
            height: height * 0.45,
            width: MediaQuery.of(context).size.width,
            child: Card(
              color: Colors.white,
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.35,
                    child: ListTile(
                      title: Column(
                        //mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                              dense: true,
                              title: Text(
                                "Name:  ${widget.selectedCust.customerName}",
                                style: TextStyle(letterSpacing: 1.5),
                              )),
                          Divider(color: Colors.black12),
                          ListTile(
                              dense: true,
                              title: Text(
                                "Town:  ${widget.selectedCust.town}",
                                style: TextStyle(letterSpacing: 1.5),
                              )),
                          Divider(color: Colors.black12),
                          ListTile(
                              dense: true,
                              title: Text(
                                "Route:   ${widget.selectedCust.routeName}",
                                style: TextStyle(letterSpacing: 1.5),
                              )),
                          Divider(color: Colors.black12),
                          ListTile(
                              dense: true,
                              title: Text(
                                "Tel:   ${widget.selectedCust.phoneNumber}",
                                style: TextStyle(letterSpacing: 1.5),
                              )),
                          Divider(color: Colors.black12),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.phone),
                        color: Colors.deepOrange,
                        onPressed: () async {
                          FlutterPhoneDirectCaller.callNumber(
                              widget.selectedCust.phoneNumber);
                        },
                      ),
                      title: IconButton(
                        icon: Icon(Icons.message),
                        color: Colors.lightBlueAccent,
                        onPressed: () {
                          _textCustomer();
                        },
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.whatsapp_outlined),
                        color: Colors.green,
                        onPressed: () {
                          _messageCustomerwhatsapp();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
