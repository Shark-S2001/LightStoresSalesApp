// To parse this JSON data, do
//
//     final fetchRecentOrders = fetchRecentOrdersFromJson(jsonString);

import 'dart:convert';

List<FetchRecentOrders> fetchRecentOrdersFromJson(String str) => List<FetchRecentOrders>.from(json.decode(str).map((x) => FetchRecentOrders.fromJson(x)));

String fetchRecentOrdersToJson(List<FetchRecentOrders> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchRecentOrders {
  FetchRecentOrders({
    required this.orderNo,
    required this.customerName,
    required this.orderTotals,
    required this.statusName,
    required this.createdBy,
  });

  int orderNo;
  String customerName;
  int orderTotals;
  String statusName;
  String createdBy;

  factory FetchRecentOrders.fromJson(Map<String, dynamic> json) => FetchRecentOrders(
    orderNo: json["order_no"],
    customerName: json["customer_name"],
    orderTotals: json["orderTotals"],
    statusName: json["status_name"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "order_no": orderNo,
    "customer_name": customerName,
    "orderTotals": orderTotals,
    "status_name": statusName,
    "createdBy": createdBy,
  };
}
