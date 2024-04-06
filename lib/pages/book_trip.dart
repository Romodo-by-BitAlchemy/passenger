import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyCFMvP08hl6J9yIcJoPoCm7Tioqb2L3Kcw";
final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class BookTripPage extends StatefulWidget {
  const BookTripPage({super.key});

  @override
  BookTripPageState createState() => BookTripPageState();
}

class BookTripPageState extends State<BookTripPage> {
  GoogleMapController? mapController;
  TextEditingController _searchController = TextEditingController();
  Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Search field with custom suggestions
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Autocomplete<String>(
            optionsBuilder: (textEditingValue) {
              if (textEditingValue.text.isEmpty) {
                return const Iterable<String>.empty();
              }
              return _fetchPlaceSuggestions(textEditingValue.text);
            },
            displayStringForOption: (option) => option,
            fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
              _searchController = controller;
              return TextFormField(
                controller: controller,
                focusNode: focusNode,
                onFieldSubmitted: (value) => onSubmitted(),
                decoration: InputDecoration(
                  hintText: "Enter destination",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            onSelected: (option) {
              _handlePlaceSelection(option);
            },
          ),
        ),
        SizedBox(
          height: 0.4 *
              (MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom),
          child: GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
              target: LatLng(6.9271, 79.8612),
              zoom: 10,
            ),
            mapType: MapType.normal,
            markers: _markers,
          ),
        )
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<Iterable<String>> _fetchPlaceSuggestions(String query) async {
    final results = await places.autocomplete(
      query,
      components: [Component(Component.country, "lk")], // Restrict to Sri Lanka
    );
    return results.predictions.map((p) => p.description ?? '').toList();
  }

  void _handlePlaceSelection(String selection) async {
    // Get details of the selected place
    PlacesDetailsResponse detail = await places.getDetailsByPlaceId(selection);
    final lat = detail.result.geometry!.location.lat;
    final lng = detail.result.geometry!.location.lng;

    // Update markers and map view
    setState(() {
      _markers = {
        Marker(
          markerId: MarkerId(selection),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(title: selection),
        ),
      };
      mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
    });
  }
}
