// ignore: file_names
import 'package:flutter/material.dart';
import 'package:passenger/pages/fpassword.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required String title});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _showPassword = false;
  String _errorMessage = "";

  void _handleSubmit() {
    // Implement your login logic here
    String username = _usernameController.text;
    String password = _passwordController.text;

    // Check if username and password are valid
    if (username.isNotEmpty && password.isNotEmpty) {
      // Perform login operation
      // ignore: avoid_print
      print("User logged in successfully");
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Success"),
            content: const Text("User logged in successfully"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
      // Clear text fields
      _usernameController.clear();
      _passwordController.clear();
    } else {
      setState(() {
        _errorMessage = "Invalid username or password. Please try again.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Login',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                filled: true,
              ),
            ),
            const SizedBox(height: 10.0),
            TextField(
              controller: _passwordController,
              obscureText: !_showPassword,
              decoration: InputDecoration(
                labelText: 'Password',
                filled: true,
                suffixIcon: IconButton(
                  icon: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _showPassword = !_showPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            TextButton(
              onPressed: () {
                // Implement Forgot Password functionality
                Navigator.pushNamed(context, '/forgot_password');
              },
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: Colors.blue),
              ),
            ),

                            

            const SizedBox(height: 10.0),
            _errorMessage.isNotEmpty
                ? Text(
                    _errorMessage,
                    style: const TextStyle(color: Colors.red),
                  )
                : const SizedBox(),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _handleSubmit,
              child: const Text('Login'),
            ),
            const SizedBox(height: 10.0),
            const Text('Don\'t have an account?'),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: const Text(
                'Sign Up',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
