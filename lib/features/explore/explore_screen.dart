import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

const _apiKey = String.fromEnvironment('MAPS_API_KEY');

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  GoogleMapController? _mapController;
  final _searchController = TextEditingController();
  List<dynamic> _predictions = [];
  Timer? _debounce;
  Set<Marker> _markers = {};
  double? _selectedLat;
  double? _selectedLng;
  String? _selectedName;

  Future<void> _onSearchChanged(String value) async {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (value.isEmpty || value.length < 3) {
        setState(() => _predictions = []);
        return;
      }

      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json'
          '?input=${Uri.encodeComponent(value)}'
          '&language=th'
          '&key=$_apiKey'
          '&components=country:th'); // Restrict to Thailand

      final response = await http.get(url);
      final data = jsonDecode(response.body);
      setState(() => _predictions = data['predictions'] as List<dynamic>);
    });
  }

  Future<void> _onPlaceSelected(dynamic prediction) async {
    final placeId = prediction['place_id'];
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json'
        '?place_id=$placeId'
        '&fields=geometry,name'
        '&key=$_apiKey');

    final response = await http.get(url);
    final data = jsonDecode(response.body);
    final location = data['result']['geometry']['location'];

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(location['lat'], location['lng']),
        15,
      ),
    );

    setState(() {
      _predictions = [];
      _searchController.text = prediction['description'];
      _markers = {
        Marker(
          markerId: const MarkerId('selected_place'),
          position: LatLng(location['lat'], location['lng']),
          infoWindow: InfoWindow(title: prediction['structured_formatting']['main_text']),
        ),
      };
      _selectedLat = location['lat'];
      _selectedLng = location['lng'];
      _selectedName = prediction['structured_formatting']['main_text'];
    });
  }

  Future<void> _openInGoogleMaps(double lat, double lng, String name) async {
    final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$name');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            initialCameraPosition: const CameraPosition(
              target: LatLng(13.7563, 100.5018), // Bangkok coordinates
              zoom: 10,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'Search for a place',
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),

                if (_selectedLat != null && _selectedLng != null && _selectedName != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openInGoogleMaps(_selectedLat!, _selectedLng!, _selectedName!),
                        icon: const Icon(Icons.directions),
                        label: const Text('Open in Google Maps'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          // foregroundColor: const Color.fromARGB(255, 19, 160, 94),
                          // backgroundColor: const Color.fromARGB(255, 243, 254, 216),
                          foregroundColor: Theme.of(context).colorScheme.onSurface,
                          backgroundColor: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),

                if (_predictions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: _predictions.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final prediction = _predictions[index];
                        return ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: Text(prediction['structured_formatting']['main_text']),
                          subtitle: Text(prediction['structured_formatting']['secondary_text']),
                          onTap: () => _onPlaceSelected(prediction),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ],
      )
    );
  }
}