import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projects/view/pages/orders/view_order_items.dart';
import '../../../api/select_recent_orders.dart';
import '../../../model/select_recent_orders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../shared/search_widget.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({Key? key}) : super(key: key);

  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<FetchRecentOrders> recentOrders = [];
  var formatter = NumberFormat('#,##,000');
  int loggedInUserId = 0;
  bool _isReady = true;
  String query ="";
  Timer ? debouncer;

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
  void initState() {
    super.initState();
    _loadDataFromSession();
  }
  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserId = int.parse(prefs.getInt('loggedInUserId').toString());
    });
    //Call the fetch orders method
    getRecentOrdersFromApi(loggedInUserId.toString());
  }

  //Refresh the Dashboard after 1 second
  getRecentOrdersFromApi(String loggedInUserId) async{
        final recentOrdersData = await RecentOrdersApi.fetchRecentOrdersData(loggedInUserId,query);
        //Used to ignore the dispose state exception
        if (!mounted) return;

        setState(() {
          recentOrders = recentOrdersData;

          //Update the ui when data is loaded
          _isReady = false;
        });
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("View Orders",style: TextStyle(fontSize: 16)),
        backgroundColor: Colors.deepOrange,
      ),
      body: RefreshIndicator(
        child: Column(
          children: <Widget>[
            buildSearch(),
            ListTile(
                dense: true,
                onTap: null,
                leading: Text(
                  "Customer Name",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              title: Center(
                child: Text(
                  "Order Total",
                  style: TextStyle(
                    color: Colors.deepOrange,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
              trailing: Text(
                "Status",
                style: TextStyle(
                  color: Colors.deepOrange,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            _isReady ? Padding(
              padding: const EdgeInsets.fromLTRB(0,250,0,0),
              child: Center(child: CircularProgressIndicator()),
            ) :
            Expanded(
              child: ListView.builder(
                  itemCount: recentOrders==null ? 0 : recentOrders.length,
                  itemBuilder: (BuildContext context, index) {
                    final showOrders = recentOrders[index];

                    return ListTile(
                      leading: Text(showOrders.customerName,style: TextStyle(fontSize: 12),),
                      title: Center(child: Text(formatter.format(double.parse(showOrders.orderTotals.toString())),style: TextStyle(fontSize: 12))),
                      trailing: Text(showOrders.statusName,style: TextStyle(fontSize: 12)),
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>OrderItems(showOrders: showOrders))).whenComplete(() =>  getRecentOrdersFromApi(loggedInUserId.toString()));
                      },
                    );
                  }),
            ),
          ],
        ),
        // user pulls the ListView downward
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {
              setState(() {
                //Call the fetch orders method
                getRecentOrdersFromApi(loggedInUserId.toString());
              });

              Fluttertoast.showToast(
                  msg: "Orders refreshed successfully",
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
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search By Customer Name',
    onChanged: SearchOrders,
  );

  //Search products method, this is sent to the server per second
  Future SearchOrders(String query) async => debounce(() async {
    final customerOrders = await RecentOrdersApi.fetchRecentOrdersData(loggedInUserId.toString(),query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      this.query = query;
      recentOrders = customerOrders;
    });
  });

}
