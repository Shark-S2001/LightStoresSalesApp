// To parse this JSON data, do
//
//     final fetchProducts = fetchProductsFromJson(jsonString);

import 'dart:convert';

List<FetchProducts> fetchProductsFromJson(String str) => List<FetchProducts>.from(json.decode(str).map((x) => FetchProducts.fromJson(x)));

String fetchProductsToJson(List<FetchProducts> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchProducts {
  FetchProducts({
    required this.productCode,
    required this.productName,
    required this.stock_in_shop,
    required this.stock_in_store,
    required this.unitPrice,
  });

  int productCode;
  String productName;
  String stock_in_shop;
  String stock_in_store;
  int unitPrice;

  factory FetchProducts.fromJson(Map<String, dynamic> json) => FetchProducts(
    productCode: json["product_code"],
    productName: json["product_name"],
    stock_in_shop: json["stock_in_shop"],
    stock_in_store: json["stock_in_store"],
    unitPrice: json["unit_price"]
  );

  Map<String, dynamic> toJson() => {
    "product_code": productCode,
    "product_name": productName,
    "stock_in_shop":stock_in_shop,
    "stock_in_store":stock_in_store,
    "unit_price":unitPrice
  };
}

