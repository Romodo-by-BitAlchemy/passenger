import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestNetwork {
  static const String backendUrl = 'https://192.168.8.136/api/requestTrip'; 

  static Future<bool> requestTrip(String name, String destination) async {
    try {
      final response = await http.post(
        Uri.parse(backendUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'name': name, 'destination': destination}),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to request trip: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
