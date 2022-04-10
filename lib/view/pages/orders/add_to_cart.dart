import 'package:flutter/material.dart';
import 'package:projects/model/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../api/add_item_to_cart.dart';

class AddToCart extends StatefulWidget {
  final FetchProducts suggestion;

  const AddToCart({Key? key, required this.suggestion}) : super(key: key);

  @override
  State<AddToCart> createState() => _AddToCartState();
}

class _AddToCartState extends State<AddToCart> {
  TextEditingController qtyController = TextEditingController();
  String loggedInUserName = "";

  @override
  void initState() {
    super.initState();
    qtyController.text = "1"; // Setting the initial value for the field.
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

    insertOrderItems(itemCode,qtyBought,itemPrice,itemVat,lineTotal,username) async{
      await addNewItemToCart(itemCode, qtyBought, itemPrice, itemVat, lineTotal,username);
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
          Center(child: Text("Ksh: ${widget.suggestion.unitPrice}",
            style: TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold
            ),)),
          Padding(
            padding: EdgeInsets.fromLTRB(width * 0.25 ,10,width*0.25,0),
            child: TextField(
              controller: qtyController,
              autofocus: true,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    var newValue = int.parse(qtyController.text)-1;
                    setState(() {
                      //Check that value is not less than 1, to avoid negative
                      if(newValue !=0) {
                        qtyController.text = (newValue).toString();
                      }
                    });
                  },
                  icon: const Icon(Icons.remove_circle_outline),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    int newValue=1;
                    newValue = int.parse(qtyController.text)+1;
                    setState(() {
                      qtyController.text = (newValue).toString();
                    });
                  },
                  icon: const Icon(Icons.add),
                ),
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
                      //Calculate line total and vat total
                      double line_total = double.parse(widget.suggestion.unitPrice.toString()) * double.parse(qtyController.text);
                      double vat_total = double.parse(widget.suggestion.unitPrice.toString())* 0.16 *double.parse(qtyController.text);//Vat to come from session

                      //Insert order items in mysql Database
                      insertOrderItems(widget.suggestion.productCode,double.parse(qtyController.text),double.parse(widget.suggestion.unitPrice.toString()),vat_total,line_total,loggedInUserName);

                      //Close add to modal dialog
                      Navigator.pop(context);
                    } catch(exception){
                      //Close add to modal dialog
                      Navigator.pop(context);
                    }
                  },
                  child: Text("Add to Cart",style: TextStyle(fontSize: 18),),
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
