import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlacesService {
  final String key = 'AIzaSyDzA1-HSa2uboihxUX9qfH7fNMZg_Es-_w'; // <- Aquí pon tu API KEY

  Future<List<Place>> searchPlaces(String query, LatLng location) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query+veterinarias&location=${location.latitude},${location.longitude}&radius=1500&key=$key';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final results = json['results'] as List;
      return results.map((place) => Place.fromJson(place)).toList();
    } else {
      throw Exception('Error al buscar lugares');
    }
  }
}

class Place {
  final String name;
  final double lat;
  final double lng;
  final String address;

  Place({required this.name, required this.lat, required this.lng, required this.address});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'],
      lat: json['geometry']['location']['lat'],
      lng: json['geometry']['location']['lng'],
      address: json['formatted_address'] ?? '',
    );
  }
}
