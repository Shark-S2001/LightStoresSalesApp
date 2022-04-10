import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/model/select_recent_orders.dart';

class RecentOrdersApi {
  static Future<List<FetchRecentOrders>> fetchRecentOrdersData(String loggedInUserId,String query) async {
    var url = baseUrl+"/get_recent_orders";
    var response = await http.post(Uri.parse(url),body:{"user_id":loggedInUserId});

    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List recentOrders =
      List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      return recentOrders.map((json) => FetchRecentOrders.fromJson(json)).where((customer) {
        final customerLower = customer.customerName.toLowerCase();
        final searchLower = query.toLowerCase();

        return customerLower.contains(searchLower);
      }).toList();

    } else {
      throw Exception("Failed to fetch orders");
    }
  }
}
