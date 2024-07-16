import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripePaymentHandler {
  static const String _stripeSecretKey = 'sk_test_51PTNoXIVbvSD3OkZIylMegkOxkH7IpC12Js1dKHPbtGmlQsZFATGLRl5p4hBAEtATU9Wf4idfHyvFXIsriZY2gPs00w23hdtvJ';
  static const String publishableKey = 'pk_test_51PTNoXIVbvSD3OkZpPI5FrZYI1ovYhjXkiRWg0SGE1x8s0Y5TO6WGwe8ZgDoDyaYsw1FDW1hc72NwvwchxsSOcya00hTFNaKhr';

  Map<String, dynamic>? paymentIntent;

  static Future<void> initStripe() async {
    Stripe.publishableKey = publishableKey;
  }

  Future<void> makePayment(BuildContext context, String name, String destination) async {
    try {
      paymentIntent = await createPaymentIntent('100', 'INR');
      
      if (paymentIntent == null) {
        throw Exception('Failed to create payment intent');
      }
      
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          billingDetails: BillingDetails(
            name: name,
            email: 'YOUREMAIL@gmail.com',
            phone: 'YOUR NUMBER',
            address: Address(
              city: 'YOUR CITY',
              country: 'YOUR COUNTRY',
              line1: 'YOUR ADDRESS 1',
              line2: 'YOUR ADDRESS 2',
              postalCode: 'YOUR PINCODE',
              state: 'YOUR STATE',
            ),
          ),
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.system,
          merchantDisplayName: 'Your Merchant Name',
        ),
      );

      await displayPaymentSheet(context);
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Future<void> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment successfully completed')),
      );
      
      // Send success message to backend
      await sendSuccessMessageToBackend();
      
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error from Stripe: ${e.error.localizedMessage}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unforeseen error: $e')),
      );
    }
  }

  Future<void> sendSuccessMessageToBackend() async {
    try {
      final response = await http.post(
        Uri.parse('https://mobile Ip Address/payment-success'),   //put the mobile ip address 
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'message': 'Payment successful',
          'paymentIntentId': paymentIntent?['id'] ?? '',
        }),
      );

      if (response.statusCode == 200) {
        print('Success message sent to backend');
      } else {
        print('Failed to send success message to backend');
      }
    } catch (e) {
      print('Error sending success message to backend: $e');
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card', 
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_stripeSecretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  String calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}