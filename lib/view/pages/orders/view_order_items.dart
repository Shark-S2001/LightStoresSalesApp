import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:projects/api/add_new_return.dart';
import 'package:projects/api/add_return_full_order.dart';
import 'package:projects/api/select_single_order_items.dart';
import 'package:projects/model/select_recent_orders.dart';
import 'package:projects/model/select_single_order_items.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/delete_order_completly.dart';

class OrderItems extends StatefulWidget {
  //Define list that holds the order no from order history
  final FetchRecentOrders showOrders;

  const OrderItems({
    Key? key,
    required this.showOrders,
  }) : super(key: key);

  @override
  _OrderItemsState createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  List<FetchOrderItems> items = [];
  double orderTotalValue = 0;
  int loggedInUserID = 0;
  var formatter = NumberFormat('#,##,000');
  bool _isReady = true;
  String returnReason = "";

  @override
  void initState() {
    super.initState();

    //Call the api method to fetch the data
    getItemsFromApi(int.parse(widget.showOrders.orderNo.toString()));
    //Load the shared preferences
    _loadDataFromSession();
  }

  getItemsFromApi(int orderNumParam) async {
    final allOrderItems =
        await SingleOrderItemsApi.fetchOrderItemsFromJson(orderNumParam);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      items = allOrderItems;
      //initialize and set order total
      orderTotalValue = double.parse(items[0].orderTotals.toString());

      _isReady = false;
    });
  }

  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserID = int.parse(prefs.getInt('loggedInUserId').toString());
    });
  }

  //Call delete api method
  deleteSelectedOrder(int orderNum, final context) async {
    deleteWholeOrder(orderNum, context);
  }

  //Single item popup
  Future<bool> showReturnItemPopup(final selectedItem, orderNum, productCode,
      qtyReturned, unitPrice, userID) async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Restore Item(s)',
              style: TextStyle(fontSize: 14, color: Colors.deepOrange),
            ),
            content: Text(
              'You Selected  $selectedItem, tap a reason to complete restoration',
              style: TextStyle(fontSize: 13),
            ),
            actions: [
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () => //call logout User function
                      {
                    setState(() {
                      returnReason = "Customer Rejected";
                    }),
                    addNewReturn(
                        orderNum,
                        productCode,
                        qtyReturned,
                        unitPrice,
                        returnReason,
                        userID,
                        context),
                    //Call the api method to fetch the data
                    getItemsFromApi(int.parse(widget.showOrders.orderNo.toString()))
                  },
                  //return true when click on "Yes"
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                ),
              ),
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () => //call logout User function
                      {
                    setState(() {
                      returnReason = "Product was damaged";
                    }),
                    addNewReturn(
                        orderNum,
                        productCode,
                        qtyReturned,
                        unitPrice,
                        returnReason,
                        userID,
                        context),
                    //Call the api method to fetch the data
                    getItemsFromApi(int.parse(widget.showOrders.orderNo.toString()))
                  },
                  //return true when click on "Yes"
                  child: Text(
                    'Damaged',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                ),
              ),
              SizedBox(
                height: 35,
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                ),
              ),
            ],
          ),
        ) ??
        false; //if show dialog returns null, then return false
  }

  //Full Order confirmation popup
  Future<bool> showFullOrderPopup(orderNum) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Restore Full Order',
          style: TextStyle(fontSize: 14, color: Colors.deepOrange),
        ),
        content: Text(
          'Confirm Action, Restore Full Order ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () => //call logout User function
              {
                restoreFullOrder(orderNum,
                loggedInUserID.toString(), context)
              },
              //return true when click on "Yes"
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
        ],
      ),
    ) ??
        false; //if show dialog returns null, then return false
  }

  //Delete confirmation action popup
  Future<bool> showDeletePopup(orderNum) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Order',
          style: TextStyle(fontSize: 14, color: Colors.deepOrange),
        ),
        content: Text(
          'Confirm Action, Delete order ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () => //call logout User function
              {
                deleteSelectedOrder(orderNum, context)
              },
              //return true when click on "Yes"
              child: Text(
                'Continue',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
          SizedBox(
            height: 35,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              //return false when click on "NO"
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
            ),
          ),
        ],
      ),
    ) ??
        false; //if show dialog returns null, then return false
  }

  @override
  Widget build(BuildContext context) {
    //Define screen width
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Items for Order No: ${widget.showOrders.orderNo}",
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: Colors.deepOrange,
      ),
      body: Card(
        // set the margin to zero
        margin: EdgeInsets.zero,
        child: _isReady
            ? Center(child: const CircularProgressIndicator())
            : Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.13,
                    child: ListView.builder(
                        itemCount: items == null ? 0 : items.length.clamp(0, 1),
                        itemBuilder: (context, index) {
                          final viewItemsInOrder = items[index];

                          return Column(
                            children: [
                              ListTile(
                                dense: true,
                                leading: Text(
                                  "Customer Name",
                                ),
                                title: Center(child: Text("Route")),
                                trailing: Text("Created By"),
                                textColor: Colors.deepOrange,
                              ),
                              ListTile(
                                dense: true,
                                leading: Text(viewItemsInOrder.customerName),
                                title: Center(
                                    child: Text(viewItemsInOrder.routeName)),
                                trailing: Text(viewItemsInOrder.createdBy),
                              ),
                            ],
                          );
                        }),
                  ),
                  Card(
                    // set the margin to zero
                    margin: EdgeInsets.zero,
                    child: FittedBox(
                        fit: BoxFit.fill,
                        child: DataTable(
                            columns: <DataColumn>[
                              DataColumn(
                                label: SizedBox(
                                  width: width * .4,
                                  child: Text(
                                    'Product Name',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .2,
                                  child: Text(
                                    'Qty',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .3,
                                  child: Text(
                                    'Unit Price',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              DataColumn(
                                label: SizedBox(
                                  width: width * .2,
                                  child: Text(
                                    'Amount',
                                    style: TextStyle(
                                        fontStyle: FontStyle.normal,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                            rows: items
                                .map(
                                  (product) => DataRow(
                                    cells: [
                                      DataCell(
                                          Text(
                                            product.productName,
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.black),
                                          ), onTap: () {
                                        showReturnItemPopup(
                                            product.productName,
                                            widget.showOrders.orderNo,
                                            product.productCode,
                                            product.qtyOrdered,
                                            product.unitPrice,
                                            loggedInUserID.toString());
                                      }),
                                      DataCell(
                                        Text(
                                          product.qtyOrdered.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          product.unitPrice.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                      DataCell(
                                        Text(
                                          product.amount.toString(),
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .toList())),
                  ),
                  Card(
                    // set the margin to zero
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      onTap: null,
                      leading: Text(
                        "Total(Kshs): ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      trailing: Text(
                        formatter.format(orderTotalValue).toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      textColor: Colors.red,
                    ),
                  ),
                  Card(
                    // set the margin to zero
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: TextButton.icon(
                        icon: Icon(
                          Icons.restore,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          showFullOrderPopup(widget.showOrders.orderNo);
                        },
                        label: Text(
                          "Return Items",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                      trailing: TextButton.icon(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.blueAccent,
                        ),
                        onPressed: () {
                          showDeletePopup(widget.showOrders.orderNo);
                        },
                        label: Text(
                          "Delete Order",
                          style: TextStyle(color: Colors.deepOrange),
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
