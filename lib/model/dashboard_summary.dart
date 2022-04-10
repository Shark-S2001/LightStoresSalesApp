// To parse this JSON data, do
//
//     final getSalesSummary = getSalesSummaryFromJson(jsonString);

import 'dart:convert';

List<GetSalesSummary> getSalesSummaryFromJson(String str) => List<GetSalesSummary>.from(json.decode(str).map((x) => GetSalesSummary.fromJson(x)));

String getSalesSummaryToJson(List<GetSalesSummary> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSalesSummary {
  GetSalesSummary({
    required this.noofOrders,
    required this.vatTotals,
    required this.orderTotals,
    required this.noofPaidOrders,
    required this.noofCustomers,
  });

  int noofOrders;
  double  vatTotals;
  int orderTotals;
  int noofPaidOrders;
  int noofCustomers;

  factory GetSalesSummary.fromJson(Map<String, dynamic> json) => GetSalesSummary(
    noofOrders: json["NoofOrders"],
    vatTotals: json["vatTotals"],
    orderTotals: json["orderTotals"],
    noofPaidOrders: json["NoofPaidOrders"],
    noofCustomers: json["NoofCustomers"],
  );

  Map<String, dynamic> toJson() => {
    "NoofOrders": noofOrders,
    "vatTotals": vatTotals,
    "orderTotals": orderTotals,
    "NoofPaidOrders": noofPaidOrders,
    "NoofCustomers": noofCustomers,
  };
}
