// lib/main.dart

import 'package:flutter/material.dart';
import 'conversion_logic.dart'; // Import your logic file

void main() => runApp(const NumberConverterApp());

class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Converter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const ConverterScreen(),
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Available conversion bases
  final List<String> bases = ['Binary', 'Octal', 'Decimal', 'Hexadecimal'];

  // State variables for the app
  String? fromBase = 'Decimal'; // Default 'From' base
  String? toBase = 'Binary'; // Default 'To' base
  String inputValue = '';
  String result = '';

  // Controller for the text field
  final TextEditingController _controller = TextEditingController();

  void _performConversion() {
    if (inputValue.isEmpty || fromBase == null || toBase == null) {
      setState(() {
        result = 'Please enter a number and select bases.';
      });
      return;
    }

    // Call the master function from conversion_logic.dart
    String converted = convertNumber(inputValue, fromBase!, toBase!);

    // Update the UI with the result
    setState(() {
      result = converted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NUMBER SYSTEM CONVETER')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // --- 1. Input Field ---
            TextField(
              controller: _controller,
              keyboardType:
                  TextInputType.text, // Use text to allow hex characters
              decoration: const InputDecoration(
                labelText: 'Enter Number to Convert',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                inputValue = value;
              },
            ),

            const SizedBox(height: 30),

            // --- 2. Base Selection Dropdowns ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // 'From' Dropdown
                _buildDropdown('From Base', fromBase, (String? newValue) {
                  setState(() {
                    fromBase = newValue;
                    result = ''; // Clear result on base change
                  });
                }),

                const Icon(Icons.arrow_forward_ios, color: Colors.grey),

                // 'To' Dropdown
                _buildDropdown('To Base', toBase, (String? newValue) {
                  setState(() {
                    toBase = newValue;
                    result = ''; // Clear result on base change
                  });
                }),
              ],
            ),

            const SizedBox(height: 30),

            // --- 3. Convert Button ---
            ElevatedButton(
              onPressed: _performConversion,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('CONVERT', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 40),

            // --- 4. Result Display ---
            const Text(
              'Result:',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            Text(
              result,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget for the Dropdowns
  Widget _buildDropdown(
    String label,
    String? selectedValue,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedValue,
          items: bases.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(value: value, child: Text(value));
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
