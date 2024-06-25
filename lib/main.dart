import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pays/services/network_service.dart';
import 'package:pays/respository/paymentProceedRespo.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set your Stripe publishable key directly here.
  Stripe.publishableKey = 'pk_test_51PTNoXIVbvSD3OkZpPI5FrZYI1ovYhjXkiRWg0SGE1x8s0Y5TO6WGwe8ZgDoDyaYsw1FDW1hc72NwvwchxsSOcya00hTFNaKhr';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stripe Payment Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PaymentPage(),
    );
  }
}

class PaymentPage extends StatelessWidget {
  // Controllers for the text fields.
  final TextEditingController nameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  // Instance of NetworkService
  final NetworkService networkService = NetworkService(baseUrl: 'https://your-backend-url.com');  // Replace with your backend URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Enter your name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: destinationController,
              decoration: InputDecoration(
                labelText: 'Enter your destination',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 40),  // Add some spacing before the button
            ElevatedButton(
              onPressed: () async {
                // Retrieve the input values
                String name = nameController.text;
                String destination = destinationController.text;

                // Input validation
                if (name.isEmpty || destination.isEmpty) {
                  // Show an error message if any field is empty
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
                  return;
                }

                // Print the inputs to the console (for debugging)
                print('Name: $name');
                print('Destination: $destination');

                // Send the data to the backend
                await networkService.sendData(name, destination);

                // Call the payment handling method.
                final paymentHandler = StripePaymentHandle();
                await paymentHandler.stripeMakePayment(context);

                // Clear the text fields after a successful payment (optional)
                nameController.clear();
                destinationController.clear();
              },
              child: Text('Make Payment'),
            ),
          ],
        ),
      ),
    );
  }
}




























