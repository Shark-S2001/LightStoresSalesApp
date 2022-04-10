import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projects/api/select_customer.dart';
import 'package:projects/model/select_customer_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/save_order.dart';
import '../orders/create_or_view_orders_items.dart';
import '../../../shared/search_widget.dart';

class SelectCustomer extends StatefulWidget {
  SelectCustomer({
    Key? key,
  }) : super(key: key);

  @override
  _SelectCustomerState createState() => _SelectCustomerState();
}

class _SelectCustomerState extends State<SelectCustomer> {
  List<FetchCustomers> customers = [];
  String query = '';
  int loggedInUserId = 0;
  String loggedInUserName ="";
  int org_id = 0;

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
      loggedInUserName = prefs.getString("loggedInUserName").toString();
      org_id = int.parse(prefs.getInt('org_id').toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.0, // Change as per your requirement
      width: MediaQuery.of(context).size.width *
          0.9, // Change as per your requirement
      child: Column(
        children: [
          buildSearch(),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: customers == null ? 0 : customers.length,
                itemBuilder: (context, index) {
                  final cust = customers[index];
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cust.customerName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Text(
                          cust.town,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          cust.routeName,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 5.0)),
                        Text(
                          cust.phoneNumber,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    onTap: () async {
                      //Call the save order api method
                      saveNewOrder(int.parse(cust.customerNum.toString()), 1, org_id,
                          loggedInUserId,loggedInUserName,context);

                      //Close the popup dialog
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SearchProducts()));
                    },
                  );
                }),
          ),
        ],
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search customer',
        onChanged: searchCustomer,
      );
  //Search products method, this is sent to the server per second
  Future searchCustomer(String query) async => debounce(() async {
        final fetchedCustomers = await CustomerApi.fetchCustomersData(query);
        //Used to ignore the dispose state exception
        if (!mounted) return;

        setState(() {
          this.query = query;
          customers = fetchedCustomers;
        });
      });
}
