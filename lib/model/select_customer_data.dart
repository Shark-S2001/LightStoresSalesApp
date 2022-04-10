// To parse this JSON data, do
//
//     final fetchCustomers = fetchCustomersFromJson(jsonString);

import 'dart:convert';

List<FetchCustomers> fetchCustomersFromJson(String str) => List<FetchCustomers>.from(json.decode(str).map((x) => FetchCustomers.fromJson(x)));

String fetchCustomersToJson(List<FetchCustomers> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchCustomers {
  FetchCustomers({
    required this.customerNum,
    required this.customerName,
    required this.phoneNumber,
    required this.town,
    required this.routeName,
    required this.createdBy,
  });

  int customerNum;
  String customerName;
  String phoneNumber;
  String town;
  String routeName;
  String createdBy;

  factory FetchCustomers.fromJson(Map<String, dynamic> json) => FetchCustomers(
    customerNum: json["customer_num"],
    customerName: json["customer_name"],
    phoneNumber: json["phone_number"],
    town: json["town"],
    routeName: json["route_name"],
    createdBy: json["createdBy"],
  );

  Map<String, dynamic> toJson() => {
    "customer_num": customerNum,
    "customer_name": customerName,
    "phone_number": phoneNumber,
    "town": town,
    "route_name": routeName,
    "createdBy": createdBy,
  };
}
