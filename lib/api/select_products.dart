import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';

import '../model/products.dart';

class ProductApi {
  static Future<List<FetchProducts>> fetchProductsData(String query) async {
    var url = baseUrl+"/get_all_products";
    var response = await http.post(Uri.parse(url));

    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List products =
          List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      //Search from the List View directly
      return products
          .map((json) => FetchProducts.fromJson(json))
          .where((product) {
        final productLower = product.productName.toLowerCase();
        final searchLower = query.toLowerCase();

        return productLower.contains(searchLower);
      }).toList();
    } else {
      throw Exception("Failed to fetch products");
    }
  }
}
