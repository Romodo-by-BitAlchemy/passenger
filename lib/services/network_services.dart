import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkService {
  final String baseUrl;

  NetworkService({required this.baseUrl});

  Future<void> sendData(String name, String destination) async {
    final url = Uri.parse('$baseUrl/submitData');  // Replace with your actual endpoint

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'destination': destination,
        }),
      );

      if (response.statusCode == 200) {
        
        print('Data sent successfully');
      } else {
       
        print('Failed to send data: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      
      print('An error occurred: $e');
    }
  }
}


