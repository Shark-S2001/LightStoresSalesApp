import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/model/select_customer_data.dart';

class CustomerDropDownApi {
  static Future<List<FetchCustomers>> fetchCustomersData() async {
    var url = baseUrl+"/get_all_customers";
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List customers =
      List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      //Search from the List View directly
      return customers.map((json) => FetchCustomers.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch Customers");
    }
  }
}