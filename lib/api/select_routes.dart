import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:projects/config/globals.dart';
import 'package:projects/model/select_routes.dart';

class RoutesApi {
  static Future<List<FetchAllRoutes>> fetchAllRoutesFromJson() async {
    var url = baseUrl+"/get_all_routes";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      //Please always remember this is a map, and is being converted to a list
      final List routes =
      List<Map<String, dynamic>>.from(json.decode(response.body)['data']);

      return routes.map((json) => FetchAllRoutes.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch routes");
    }
  }
}