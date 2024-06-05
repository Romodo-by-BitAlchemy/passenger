import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePassengerScreen extends StatefulWidget {
  final String passengerId;

  const UpdatePassengerScreen({super.key, required this.passengerId});

  @override
  // ignore: library_private_types_in_public_api
  _UpdatePassengerScreenState createState() => _UpdatePassengerScreenState();
}

class _UpdatePassengerScreenState extends State<UpdatePassengerScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  String? _errorMessage;

  Future<void> _fetchPassengerDetails() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/passengers/${widget.passengerId}'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _nameController.text = data['name'];
        _emailController.text = data['email'];
        _phoneController.text = data['phone'];
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load passenger details';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPassengerDetails();
  }

  Future<void> _handleSubmit() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final phone = _phoneController.text;

    final response = await http.put(
      Uri.parse('http://localhost:3000/passengers/${widget.passengerId}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passenger details updated successfully')),
      );
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } else {
      setState(() {
        _errorMessage = 'Failed to update passenger details';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Passenger Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _handleSubmit,
                child: const Text('UPDATE'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
