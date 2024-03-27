import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';

// Replace with your API key
const kGoogleApiKey = "AIzaSyCFMvP08hl6J9yIcJoPoCm7Tioqb2L3Kcw";

// The client used by flutter_google_places package
final places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

class BookTripPage extends StatefulWidget {
  const BookTripPage({super.key});

  @override
  BookTripPageState createState() => BookTripPageState();
}

class BookTripPageState extends State<BookTripPage> {
  GoogleMapController? mapController;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Text field for search
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _searchController,
            readOnly: true,
            onTap: _handlePressButton,
            decoration: InputDecoration(
              hintText: "Enter destination",
              icon: Container(
                margin: const EdgeInsets.only(left: 20),
                width: 10,
                height: 10,
                child: const Icon(Icons.home, color: Colors.black),
              ),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
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
          ),
        )
      ],
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Future<void> _handlePressButton() async {
    // Show autocomplete search
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      language: "en",
      components: [Component(Component.country, "lk")],
    );

    if (p != null) {
      // Get details of the selected place
      GoogleMapsPlaces places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId!);
      final lat = detail.result.geometry!.location.lat;
      final lng = detail.result.geometry!.location.lng;

      // Update the map to display the location
      mapController!.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));

      // Here, you can also fetch and display directions using Google Maps Directions API
      // This part is not shown due to the complexity and length of the code
      // You would make a network request to the Directions API and parse the response
    }
  }
}
