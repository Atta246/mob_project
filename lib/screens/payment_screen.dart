import 'package:flutter/material.dart';
import 'package:mob_project/screens/main_screen.dart';
import 'package:mob_project/screens/ticket_screen.dart';
import '../widgets/custom_bottom_nav.dart';

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
      body: Padding(
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
            _buildPaymentOption(0, Icons.credit_card, 'Credit Card'),
            const SizedBox(height: 15),
            _buildPaymentOption(1, Icons.account_balance_wallet, 'PayPal'),
            const SizedBox(height: 15),
            _buildPaymentOption(2, Icons.phone_iphone, 'Apple Pay'),
            const SizedBox(height: 15),
            _buildPaymentOption(3, Icons.phone_iphone, 'Vodafone Cash'),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 60,
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
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 2,
        onTap: (index) {
          if (index == 2) {
            Navigator.popUntil(context, (route) => route.isFirst);
          } else {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => mainScreen(initialIndex: index),
              ),
              (route) => false,
            );
          }
        },
      ),
    );
  }

  Widget _buildPaymentOption(int index, IconData icon, String label) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedPayment = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: _selectedPayment,
              onChanged: (val) {
                setState(() {
                  _selectedPayment = val!;
                });
              },
              activeColor: Colors.lightBlue,
            ),
          ],
        ),
      ),
    );
  }
}
