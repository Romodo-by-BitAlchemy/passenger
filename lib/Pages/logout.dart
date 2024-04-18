import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ignore: use_key_in_widget_constructors
class Logout extends StatelessWidget {
  void handleLogout(BuildContext context) async {
    final response = await http.get(Uri.parse('http://localhost:3000/auth/logout'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['status']) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout Confirmation'),
              content: const Text('Are you sure you want to logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pushNamed('/login'); // Navigate to login
                  },
                  child: const Text('Logout'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // ignore: avoid_print
      print('Error: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/dashboard');
              },
              child: const Text('Dashboard'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                handleLogout(context);
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
