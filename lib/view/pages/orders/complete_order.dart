import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../../../api/populate_customers_dropdown.dart';
import '../../../api/select_customer.dart';
import '../../../model/select_customer_data.dart';
import 'package:searchfield/searchfield.dart';
import '../../../shared/search_widget.dart';

class CompleteOrder extends StatefulWidget {
  const CompleteOrder({Key? key}) : super(key: key);

  @override
  _CompleteOrderState createState() => _CompleteOrderState();
}

class _CompleteOrderState extends State<CompleteOrder> {
  List<FetchCustomers> customers = [];
  String query = '';
  int loggedInUserId = 0;
  int org_id =0;

  Timer? debouncer;

  @override
  void dispose() {
    debouncer?.cancel();
    super.dispose();
  }

  //Ensure only one request is going to the server, per 0.1 second
  void debounce(
      VoidCallback callback, {
        Duration duration = const Duration(microseconds: 100),
      }) {
    if (debouncer != null) {
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  void initState() {
    super.initState();
    _loadDataFromSession();
  }
  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = int.parse(prefs.getInt('loggedInUserId').toString());
      org_id = int.parse(prefs.getInt('org_id').toString());
    });
  }


  selectCustomer() async{
    final fetchedCustomers = await CustomerDropDownApi.fetchCustomersData();
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      customers = fetchedCustomers;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("Complete Order",
            style: TextStyle(fontSize: 16)),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height*0.5,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 150,
                            child: SearchField(
                              suggestions: customers
                                  .map((customer) => SearchFieldListItem(customer.customerName,item: customer.customerNum))//item sets the selectable field value
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
                                  // _routeID = int.parse(x.item.toString());
                                });
                              },
                            )),

                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search customer',
    onChanged: SearchCustomer,
  );
  //Search products method, this is sent to the server per second
  Future SearchCustomer(String query) async => debounce(() async {
    final fetchedCustomers = await CustomerApi.fetchCustomersData(query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      this.query = query;
      customers = fetchedCustomers;
    });
  });
}




