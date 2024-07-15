import 'package:flutter/material.dart';
import 'package:payin/network/requestNetwork.dart';


class RequestTripPage extends StatefulWidget {
  @override
  _RequestTripPageState createState() => _RequestTripPageState();
}

class _RequestTripPageState extends State<RequestTripPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  void requestTrip() async {
    String name = nameController.text;
    String destination = destinationController.text;

    if (name.isNotEmpty && destination.isNotEmpty) {
      
      bool success = await RequestNetwork.requestTrip(name, destination);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Trip requested successfully!')),
        );
        Navigator.pop(context); 
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to request trip.')),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Validation Error'),
            content: Text('Please enter both your name and destination.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Trip'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Destination',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: requestTrip,
              child: Text('Request Trip'),
            ),
          ],
        ),
      ),
    );
  }
}








