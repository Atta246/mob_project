import 'package:flutter/material.dart';
import 'package:mob_project/utils/generate_test_data.dart';

class TestDataScreen extends StatefulWidget {
  const TestDataScreen({super.key});

  @override
  State<TestDataScreen> createState() => _TestDataScreenState();
}

class _TestDataScreenState extends State<TestDataScreen> {
  bool _isGenerating = false;
  String _status = '';

  Future<void> _generateData() async {
    setState(() {
      _isGenerating = true;
      _status = 'Generating test data...';
    });

    try {
      final generator = GenerateTestData();
      await generator.generateAllTestData();
      setState(() {
        _status = '✅ Test data generated successfully!';
      });
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });
    } finally {
      setState(() {
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generate Test Data'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.science, size: 80, color: Colors.lightBlue),
              SizedBox(height: 24),
              Text(
                'Generate Test Data',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'This will create sample data for:\n'
                '• 5 Trips\n'
                '• User Profile\n'
                '• 2 Bookings\n'
                '• Payments & Tickets',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              SizedBox(height: 32),
              if (_isGenerating)
                CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _generateData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightBlue,
                    padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Generate Data',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 24),
              if (_status.isNotEmpty)
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _status.contains('✅')
                        ? Colors.green.shade50
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _status,
                    style: TextStyle(
                      color: _status.contains('✅')
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
