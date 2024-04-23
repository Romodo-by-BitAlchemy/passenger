import 'dart:ffi';
import '../server_conn.dart' as server_conn;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

//TODO: set the initial map camera to show the selected company location (i.e. trip start point)
//TODO: display the line on the map from the company location to the selected destination

// Google Maps API key
const kGoogleApiKey = "AIzaSyCFMvP08hl6J9yIcJoPoCm7Tioqb2L3Kcw";

// Initialize Google Maps Places API
final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

/// The page for booking a trip.
class BookTripPage extends StatefulWidget {
  const BookTripPage({Key? key}) : super(key: key);

  @override
  BookTripPageState createState() => BookTripPageState();
}

/// The state of the [BookTripPage].
class BookTripPageState extends State<BookTripPage> {
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Search field with custom suggestions
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _fetchPlaceSuggestions(textEditingValue.text);
            },
            displayStringForOption: (option) => option,
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                onFieldSubmitted: (value) => _handlePlaceSelection(value),
                decoration: InputDecoration(
                  hintText: "Enter destination",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            onSelected: (option) => _handlePlaceSelection(option),
          ),
        ),
        SizedBox(
          height: 0.6 *
              (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(6.9271, 79.8612),
              zoom: 16,
            ),
            mapType: MapType.normal,
            markers: _markers,
            zoomControlsEnabled: false,
            fortyFiveDegreeImageryEnabled: true,
          ),
        ),
        ElevatedButton(
          onPressed: _submitTripRequest,
          child: const Text("Request Trip"),
        ),
      ],
    );
  }

  void _submitTripRequest() {
    server_conn.fetchServerData();
  }

  /// Callback when the Google Map is created.
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  /// Fetches place suggestions based on the given query.
  Future<Iterable<String>> _fetchPlaceSuggestions(String query) async {
    final results = await places.autocomplete(
      query,
      components: [Component(Component.country, "lk")], // Restrict to Sri Lanka
    );
    return results.predictions.map((p) => p.description ?? '').toList();
  }

  /// Fetches the place ID for the given query.
  Future<String> _fetchPlaceID(String query) async {
    final searchMatches = await places.searchByText(
      query,
    );
    return searchMatches.results.first.placeId.toString();
  }

  /// Handles the selection of a place.
  void _handlePlaceSelection(String option) async {
    try {
      String placeId = await _fetchPlaceID(option);
      var detail = await places.getDetailsByPlaceId(placeId.toString().trim());

      if (detail.result == null ||
          detail.result.geometry == null ||
          detail.result.geometry!.location == null) {
        throw Exception('Received incomplete data from Places API');
      }

      final lat = detail.result.geometry!.location!.lat;
      final lng = detail.result.geometry!.location!.lng;

      // Use the lat, lng, and any other required data directly!
      final position = LatLng(lat, lng);
      setState(() {
        _markers.clear();
        _markers.add(Marker(
          markerId: MarkerId(placeId),
          position: position,
        ));
        _markers.add(Marker(
          markerId: const MarkerId('current-location'),
          position: position,
        ));
        mapController?.animateCamera(CameraUpdate.newLatLng(position));
      });
    } catch (e) {
      print('Error: $e');
    }
  }
}
