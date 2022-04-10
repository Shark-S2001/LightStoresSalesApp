import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projects/api/select_customer.dart';
import 'package:projects/model/select_customer_data.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:projects/view/pages/customers/perform_actions_on_customer.dart';
import '../../../shared/search_widget.dart';
import 'create_customer.dart';

class DisplayAvailableCustomers extends StatefulWidget {
  const DisplayAvailableCustomers({Key? key}) : super(key: key);

  @override
  _DisplayAvailableCustomersState createState() => _DisplayAvailableCustomersState();
}

class _DisplayAvailableCustomersState extends State<DisplayAvailableCustomers> {
  List<FetchCustomers> viewCustomers = [];
  String query = '';
  Timer ? debouncer;
  bool _isReady = true;

  @override
  void initState(){
    super.initState();

    LoadCustomersOnPageLoad();
  }

  Future LoadCustomersOnPageLoad() async {
    final customers = await CustomerApi.fetchCustomersData(query);

    if(!mounted) return;

    setState(() {
      query = query;
      viewCustomers = customers;
      _isReady = false;
    });
  }

  @override
  void dispose(){
    debouncer?.cancel();
    super.dispose();
  }

  //Ensure only one request is going to the server, per 0.1 second
  void debounce(
      VoidCallback callback, {
        Duration duration = const  Duration(microseconds: 100),
      }){
    if(debouncer !=null){
      debouncer!.cancel();
    }
    debouncer = Timer(duration, callback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset : false,
      appBar: AppBar(
          title: Text("View Customers",style: TextStyle(fontSize: 16)),
          backgroundColor: Colors.deepOrange
      ),
      body: RefreshIndicator(
        child: Center(
          child: _isReady ? const CircularProgressIndicator() : Column(
            children: [
              buildSearch(),
              Expanded(child: ListView.builder(
                  itemCount: viewCustomers.length,
                  itemBuilder: (context, index){
                    final cust = viewCustomers[index];

                    return ListTile(
                      leading: Text(cust.customerName),
                      trailing: Text(cust.phoneNumber),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>CustomersAction(selectedCust: cust)));
                      },
                    );

                  }))
            ],
          ),
        ),
        // Function that will be called when
        // user pulls the ListView downward
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {
              setState(() {
                //Call the refresh load customers get data api
                LoadCustomersOnPageLoad();
              });

              Fluttertoast.showToast(
                  msg: "Customers refreshed successfully",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.pink,
                  textColor: Colors.white,
                  fontSize: 16.0
              );
            },
          );
        },
      ),
      floatingActionButton: SizedBox(
        height: 40.0,
        width: 150.0,
        child: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateNewCustomer())).whenComplete(() => LoadCustomersOnPageLoad());
          },
          backgroundColor: Colors.deepOrange, label:  Text('New Customer',
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold
          ),),
          icon: Icon(Icons.person_add_alt),
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search By Customer Name',
    onChanged: SearchCustomer,
  );

  //Search customer method, this is sent to the server per second
  Future SearchCustomer(String query) async => debounce(() async {
    final customers = await CustomerApi.fetchCustomersData(query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      this.query = query;
      viewCustomers = customers;
    });
  });
}

