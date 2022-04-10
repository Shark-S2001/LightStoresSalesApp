import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projects/view/pages/customers/view_customers.dart';
import 'package:projects/view/pages/orders/create_or_view_orders_items.dart';
import 'package:projects/view/pages/orders/view_cart_items.dart';
import 'package:projects/view/pages/orders/view_order_history.dart';
import 'package:projects/view/pages/orders/view_order_items.dart';
import 'package:projects/view/pages/stocks/view_stocks.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/select_recent_orders.dart';
import '../api/select_sales_summary.dart';
import '../model/dashboard_summary.dart';
import '../model/select_recent_orders.dart';
import 'logout.dart';
import 'package:basic_utils/basic_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  //Defining Global key used to open drawer programmatically
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  bool isReady = true;
  String loggedInUsername = "";
  int loggedInUserId = 0;
  String greetingMes = "";
  List<FetchRecentOrders> recentOrdersList = [];
  List<GetSalesSummary> summaryItems = [];
  String query ="";


  @override
  void initState() {
    super.initState();
    greetingMes = greeting();

    setState(() {
      _loadDataFromSession();
    });
    }

  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      loggedInUsername = (prefs.getString('loggedInUserName') ?? '');
      loggedInUserId = int.parse(prefs.getInt('loggedInUserId').toString());
    });

    getSummaryFromApi(loggedInUserId.toString());
  }

  //Refresh the Dashboard after 1 second
  getRecentOrdersFromApi(String loggedInUserId,String query) async {
    final recentOrdersData =
        await RecentOrdersApi.fetchRecentOrdersData(loggedInUserId,query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      recentOrdersList = recentOrdersData;
    });
  }

  //Refresh the Dashboard after 1 second
  getSummaryFromApi(String loggedInUserId) async {
    final salesSumItems = await SalesSummaryApi.fetchSalesData(loggedInUserId);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      summaryItems = salesSumItems;

      //Change the state when api loading is done
      isReady = false;
    });

    getRecentOrdersFromApi(loggedInUserId.toString(),query);
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

  Future<bool> showExitPopup() async {
    return await showDialog(
          //show confirm dialogue
          //the return value will be from "Yes" or "No" options
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Exit App',
              style: TextStyle(fontSize: 14, color: Colors.deepOrange),
            ),
            content: Text(
              'Are you sure you want to exit the app ?',
              style: TextStyle(fontSize: 13),
            ),
            actions: [
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () => //call logout User function
                    logoutUser(context),
                  //return true when click on "Yes"
                  child: Text(
                    'Yes',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(primary: Colors.deepOrange),
                ),
              ),
              SizedBox(
                height: 30,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  //return false when click on "NO"
                  child: Text(
                    'No',
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
    return WillPopScope(
      onWillPop: showExitPopup,
      child: Scaffold(
        //setting Global key used to open drawer programmatically
        key: _key,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(100.0),
            child: Column(
              children: [
                AppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    // Navigation bar
                    statusBarColor: Colors.deepOrange, // Status bar
                  ),
                  leading: IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {
                      _key.currentState!.openDrawer();
                    },
                  ),
                  backgroundColor: Colors.deepOrange,
                  title: Text(
                    'Dashboard',
                    style: TextStyle(fontSize: 16),
                  ),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  actions: <Widget>[
                    PopupMenuButton<int>(
                      offset: Offset(0, 50),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Image.asset(
                          'images/user.png',
                          fit: BoxFit.contain, // Fixes border issues
                          width: 30.0,
                          height: 20.0,
                        ),
                      ),
                      onSelected: (item) => onSelected(context, item),
                      itemBuilder: (context) => [
                        PopupMenuItem<int>(value: 0, child: Text('My Profile')),
                        PopupMenuItem<int>(
                            value: 1, child: Text('Change Password')),
                        PopupMenuItem<int>(value: 2, child: Text('Logout')),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                    height: 30,
                    child: Center(
                        child: Text(
                      "$greetingMes " +
                          StringUtils.capitalize(loggedInUsername) +
                          ".",
                      style: TextStyle(fontSize: 16, color: Colors.deepOrange),
                    )))
              ],
            )),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: RefreshIndicator(
            child: GestureDetector(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        //Check if data is loaded completly from api
                        isReady
                            ? const Padding(
                                padding: EdgeInsets.fromLTRB(0, 250, 0, 0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Center(
                                          child: SizedBox(
                                              height: 350,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.95,
                                              child: Card(
                                                //call the summary Tabs widget
                                                child: summaryTabs(context),
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        height: 65,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 12, 0),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  child: Card(
                                                    child: TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          OrderHistory())).whenComplete(() => getSummaryFromApi(loggedInUserId.toString()));
                                                        },
                                                        icon:
                                                            Icon(Icons.history),
                                                        label: Text(
                                                            "Order History",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrange,fontSize: 12))),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.30,
                                                  child: Card(
                                                    child: TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          Stocks()));
                                                        },
                                                        icon: Icon(Icons
                                                            .format_align_justify),
                                                        label: Text(
                                                          "View Stocks",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .deepOrange,
                                                          fontSize: 12),
                                                        )),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 70,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.33,
                                                  child: Card(
                                                    child: TextButton.icon(
                                                        onPressed: () {
                                                          Navigator.push(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          DisplayAvailableCustomers())).whenComplete(() => getSummaryFromApi(loggedInUserId.toString()));
                                                        },
                                                        icon: Icon(Icons
                                                            .person_search),
                                                        label: Text("Customers",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .deepOrange,
                                                            fontSize: 12))),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.5,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.95,
                                          child: Card(
                                              child: recentOrders(context)),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
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
                    getRecentOrdersFromApi(loggedInUserId.toString(),query);
                    getSummaryFromApi(loggedInUserId.toString());
                  });

                  Fluttertoast.showToast(
                      msg: "Page refreshed successfully",
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
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width *0.7,
          child: Drawer(
            // space to fit everything.
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.18,
                  child: const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepOrange,
                    ),
                    child: Text(
                      'LightStores',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Update Shop Prices'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.store,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Stock taking'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.approval,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Approve Order'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.shopping_cart,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('View Cart'),
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder:
                                (context) =>
                                ViewCart())).whenComplete(() => getSummaryFromApi(loggedInUserId.toString()));

                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.settings,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Settings'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.logout,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Logout'),
                  onTap: () {
                    Navigator.pop(context);
                    //call logout User function
                    logoutUser(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.cancel,
                    color: Colors.deepOrange,
                  ),
                  title: const Text('Exit'),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.pop(context);

                    //call logout User function
                    logoutUser(context);
                    //Exit the app completly
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            //Floating action button on Scaffold
            onPressed: () {
              //code to execute on button press
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchProducts())).whenComplete(() => _loadDataFromSession);
            },
            child: Icon(
              Icons.add_shopping_cart_sharp,
              color: Colors.white,
            )
            //icon inside button
            ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //floating action button position to center

        bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.deepOrange,
          shape: CircularNotchedRectangle(), //shape of notch
          notchMargin:
              5, //notche margin between floating button and bottom appbar
          child: Row(
            //children inside bottom appbar
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton.icon(
                icon: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  "Home",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.whatsapp_rounded,
                  color: Colors.white,
                ),
                onPressed: () {},
                label: Text(
                  "W-Orders",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//implementing popup menu Click
  onSelected(BuildContext context, int item) {
    switch (item) {
      case 0:
        print("Profile clicked");
        break;
      case 1:
        print("Change Password clicked");
        break;
      case 2:
        //call logout User function
        logoutUser(context);
        break;
    }
  }

  //Implementing recent orders widget
  Widget recentOrders(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
            dense: true,
            onTap: null,
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Recent Orders",
                style: TextStyle(
                  color: Colors.deepOrange,
                  decoration: TextDecoration.underline,
                ),
              ),
            )),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ListView.builder(
              itemCount: recentOrdersList == null
                  ? 0
                  : recentOrdersList.length.clamp(0, 11),
              itemBuilder: (BuildContext context, index) {
                final showOrders = recentOrdersList[index];

                return ListTile(
                  dense: true,
                  title: Text(showOrders.customerName == null
                      ? 'Default Value'
                      : showOrders.customerName),
                  trailing: Text(showOrders.orderTotals == null
                      ? 'Default Value'
                      : "${showOrders.orderTotals} /-"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                OrderItems(showOrders: showOrders))).whenComplete(() => _loadDataFromSession);
                  },
                );
              }),
        ),
      ],
    );
  }

  //Implementing summary tabs widget
  Widget summaryTabs(BuildContext context) {
    final GetSalesSummary dataSummary;

    dataSummary = summaryItems[0];

    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Color.fromRGBO(250, 250, 235, 0),
          title: TabBar(
            tabs: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: Tab(
                  child: Text(
                    "Daily",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Tab(
                  child: Text(
                    "Weekly",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Tab(
                  child: Text(
                    "Monthly",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SizedBox(
          child: TabBarView(
            children: <Widget>[
              Container(
                child: tab1Container(dataSummary: dataSummary),
              ),
              Center(
                child: Text("Weekly Sales Summary"),
              ),
              Center(
                child: Text("Monthly Sales Summary"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //Implementing tabs containers
  Widget tab1Container({required GetSalesSummary dataSummary}) {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat(' dd-MM-yyyy - kk:mm').format(now);
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    alignment: FractionalOffset(1.0, 0.0),
                    child: Wrap(
                      children: [
                        Icon(Icons.arrow_back_ios),
                        Text('  Today  ',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: 'Roboto',
                              color: Colors.black,
                            )),
                        Icon(Icons.arrow_forward_ios),
                      ],
                    )),
              ],
            ),
          ),
          Text("\n $formattedDate",
              style: TextStyle(
                  fontSize: 11.5, fontFamily: 'Roboto', color: Colors.black54)),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Center(
                                    child: Text(
                                        dataSummary.orderTotals == ""
                                            ? "0"
                                            : 'Ksh: ${dataSummary.orderTotals} ',
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('Gross Sales'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Center(
                                    child: Text(dataSummary.noofOrders.toString(),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('No of Orders'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: SizedBox(
                  child: Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Center(
                                    child: Text(dataSummary.noofCustomers.toString(),
                                        style: TextStyle(
                                          fontSize: 17.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('No of Customers'),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Card(
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 50,
                                  width:
                                      MediaQuery.of(context).size.width * 0.41,
                                  child: Center(
                                    child: Text(
                                        dataSummary.noofPaidOrders == ""
                                            ? "0"
                                            : '\Kshs: ${dataSummary.noofPaidOrders}',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: 'Roboto',
                                          color: Colors.deepOrange,
                                        )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text('Paid Orders Total'),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
