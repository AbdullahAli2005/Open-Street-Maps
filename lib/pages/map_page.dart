import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cancellable_tile_provider/flutter_map_cancellable_tile_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FreeMapScreen extends StatefulWidget {
  const FreeMapScreen({super.key});

  @override
  State<FreeMapScreen> createState() => _FreeMapScreenState();
}

class _FreeMapScreenState extends State<FreeMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  final List<Marker> markers = [];
  List<LatLng> routePoints = [];

  LatLng? startPoint;
  LatLng? endPoint;

  // OpenRouteService API Key (Replace with your actual key)
  final String apiKey = dotenv.env['OPENROUTESERVICE_API_KEY'] ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Open Street Map"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _clearAllMarkers, 
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search location...",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _searchLocation,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onSubmitted: (_) => _searchLocation(),
            ),
          ),
          // Map
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(24.8607, 67.0011), 
                initialZoom: 13.0,
                onTap: (tapPosition, point) {
                  _setRouteMarkers(point);
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  tileProvider: CancellableNetworkTileProvider(),
                ),
                if (routePoints.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 5.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),
                MarkerLayer(markers: markers),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _searchLocation() async {
    String query = _searchController.text.trim();
    if (query.isEmpty) return;

    String url = "https://nominatim.openstreetmap.org/search?q=$query&format=json";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        List data = json.decode(response.body);
        if (data.isNotEmpty) {
          double lat = double.parse(data[0]["lat"]);
          double lon = double.parse(data[0]["lon"]);

          _mapController.move(LatLng(lat, lon), 13.0);

          setState(() {
            markers.add(
              Marker(
                point: LatLng(lat, lon),
                width: 40,
                height: 40,
                child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
              ),
            );
          });
        } else {
          _showSnackbar("Location not found");
        }
      } else {
        _showSnackbar("Error fetching location");
      }
    } catch (e) {
      _showSnackbar("Something went wrong");
    }
  }

  void _setRouteMarkers(LatLng point) {
    setState(() {
      if (startPoint == null) {
        startPoint = point;
        markers.add(
          Marker(
            point: point,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: Colors.green, size: 40),
          ),
        );
      } else if (endPoint == null) {
        endPoint = point;
        markers.add(
          Marker(
            point: point,
            width: 40,
            height: 40,
            child: const Icon(Icons.location_pin, color: Colors.red, size: 40),
          ),
        );
        _fetchRoute();
      } else {
        _clearAllMarkers();
      }
    });
  }

  // Fetch Route from OpenRouteService
  Future<void> _fetchRoute() async {
    if (startPoint == null || endPoint == null) return;

    String url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${startPoint!.longitude},${startPoint!.latitude}&end=${endPoint!.longitude},${endPoint!.latitude}";

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        List coordinates = data["routes"][0]["geometry"]["coordinates"];

        setState(() {
          routePoints = coordinates
              .map((coord) => LatLng(coord[1], coord[0])) // Convert to LatLng
              .toList();
        });
      } else {
        _showSnackbar("Failed to fetch route");
      }
    } catch (e) {
      _showSnackbar("No route found. Try different route");
      print(null);
    }
  }

  // Clear All Markers and Route
  void _clearAllMarkers() {
    setState(() {
      markers.clear();
      routePoints.clear();
      startPoint = null;
      endPoint = null;
    });
  }

  // Show Snackbar Message
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

