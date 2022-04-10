import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projects/api/select_routes.dart';
import 'package:projects/model/select_routes.dart';
import 'package:searchfield/searchfield.dart';
import '../../../api/save_new_customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreateNewCustomer extends StatefulWidget {
  const CreateNewCustomer({Key? key}) : super(key: key);

  @override
  _CreateNewCustomerState createState() => _CreateNewCustomerState();
}

class _CreateNewCustomerState extends State<CreateNewCustomer> {
  //Instantiate list
  List<FetchAllRoutes> routes = [];
  final cust_name = TextEditingController();
  final phone_number = TextEditingController();
  final town = TextEditingController();

  int _routeID =0;
  int loggedInUserId = 0;
  int org_id =0;
  Timer? debouncer;

  //Ensure only one request is going to the server, per 0.1 second
  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(microseconds: 1000),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }


  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  //Get data from Api
  void getAvailableRoutes() async{
    final selectedRoutes = await RoutesApi.fetchAllRoutesFromJson();

    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      routes = selectedRoutes;
    });
  }


  @override
  void initState() {
    super.initState();
    _loadDataFromSession();
    getAvailableRoutes();
  }
  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = int.parse(prefs.getInt('loggedInUserId').toString());
      org_id = int.parse(prefs.getInt('org_id').toString());
    });
  }

  void ClearFields() {
    cust_name.clear();
    phone_number.clear();
    town.clear();
    _routeID =0;
  }


  @override
  Widget build(BuildContext context) {
    _loadDataFromSession();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Customer",style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.deepOrange,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      child: TextFormField(
                    controller: cust_name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.title_outlined),
                      labelText: "Customer Name",
                    ),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      child: TextFormField(
                    controller: phone_number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.contact_phone_outlined),
                      labelText: "Phone Number",
                    ),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      child: TextFormField(
                    controller: town,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      suffixIcon: Icon(Icons.location_pin),
                      labelText: "Town",
                    ),
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                      child: SearchField(
                    suggestions: routes
                        .map((route) => SearchFieldListItem(route.routeName,item: route.id))//item sets the selectable field value
                        .toList(),
                    suggestionState: Suggestion.expand,
                    textInputAction: TextInputAction.next,
                    hint: 'Select Route',
                    hasOverlay: false,
                    searchStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.black.withOpacity(0.8),
                    ),
                    searchInputDecoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      ),
                    ),
                    maxSuggestionsInViewPort: 6,
                    itemHeight: 50,
                    onTap: (x) {
                      setState(() {
                        _routeID = int.parse(x.item.toString());
                      });
                    },
                  )),
                  SizedBox(
                    height: 15,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    SizedBox(
                      width: 80,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.deepOrange),
                        child: Text("Save"),
                        onPressed: () {
                          saveNewCustomer(cust_name.text, phone_number.text,
                              town.text, _routeID, loggedInUserId, org_id,context);
                        },
                      ),
                    ),
                  ])
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
