import 'package:flutter/material.dart';

class TripRequestForm extends StatelessWidget {
  const TripRequestForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 30), // Spacing above the form
        const TextField(
          decoration: InputDecoration(
            labelText: 'Enter Destination',
            helperText: 'Helper text',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Another Input',
            helperText: 'Helper text 2',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            // Placeholder for what the button does when pressed
          },
          child: const Text('CONFIRM'),
        ),
      ],
    );
  }
}
