
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';

import '../model/cart_items.dart';

class CartApi {
  static Future<List<FetchCartItems>> fetchCartsData(String usernameParam) async {
    var url = baseUrl+"/get_cart_products";
    //Fetch Data from the server and pass parameter in body
    var response = await http.post(Uri.parse(url),body: {"username":usernameParam});

    if (response.statusCode == 200) {
        //Please always remember this is a map, and is being converted to a list
        final List itemsInCart = List<Map<String, dynamic>>.from(
            json.decode(response.body)['data']);

        //Search from the List View directly
        return itemsInCart.map((json) => FetchCartItems.fromJson(json))
            .toList();

    } else {
      throw Exception("Failed to fetch cart items");
    }
  }
}
