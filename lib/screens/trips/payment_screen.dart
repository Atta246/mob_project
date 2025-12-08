import 'package:flutter/material.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/screens/trips/ticket_screen.dart';
import 'package:mob_project/utils/validators.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPayment = 0;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  String? _cardNumberError;
  String? _expiryError;
  String? _cvvError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Card Information',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _cardNumberController,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _cardNumberError = Validators.validateCardNumber(
                              value,
                            );
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '4526 1234 7895 6257',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      if (_cardNumberError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 4, top: 4),
                          child: Text(
                            _cardNumberError!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _expiryController,
                              keyboardType: TextInputType.datetime,
                              onChanged: (value) {
                                setState(() {
                                  _expiryError = Validators.validateExpiryDate(
                                    value,
                                  );
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'MM/YY',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                            if (_expiryError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, top: 4),
                                child: Text(
                                  _expiryError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  _cvvError = Validators.validateCVV(value);
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'CVC',
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                                suffixIcon: Icon(Icons.credit_card, size: 18),
                              ),
                            ),
                            if (_cvvError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 4, top: 4),
                                child: Text(
                                  _cvvError!,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            PaymentOption(
              index: 0,
              selectedIndex: _selectedPayment,
              icon: Icons.credit_card,
              label: 'Credit Card',
              onTap: () {
                setState(() {
                  _selectedPayment = 0;
                });
              },
            ),
            const SizedBox(height: 12),
            PaymentOption(
              index: 1,
              selectedIndex: _selectedPayment,
              icon: Icons.account_balance_wallet,
              label: 'PayPal',
              onTap: () {
                setState(() {
                  _selectedPayment = 1;
                });
              },
            ),
            const SizedBox(height: 12),
            PaymentOption(
              index: 2,
              selectedIndex: _selectedPayment,
              icon: Icons.phone_iphone,
              label: 'Apple Pay',
              onTap: () {
                setState(() {
                  _selectedPayment = 2;
                });
              },
            ),
            const SizedBox(height: 12),
            PaymentOption(
              index: 3,
              selectedIndex: _selectedPayment,
              icon: Icons.phone_iphone,
              label: 'Vodafone Cash',
              onTap: () {
                setState(() {
                  _selectedPayment = 3;
                });
              },
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.07,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  // Validate card information if Credit Card is selected
                  if (_selectedPayment == 0) {
                    setState(() {
                      _cardNumberError = Validators.validateCardNumber(
                        _cardNumberController.text,
                      );
                      _expiryError = Validators.validateExpiryDate(
                        _expiryController.text,
                      );
                      _cvvError = Validators.validateCVV(_cvvController.text);
                    });

                    // Check if validation passed
                    if (_cardNumberError == null &&
                        _expiryError == null &&
                        _cvvError == null) {
                      final bookingId =
                          'BK-${DateTime.now().millisecondsSinceEpoch}';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              TicketPage(bookingId: bookingId),
                        ),
                      );
                    }
                  } else {
                    // For other payment methods, proceed directly
                    final bookingId =
                        'BK-${DateTime.now().millisecondsSinceEpoch}';
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TicketPage(bookingId: bookingId),
                      ),
                    );
                  }
                },
                child: const Text(
                  'Confirm Booking',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
