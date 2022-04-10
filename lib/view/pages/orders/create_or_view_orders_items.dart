import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projects/model/products.dart';
import 'package:projects/view/Dashboard.dart';
import 'package:projects/view/pages/orders/add_to_cart.dart';
import 'package:projects/view/pages/orders/view_cart_items.dart';
import '../../../api/select_products.dart';
import '../../../shared/search_widget.dart';

class SearchProducts extends StatefulWidget {
  const SearchProducts({Key? key}) : super(key: key);

  @override
  _SearchProductsState createState() => _SearchProductsState();
}

class _SearchProductsState extends State<SearchProducts> {
  List<FetchProducts> products = [];
  String query = '';
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          leading: Icon(Icons.create),
          backgroundColor: Colors.deepOrange,
          title: Text("Create an Order",style: TextStyle(fontSize: 16)),
        ),
        body: Column(
          children: [
            buildSearch(),
            Expanded(child: ListView.builder(
              itemCount: products.length,
                itemBuilder: (context, index){
                final product = products[index];

                return ListTile(
                  leading: Text(product.productName),
                  trailing: Text("Ksh:  ${product.unitPrice}"),
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true, builder: (context) => AddToCart(suggestion: product,));
                  },
                );

            }))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          //bottom navigation bar on scaffold
          color: Colors.deepOrange,
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
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => DashboardPage()),
                      ModalRoute.withName('/dashboard'));
                },
                label: Text(
                  "Home",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                icon: Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>const ViewCart()));
                },
                label: Text(
                  "Cart",
                  style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSearch() => SearchWidget(
    text: query,
    hintText: 'Search By Product Name',
    onChanged: SearchProduct,
  );

  //Search products method, this is sent to the server per second
  Future SearchProduct(String query) async => debounce(() async {
    final products = await ProductApi.fetchProductsData(query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      this.query = query;
      this.products = products;
    });
  });
}

