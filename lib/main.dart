import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:passenger/pages/fpassword.dart';
import 'package:passenger/pages/getemail.dart';
import 'package:passenger/pages/login.dart';
//import 'package:pass_log/pages/logout.dart';
import 'package:passenger/pages/rpassword.dart';
import 'package:passenger/pages/signup.dart';
import 'package:passenger/pages/updatep.dart';
import 'package:passenger/components/bottom_nav_bar.dart';
import 'package:passenger/Pages/book_trip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => const LoginScreen(title: ''),
        '/signup': (context) => const SignUpScreen(),
        '/fpassword': (context) => ForgotPassword(),
        '/rpassword': (context) => const ResetPassword(token: ''),
        '/dashboard': (context) => const MyHomePage(title: 'Dashboard'),
        //'/logout': (context) =>  Logout(),
        '/updatePassenger': (context) => UpdatePassengerScreen(
          passengerEmail: ModalRoute.of(context)!.settings.arguments as String,
        ),
        '/get_email': (context) => GetEmailScreen(),
        '/tripBook': (context) => const TripBookPage(), // Add the route for trip book page
      },
      initialRoute: '/login',
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  String? _firstName;
  DateTime nextTripDate = DateTime(2024, 7, 10, 10, 0); // Dummy next trip date and time

  @override
  void initState() {
    super.initState();
    _fetchPassengerDetails();
  }

  Future<void> _fetchPassengerDetails() async {
    // Replace this with actual database call
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _firstName = 'Sammani'; // Dummy first name
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/menu');
        break;
      case 1:
        Navigator.pushNamed(context, '/home');
        break;
      case 2:
        Navigator.pushNamed(context, '/romodo');
        break;
      case 3:
        Navigator.pushNamed(context, '/account');
        break;
    }
  }

  String _calculateTimeToStart() {
    Duration difference = nextTripDate.difference(DateTime.now());
    if (difference.isNegative) {
      return "Trip already started";
    }
    return "${difference.inDays} days ${difference.inHours.remainder(24)} hours ${difference.inMinutes.remainder(60)} minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (_firstName != null)
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.person, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8.0),
                      Text(
                        'Welcome, $_firstName',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 20.0),
              Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.directions_bus, color: Theme.of(context).primaryColor),
        title: const Text('Next Trip'),
        subtitle: Text(
          // Corrected date and time formatting
          'Date: ${DateFormat('yyyy-MM-dd').format(nextTripDate.toLocal())} \nTime: ${DateFormat('hh:mm a').format(nextTripDate.toLocal())}\nTime to start: ${_calculateTimeToStart()}',
        ),
        trailing: ElevatedButton(
          onPressed: () {
            // Handle track vehicle action
          },
          child: const Text('Track Vehicle'),
        ),
      ),
    ),
              const SizedBox(height: 20.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/tripBook'); // Navigate to trip book page
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 165, 131, 229), // Light purple color
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    '+ Book a Trip',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: Color.fromARGB(248, 67, 59, 59)),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Text(
                'Upcoming Trips',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10.0),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.directions_bus, color: Theme.of(context).primaryColor),
                  title: const Text('Trip to Nugegoda'),
                  subtitle: const Text('Date: 2024-07-10\nTime: 10:00 AM'),
                ),
              ),
              Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Icon(Icons.directions_bus, color: Theme.of(context).primaryColor),
                  title: const Text('Trip to Battaramulla'),
                  subtitle: const Text('Date: 2024-07-15\nTime: 02:00 PM'),
                ),
              ),
              // Add more dummy trips here
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle chat action
        },
        child: const Icon(Icons.chat),
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemTapped,
      ),
    );
  }
}