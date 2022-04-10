import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:projects/model/cart_items.dart';
import 'package:projects/view/pages/orders/update_item_in_cart.dart';
import '../../../api/delete_item_from_cart.dart';
import '../../../api/select_cart_items.dart';
import '../customers/select_customer_to_complete_order.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ViewCart extends StatefulWidget {
  const ViewCart({Key? key}) : super(key: key);

  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  List<FetchCartItems> items = [];
  double orderTotalValue = 0;
  String loggedInUserName = "";
  var formatter = NumberFormat('#,##,000');
  bool _isDataReady =true;

  @override
  void initState() {
    super.initState();
    _loadDataFromSession();
  }

  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserName = prefs.getString('loggedInUserName').toString();
    });

    //Call the get items after session is loaded
    getItemsFromApi(loggedInUserName);
  }

  getItemsFromApi(String usernameParam) async {
    final cartItems = await CartApi.fetchCartsData(usernameParam);
    //Used to ignore the dispose set state exception
    if (!mounted) return;

      setState(() {
        items = cartItems;
        //initialize and set order total
        orderTotalValue = double.parse(cartItems[0].orderTotals.toString());

        _isDataReady = false;
      });
  }

  //Call delete api method
  deleteProduct(String productCodeParam, String usernameParam) async {
    deleteItemFromCart(productCodeParam, usernameParam);
    //Call the get items after session is loaded
    getItemsFromApi(loggedInUserName);
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.6;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text("View Items in Cart", style: TextStyle(fontSize: 16)),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          child: Center(
            child: _isDataReady ? Padding(
              padding: const EdgeInsets.fromLTRB(0,250,0,0),
              child: Center(child: CircularProgressIndicator(
                semanticsLabel: "Please wait while i fetch your products",
              )),
            ) : Column(
              children: [
                SizedBox(
                    height: 50,
                    child: ListTile(
                      onTap: null,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Product Name"),
                          Text("Unit Price"),
                          Text("Qty"),
                          Text("Amount")
                        ],
                      ),
                      tileColor: Colors.white70,
                      textColor: Colors.red,
                    )),
                SizedBox(
                  height: height,
                  child: ListView.builder(
                      itemCount: items == null ? 0 : items.length,
                      itemBuilder: (context, index) {
                        //Create an instance of data
                        final cartItems = items[index];
                        return Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white70, width: 1),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Slidable(
                            // Specify a key if the Slidable is dismissible.
                            key: UniqueKey(),

                            // The start action pane is the one at the left or the top side.
                            startActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),

                              // A pane can dismiss the Slidable.
                              dismissible: DismissiblePane(onDismissed: () {
                                //Delete method from Api
                                deleteProduct(
                                    cartItems.productCode.toString(), loggedInUserName);
                                getItemsFromApi(loggedInUserName);
                              }),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: doNothing,
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),

                            // The end action pane is the one at the right or the bottom side.
                            endActionPane: ActionPane(
                              // A motion is a widget used to control how the pane animates.
                              motion: const ScrollMotion(),

                              // A pane can dismiss the Slidable.
                              dismissible: DismissiblePane(onDismissed: () {
                                //Delete method from Api
                                showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) => EditCartItem(
                                          suggestion: cartItems,
                                        )).whenComplete(() => getItemsFromApi(loggedInUserName));
                              }),

                              // All actions are defined in the children parameter.
                              children: [
                                // A SlidableAction can have an icon and/or a label.
                                SlidableAction(
                                  onPressed: doNothing,
                                  backgroundColor: Color(0xFF0392CF),
                                  foregroundColor: Colors.white,
                                  icon: Icons.edit,
                                  label: 'Edit',
                                ),
                              ],
                            ),
                            // The child of the Slidable is what the user sees when the
                            // component is not dragged.
                            child: ListTile(
                              dense: true,
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(cartItems.productName),
                                  Text(cartItems.unitPrice.toString()),
                                  Text(cartItems.qty.toString()),
                                  Text(formatter
                                      .format(double.parse(cartItems.amount.toString()))),
                                ],
                              ),
                              selectedTileColor: Colors.blue,
                            ),
                          ),
                        );
                      }),
                ),
                ListTile(
                  onTap: null,
                  leading: Text(
                    "Total(Kshs): ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  trailing: Text(
                    formatter.format(orderTotalValue).toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  textColor: Colors.red,
                )
              ],
            ),
          ),
          // user pulls the ListView downward
          onRefresh: () {
            return Future.delayed(
              Duration(seconds: 1),
              () {
                setState(() {
                  //Call the refresh load order items data api
                  getItemsFromApi(loggedInUserName);
                });

                Fluttertoast.showToast(
                    msg: "Order refreshed successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.pink,
                    textColor: Colors.white,
                    fontSize: 16.0);
              },
            );
          },
        ),
      ),
      floatingActionButton: SizedBox(
        height: 50,
        width: 120,
        child: FloatingActionButton.extended(
          onPressed: () => {
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    scrollable: true,
                    content: Stack(
                      clipBehavior: Clip.none,
                      children: <Widget>[
                        Positioned(
                          right: -10.0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Align(
                              alignment: Alignment.topRight,
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundColor: Colors.white,
                                child:
                                    Icon(Icons.close, color: Colors.deepOrange),
                              ),
                            ),
                          ),
                        ),
                        //Form will come here
                        SelectCustomer()
                      ],
                    ),
                  );
                })
          },
          backgroundColor: Colors.deepOrange,
          label: Align(
            alignment: Alignment.bottomCenter,
            child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0,
                children: const [
                  Icon(
                    Icons.save_rounded,
                    size: 16,
                  ),
                  Text("Checkout",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center),
                ]),
          ),
        ),
      ),
    );
  }
}

void doNothing(BuildContext context) {}
