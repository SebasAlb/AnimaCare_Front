import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:animacare_front/presentation/screens/map/places_service.dart';
import 'package:animacare_front/presentation/components/custom_navbar.dart';
import 'package:animacare_front/routes/app_routes.dart';

class MapScreen extends StatelessWidget {
  final Completer<GoogleMapController> _controller = Completer();
  final TextEditingController _searchController = TextEditingController();
  final PlacesService _placesService = PlacesService();
  final ValueNotifier<LatLng> _initialPosition = ValueNotifier(LatLng(-0.1807, -78.4678));
  final ValueNotifier<List<Place>> _places = ValueNotifier([]);

  MapScreen({super.key}) {
    _initLocation();
  }

  void _initLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }

      if (permission == LocationPermission.deniedForever) return;

      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _initialPosition.value = LatLng(position.latitude, position.longitude);

      final controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_initialPosition.value));
    } catch (e) {
      debugPrint('Ubicación no disponible: $e');
    }
  }

  void _searchPlaces(String query) async {
    try {
      final places = await _placesService.searchPlaces(query, _initialPosition.value);
      _places.value = places;
    } catch (e) {
      debugPrint('Error al buscar lugares: $e');
    }
  }

  Future<void> _moveToLocation(LatLng location) async {
    final controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newLatLngZoom(location, 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Stack(
        children: [
          ValueListenableBuilder(
            valueListenable: _initialPosition,
            builder: (context, value, _) => GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(target: value, zoom: 14.0),
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: (controller) => _controller.complete(controller),
            ),
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
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
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
                    onSubmitted: _searchPlaces,
                  ),
                ),
                ValueListenableBuilder<List<Place>>(
                  valueListenable: _places,
                  builder: (context, places, _) => places.isEmpty
                      ? SizedBox.shrink()
                      : Container(
                    margin: EdgeInsets.only(top: 10),
                    padding: EdgeInsets.all(10),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      itemCount: places.length,
                      itemBuilder: (context, index) {
                        final place = places[index];
                        return ListTile(
                          leading: Icon(Icons.location_on, color: Colors.red),
                          title: Text(place.name),
                          subtitle: Text(place.address),
                          onTap: () {
                            _moveToLocation(LatLng(place.lat, place.lng));
                            _places.value = [];
                            _searchController.clear();
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomNavBar( // <-- AQUÍ, FUERA DEL BODY
        currentIndex: 1,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, AppRoutes.calendar);
              break;
            case 1:
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.homeOwner);
              break;
            case 3:
              break;
          }
        },
      ),
    );
  }
}