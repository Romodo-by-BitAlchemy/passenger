import 'package:flutter/material.dart';

class TripBookPage extends StatelessWidget {
  const TripBookPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Trip'),
      ),
      body: const Center(
        child: Text('Trip Booking Page'),
      ),
    );
  }
}