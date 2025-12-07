import 'package:flutter/material.dart';

class PriceRow extends StatelessWidget {
  final String label;
  final String amount;
  final bool isTotal;
  final bool isBold;

  const PriceRow({
    Key? key,
    required this.label,
    required this.amount,
    this.isTotal = false,
    this.isBold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal || isBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal || isBold
                  ? FontWeight.bold
                  : FontWeight.normal,
              color: isTotal ? Colors.black : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
