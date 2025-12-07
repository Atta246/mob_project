import 'package:flutter/material.dart';
import 'package:mob_project/widgets/widgets.dart';
import 'package:mob_project/screens/trips/ticket_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPayment = 0;

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
                  TextField(
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
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
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
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
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
                  final bookingId =
                      'BK-${DateTime.now().millisecondsSinceEpoch}';
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TicketPage(bookingId: bookingId),
                    ),
                  );
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
