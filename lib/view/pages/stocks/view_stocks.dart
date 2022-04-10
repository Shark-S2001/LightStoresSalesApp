import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projects/view/pages/stocks/update_product_price.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../api/stocks_api.dart';
import '../../../model/products.dart';
import '../../../shared/search_widget.dart';

class Stocks extends StatefulWidget {
  const Stocks({Key? key}) : super(key: key);

  @override
  _StocksState createState() => _StocksState();
}

class _StocksState extends State<Stocks> {
  bool _state =true;
  bool _isPageReady =true;
  switchStocks() {
    setState(() {
      switch (_state){
        case false:
          _state=true;
        break;
        case true:
          _state=false;
        break;
      }
    });
  }
  List<FetchProducts> products = [];
  String query = '';
  Timer ? debouncer;

  @override
  void initState(){
    super.initState();

    LoadProductsOnPageLoad();
  }
  Future LoadProductsOnPageLoad() async {
    final products = await StocksApi.fetchProductsData(query);

    if(!mounted) return;

    setState(() {
      query = query;
      this.products = products;

      _isPageReady =false;
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


  Future<bool> showPriceChange(final product) async {
    return await showDialog(
      //show confirm dialogue
      //the return value will be from "Yes" or "No" options
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Change Price',
          style: TextStyle(fontSize: 14, color: Colors.deepOrange),
        ),
        content: Text(
          'Confirm action, change price ?',
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          SizedBox(
            height: 30,
            child: ElevatedButton(
              onPressed: () => //call logout User function
              {
              Navigator.of(context).pop(false),
                showModalBottomSheet(
                context: context,
                isScrollControlled: true, builder: (context) => UpdatePrice(suggestion: product,)).whenComplete(() =>  LoadProductsOnPageLoad()),
              },
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text(_state ? 'Stocks Available in Shop' : 'Stocks Available in Store',
          style: TextStyle(
              fontSize: 16,
              color: _state? Colors.white : Colors.yellow,
              fontWeight: FontWeight.bold
          ),),
      ),
      body: RefreshIndicator(
        child: _isPageReady ? Center(child: CircularProgressIndicator()) : Column(
        children: [
          buildSearch(),
          Expanded(child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index){
                final product = products[index];

                return ListTile(
                  leading: Text(product.productName,style: TextStyle(fontSize: 13),),
                  trailing: Text(_state ? product.stock_in_shop.toString() : product.stock_in_store.toString(),style: TextStyle(fontSize: 13)),
                  onTap: () {
                    showPriceChange(product);
                  },
                );

              }))
        ],
      ),
        onRefresh: () {
          return Future.delayed(
            Duration(seconds: 1),
                () {
              setState(() {
                //Call the refresh load customers get data api
                LoadProductsOnPageLoad();
              });

              Fluttertoast.showToast(
                  msg: "Prices refreshed successfully",
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
        height: 50,
        width: 120,
        child: FloatingActionButton.extended(
          onPressed: () => switchStocks(),
          backgroundColor: Colors.deepOrange,
          label: Text(_state ? 'Store Stocks' : 'Shop Stocks',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold
            ),),
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
    final products = await StocksApi.fetchProductsData(query);
    //Used to ignore the dispose state exception
    if (!mounted) return;

    setState(() {
      this.query = query;
      this.products = products;
    });
  });

}




