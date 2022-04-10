import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/model/dashboard_summary.dart';

class SalesSummaryApi {
  static Future<List<GetSalesSummary>> fetchSalesData(String loggedInUserId) async {
    var url = baseUrl+"/get_sales_summary";
    var response = await http.post(Uri.parse(url),body: {
      "user_id": loggedInUserId
    });

    print(response.body);
    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List salesSummary =
      List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      //Search from the List View directly
      return salesSummary.map((json) => GetSalesSummary.fromJson(json)).toList();

    } else {
      throw Exception("Failed to fetch sales summary");
    }
  }
}
