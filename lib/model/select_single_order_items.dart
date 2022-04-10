// To parse this JSON data, do
//
//     final fetchOrderItems = fetchOrderItemsFromJson(jsonString);

import 'dart:convert';

List<FetchOrderItems> fetchOrderItemsFromJson(String str) => List<FetchOrderItems>.from(json.decode(str).map((x) => FetchOrderItems.fromJson(x)));

String fetchOrderItemsToJson(List<FetchOrderItems> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchOrderItems {
  FetchOrderItems({
    required this.customerName,
    required this.productCode,
    required this.productName,
    required this.qtyOrdered,
    required this.unitPrice,
    required this.amount,
    required this.routeName,
    required this.createdBy,
    required this.orderTotals
  });

  String customerName;
  int productCode;
  String productName;
  int qtyOrdered;
  int unitPrice;
  int amount;
  String routeName;
  String createdBy;
  int orderTotals;

  factory FetchOrderItems.fromJson(Map<String, dynamic> json) => FetchOrderItems(
    customerName: json["customer_name"],
    productCode:json["product_code"],
    productName: json["product_name"],
    qtyOrdered: json["qty_ordered"],
    unitPrice: json["unit_price"],
    amount: json["amount"],
    routeName: json["route_name"],
    createdBy: json["createdBy"],
    orderTotals:json["orderTotals"]
  );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "product_code":productCode,
    "product_name": productName,
    "qty_ordered": qtyOrdered,
    "unit_price": unitPrice,
    "amount": amount,
    "route_name": routeName,
    "createdBy": createdBy,
    "orderTotals":orderTotals
  };
}
