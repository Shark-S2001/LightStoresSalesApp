// To parse this JSON data, do
//
//     final fetchCartItems = fetchCartItemsFromJson(jsonString);

import 'dart:convert';

List<FetchCartItems> fetchCartItemsFromJson(String str) => List<FetchCartItems>.from(json.decode(str).map((x) => FetchCartItems.fromJson(x)));

String fetchCartItemsToJson(List<FetchCartItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchCartItems {
  FetchCartItems({
    required this.productCode,
    required this.productName,
    required this.qty,
    required this.unitPrice,
    required this.amount,
    required this.orderTotals
  });

  int productCode;
  String productName;
  int qty;
  int unitPrice;
  int amount;
  int orderTotals;

  factory FetchCartItems.fromJson(Map<String, dynamic> json) => FetchCartItems(
    productCode: json["product_code"],
    productName: json["product_name"],
    qty: json["qty"],
    unitPrice: json["unit_price"],
    amount: json["amount"],
    orderTotals: json["orderTotals"],
  );

  Map<String, dynamic> toJson() => {
    "product_code" : productCode,
    "product_name": productName,
    "qty": qty,
    "unit_price": unitPrice,
    "amount": amount,
    "orderTotals": orderTotals,
  };
}
