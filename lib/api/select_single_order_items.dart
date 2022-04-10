
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/model/select_single_order_items.dart';

class SingleOrderItemsApi {
  static Future<List<FetchOrderItems>> fetchOrderItemsFromJson(int orderNumParam) async {
    var url = baseUrl+"/get_order_items";
    //Fetch Data from the server and pass parameter in body
    var response = await http.post(Uri.parse(url),body: {"order_num":"$orderNumParam"});

    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List singleOrderItems = List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      //Search from the List View directly
      return singleOrderItems.map((json) => FetchOrderItems.fromJson(json)).toList();

    } else {
      throw Exception("Failed to fetch order items");
    }
  }
}
