import 'package:flutter/material.dart';
//import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:payout/respository/paymentProceedRespo.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Stripe
  await StripePaymentHandler.initStripe();

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
  final StripePaymentHandler paymentHandler = StripePaymentHandler();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stripe Payment Example'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // You might want to replace these with actual values
            await paymentHandler.makePayment(context, 'John Doe', 'New York');
          },
          child: Text('Make Payment'),
        ),
      ),
    );
  }
}
















// import 'package:flutter/material.dart';
// import 'components/bottom_nav_bar.dart';
// import 'pages/book_trip.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Romodo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//             seedColor: const Color.fromARGB(255, 59, 17, 226)),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Romodo'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _selectedIndex = 1; // Start with the Romodo tab selected

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   // Define your pages here. These could be actual pages or just placeholders.
//   final List<Widget> _pages = [
//     const Center(child: Text('Menu Page')),
//     const Center(child: Text('Home Page')),
//     const Center(
//       child: BookTripPage(),
//     ),
//     const Center(child: Text('Account Page')),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: _pages.elementAt(_selectedIndex),
//         ),
//       ),
//       bottomNavigationBar: BottomNavBar(
//         selectedIndex: _selectedIndex,
//         onItemSelected: _onItemTapped,
//       ),
//     );
//   }
// }
