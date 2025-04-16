import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'auth_service.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Controllers for form fields
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _cvcController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  // Secure storage instance
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSavedPaymentInfo(); // Load saved payment info when the screen initializes
  }

  // Load saved payment info from secure storage or Firestore
  Future<void> _loadSavedPaymentInfo() async {
    final user = Provider.of<AuthService>(context, listen: false).currentUser;
    if (user == null) return;

    try {
      // Retrieve payment info from Firestore using the user's uid
      final paymentInfo = await FirebaseFirestore.instance
          .collection('userPaymentInfo')
          .doc(user.uid)
          .get();

      if (paymentInfo.exists) {
        setState(() {
          _cardNumberController.text = paymentInfo['cardNumber'];
          _cvcController.text = paymentInfo['cvc'];
          _expiryDateController.text = paymentInfo['expiryDate'];
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading payment info: ${e.toString()}')),
      );
    }
  }

  // Submit function to handle payment
  void _submitPayment() async {
    if (_formKey.currentState!.validate()) {
      final user = Provider.of<AuthService>(context, listen: false).currentUser;
      if (user == null) return;

      try {
        // Save payment info to Firestore under the user's uid
        await FirebaseFirestore.instance
            .collection('userPaymentInfo')
            .doc(user.uid)
            .set({
          'cardNumber': _cardNumberController.text,
          'cvc': _cvcController.text,
          'expiryDate': _expiryDateController.text,
        });

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Payment Successful!')),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving payment info: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Payment'),
        backgroundColor: Colors.lime,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // White Box for Payment Form
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Prompt Text
                      Text(
                        'Enter Payment Info',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'DGT',
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Card Number Field
                      TextFormField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        maxLength: 19, // 16 digits + spaces (e.g., 4444 4444 4444 4444)
                        decoration: InputDecoration(
                          labelText: 'Card Number',
                          hintText: 'Enter your card number',
                          prefixIcon: const Icon(Icons.credit_card),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Card number is required';
                          }
                          final sanitizedValue = value.replaceAll(RegExp(r'\s+'), '');
                          if (sanitizedValue.length != 16) {
                            return 'Card number must be 16 digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Expiry Date Field
                      TextFormField(
                        controller: _expiryDateController,
                        keyboardType: TextInputType.datetime,
                        maxLength: 5, // MM/YY format
                        decoration: InputDecoration(
                          labelText: 'Expiry Date',
                          hintText: 'MM/YY',
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Expiry date is required';
                          }
                          final regex = RegExp(r'^(0[1-9]|1[0-2])\/\d{2}$');
                          if (!regex.hasMatch(value)) {
                            return 'Invalid expiry date (MM/YY)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // CVC Field
                      TextFormField(
                        controller: _cvcController,
                        keyboardType: TextInputType.number,
                        maxLength: 3, // Typically 3 digits for CVC
                        decoration: InputDecoration(
                          labelText: 'CVC',
                          hintText: 'Enter CVC',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'CVC is required';
                          }
                          if (value.length != 3) {
                            return 'CVC must be 3 digits';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Checkout Button
                ElevatedButton(
                  onPressed: _submitPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lime,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Checkout',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DGT',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}