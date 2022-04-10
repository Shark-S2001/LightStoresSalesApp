
import 'package:flutter/material.dart';
import 'package:projects/api/update_product_price.dart';
import 'package:projects/model/products.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePrice extends StatefulWidget {
  final FetchProducts suggestion;

  const UpdatePrice({Key? key, required this.suggestion}) : super(key: key);

  @override
  _UpdatePriceState createState() => _UpdatePriceState();
}

class _UpdatePriceState extends State<UpdatePrice> {
  TextEditingController priceController = TextEditingController();
  String loggedInUserName = "";
  
  @override
  void initState() {
    super.initState();
    setState(() {
      priceController.text = widget.suggestion.unitPrice.toString();// Setting the initial value for field to be current unit price
    });

    _loadDataFromSession();
  }

  //Load data saved in session
  _loadDataFromSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      loggedInUserName = prefs.getString('loggedInUserName').toString();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    updatePrices(itemCode,itemPrice,username) async{
      await updateProductPrice(itemCode, itemPrice,username,context);
    }

    return   Padding(padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 310,
        child:  Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start, children: [
          Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.close_rounded),
                color: Colors.red,
              )),
          SizedBox(height: 5,),
          Center(child: Visibility(
            child: Text(widget.suggestion.productCode.toString(),
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            visible: false,
          )),
          Center(child: Text(widget.suggestion.productName,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold
            ),)),
          SizedBox(height: 10,),
          Center(child: Text("In Stock:  ${widget.suggestion.stock_in_shop}",
            style: TextStyle(
                color: Colors.deepOrange,
                fontSize: 13,
                fontWeight: FontWeight.bold
            ),)),
          SizedBox(height: 10,),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.25 ,10,width*0.25,0),
            child: TextField(
              controller: priceController,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: "Current Price"
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: SizedBox(
                width: double.infinity, // <-- match_parent
                height: 45,// <-- match-parent
                child: ElevatedButton(onPressed: (){
                  try{
                    //Insert order items in mysql Database
                    updatePrices(widget.suggestion.productCode,double.parse(priceController.text),loggedInUserName);

                    //Close add to modal dialog
                    Navigator.pop(context);
                  } catch(exception){
                    //Close add to modal dialog
                    Navigator.pop(context);
                  }
                },
                  child: Text("Update Price",style: TextStyle(fontSize: 18),),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.deepOrange
                  ),)),
          )

        ]),
      ),
      // translate the FAB up by 30
    );
  }
}
