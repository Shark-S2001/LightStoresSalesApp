// To parse this JSON data, do
//
//     final fetchAllRoutes = fetchAllRoutesFromJson(jsonString);

import 'dart:convert';

List<FetchAllRoutes> fetchAllRoutesFromJson(String str) => List<FetchAllRoutes>.from(json.decode(str).map((x) => FetchAllRoutes.fromJson(x)));

String fetchAllRoutesToJson(List<FetchAllRoutes> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FetchAllRoutes {
  FetchAllRoutes({
    required this.id,
    required this.routeName,
  });

  int id;
  String routeName;

  factory FetchAllRoutes.fromJson(Map<String, dynamic> json) => FetchAllRoutes(
    id: json["id"],
    routeName: json["route_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "route_name": routeName,
  };
}
