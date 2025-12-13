import 'package:flutter/material.dart';
import 'package:mob_project/screens/trips/ticket_screen.dart';
import 'package:mob_project/utils/validators.dart';
import 'package:mob_project/models/models.dart';
import 'package:mob_project/repositories/repositories.dart';
import 'package:mob_project/utils/modern_snackbar.dart';

class PaymentScreen extends StatefulWidget {
  final BookingModel booking;
  final TripModel trip;

  const PaymentScreen({super.key, required this.booking, required this.trip});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  int _selectedPayment = 0;
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _vodafoneNumberController =
      TextEditingController();
  String? _cardNumberError;
  String? _expiryError;
  String? _cvvError;
  String? _vodafoneNumberError;
  bool _isProcessing = false;

  final BookingRepository _bookingRepository = BookingRepository();
  final PaymentRepository _paymentRepository = PaymentRepository();
  final TicketRepository _ticketRepository = TicketRepository();
  final TripRepository _tripRepository = TripRepository();

  Future<void> _processPayment() async {
    // Validate based on selected payment method
    if (_selectedPayment == 0) {
      // Credit Card validation
      setState(() {
        _cardNumberError = Validators.validateCardNumber(
          _cardNumberController.text,
        );
        _expiryError = Validators.validateExpiryDate(_expiryController.text);
        _cvvError = Validators.validateCVV(_cvvController.text);
      });

      if (_cardNumberError != null ||
          _expiryError != null ||
          _cvvError != null) {
        ModernSnackBar.show(
          context,
          'Please fix the errors in the form',
          type: SnackBarType.error,
        );
        return;
      }
    } else if (_selectedPayment == 2) {
      // Vodafone Cash validation
      if (_vodafoneNumberController.text.isEmpty ||
          _vodafoneNumberController.text.length < 11) {
        setState(() {
          _vodafoneNumberError = 'Please enter a valid phone number';
        });
        ModernSnackBar.show(
          context,
          'Please enter a valid Vodafone number',
          type: SnackBarType.error,
        );
        return;
      }
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // 1. Create booking
      final bookingId = await _bookingRepository.createBooking(widget.booking);

      // 2. Create payment
      String paymentMethod = 'credit_card';
      if (_selectedPayment == 1) paymentMethod = 'paypal';
      if (_selectedPayment == 2) paymentMethod = 'vodafone_cash';

      final payment = PaymentModel(
        paymentId: '', // Will be generated
        bookingId: bookingId,
        userId: widget.booking.userId,
        amount: widget.booking.finalTotal,
        paymentMethod: paymentMethod,
        status: 'completed',
        paymentDate: DateTime.now(),
      );

      await _paymentRepository.createPayment(payment);
      // 4. Update booking status
      await _bookingRepository.updateBookingStatus(bookingId, 'confirmed');

      // 5. Update trip available seats (pass number of seats to reduce)
      await _tripRepository.updateAvailableSeats(
        widget.trip.tripId,
        widget.booking.numberOfGuests,
      );

      // 6. Create ticket
      final ticket = TicketModel(
        ticketId: '', // Will be generated
        bookingId: bookingId,
        userId: widget.booking.userId,
        tripId: widget.booking.tripId,
        qrCode: 'QR-$bookingId',
        status: 'active',
        createdAt: DateTime.now(),
      );

      final ticketId = await _ticketRepository.createTicket(ticket);

      // 7. Navigate to ticket screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TicketScreen(bookingId: bookingId, ticketId: ticketId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ModernSnackBar.show(
          context,
          'Payment failed: $e',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _vodafoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Payment'),
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
            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Order Summary',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.trip.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Guests: ${widget.booking.numberOfGuests}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Date: ${widget.booking.selectedDate.month}/${widget.booking.selectedDate.day}/${widget.booking.selectedDate.year}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  Text(
                    'Time: ${widget.booking.selectedTime}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Base Price',
                    '\$${widget.booking.totalPrice.toStringAsFixed(2)}',
                  ),
                  _buildSummaryRow(
                    'Service Fee',
                    '\$${widget.booking.serviceFee.toStringAsFixed(2)}',
                  ),
                  _buildSummaryRow(
                    'Taxes',
                    '\$${widget.booking.taxes.toStringAsFixed(2)}',
                  ),
                  const Divider(height: 24),
                  _buildSummaryRow(
                    'Total',
                    '\$${widget.booking.finalTotal.toStringAsFixed(2)}',
                    isTotal: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Method Selection
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Method',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPaymentOption(
                          0,
                          'Credit Card',
                          Icons.credit_card,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPaymentOption(1, 'PayPal', Icons.payment),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildPaymentOption(
                          2,
                          'Vodafone',
                          Icons.phone_android,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Card Information (only show if credit card selected)
            if (_selectedPayment == 0)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Card Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _cardNumberController,
                      keyboardType: TextInputType.number,
                      maxLength: 14,
                      onChanged: (value) {
                        setState(() {
                          _cardNumberError = Validators.validateCardNumber(
                            value,
                          );
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '4526 1234 7895 6257',
                        labelText: 'Card Number',
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _cardNumberError,
                        counterText: '',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expiryController,
                            keyboardType: TextInputType.datetime,
                            maxLength: 5,
                            onChanged: (value) {
                              setState(() {
                                _expiryError = Validators.validateExpiryDate(
                                  value,
                                );
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'MM/YY',
                              labelText: 'Expiry Date',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _expiryError,
                              counterText: '',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _cvvController,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            onChanged: (value) {
                              setState(() {
                                _cvvError = Validators.validateCVV(value);
                              });
                            },
                            decoration: InputDecoration(
                              hintText: '123',
                              labelText: 'CVV',
                              filled: true,
                              fillColor: Colors.grey[100],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              errorText: _cvvError,
                              counterText: '',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Vodafone Cash Information (only show if Vodafone selected)
            if (_selectedPayment == 2)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Vodafone Cash',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _vodafoneNumberController,
                      keyboardType: TextInputType.phone,
                      maxLength: 11,
                      onChanged: (value) {
                        setState(() {
                          _vodafoneNumberError = null;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: '01012345678',
                        labelText: 'Vodafone Number',
                        filled: true,
                        fillColor: Colors.grey[100],
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        errorText: _vodafoneNumberError,
                        counterText: '',
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 30),

            // Pay Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isProcessing ? null : _processPayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Pay \$${widget.booking.finalTotal.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? Colors.blue : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(int value, String label, IconData icon) {
    final isSelected = _selectedPayment == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPayment = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue.shade50 : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
