import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'places_service.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  LatLng _initialPosition = LatLng(-0.1807, -78.4678); // Quito
  TextEditingController _searchController = TextEditingController();
  final PlacesService _placesService = PlacesService();
  List<Place> _places = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLng(_initialPosition));
  }

  Future<void> _searchPlaces(String query) async {
    try {
      final places = await _placesService.searchPlaces(query, _initialPosition);
      setState(() {
        _places = places;
      });
    } catch (e) {
      print('Error al buscar lugares: $e');
    }
  }

  Future<void> _moveToLocation(LatLng location) async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 14.0,
            ),
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Positioned(
            top: 50,
            left: 15,
            right: 15,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar veterinaria',
                      prefixIcon: Icon(Icons.search),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    ),
                    onSubmitted: (value) {
                      _searchPlaces(value);
                    },
                  ),
                ),
                if (_places.isNotEmpty)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: _places.length,
                      itemBuilder: (context, index) {
                        final place = _places[index];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.red),
                          title: Text(place.name),
                          subtitle: Text(place.address),
                          onTap: () {
                            _moveToLocation(LatLng(place.lat, place.lng));
                            setState(() {
                              _places = [];
                              _searchController.clear();
                            });
                          },
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.location_on, color: Colors.red),
                    onPressed: _getCurrentLocation,
                  ),
                  IconButton(
                    icon: Icon(Icons.favorite, color: Colors.pink),
                    onPressed: () {
                      // Favoritos
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.pets, color: Colors.blue),
                    onPressed: () {
                      // Detalles
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.star, color: Colors.amber),
                    onPressed: () {
                      // Recomendaciones
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
