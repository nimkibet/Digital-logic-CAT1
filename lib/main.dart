import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For Clipboard
import 'conversion_logic.dart'; // Import your logic file

void main() => runApp(const NumberConverterApp());

class NumberConverterApp extends StatelessWidget {
  const NumberConverterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Converter',
      // Use a dark theme for a more modern look
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
        cardColor: const Color(0xFF1E1E1E),
        hintColor: Colors.deepPurpleAccent,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const ConverterScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final List<String> bases = ['Binary', 'Octal', 'Decimal', 'Hexadecimal'];
  String? fromBase = 'Decimal';
  String? toBase = 'Binary';
  String inputValue = '';
  String result = '';

  final TextEditingController _controller = TextEditingController();

  void _performConversion() {
    if (inputValue.isEmpty || fromBase == null || toBase == null) {
      setState(() {
        result = ''; // Clear result if input is empty
      });
      return;
    }

    String converted = convertNumber(inputValue, fromBase!, toBase!);
    setState(() {
      result = converted;
    });
  }

  // New function to swap the bases
  void _swapBases() {
    setState(() {
      String? temp = fromBase;
      fromBase = toBase;
      toBase = temp;

      // Optional: Also swap input and result for a seamless flow
      if (result.isNotEmpty && !result.startsWith('Error')) {
        _controller.text = result;
        inputValue = result;
        _performConversion(); // Re-calculate with new bases
      } else {
        result = ''; // Clear result if it was an error
      }
    });
  }

  void _copyToClipboard() {
    if (result.isNotEmpty && !result.startsWith('Error')) {
      Clipboard.setData(ClipboardData(text: result));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Result copied to clipboard!'),
          backgroundColor: Colors.deepPurple,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number System Converter'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      // Use SingleChildScrollView to prevent overflow on small screens
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // --- 1. Input Card ---
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Enter Number',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'e.g., 10.5 or -FF.C',
                          filled: true,
                          fillColor: const Color(0xFF2C2C2C),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          inputValue = value;
                          // Optional: Convert on the fly
                          // _performConversion();
                        },
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // --- 2. Base Selection Card ---
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // 'From' Dropdown
                      Expanded(
                        child: _buildDropdown('From', fromBase, (
                          String? newValue,
                        ) {
                          setState(() {
                            fromBase = newValue;
                            _performConversion(); // Update result on change
                          });
                        }),
                      ),

                      // Swap Button
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          icon: const Icon(
                            Icons.swap_horiz,
                            color: Colors.deepPurpleAccent,
                            size: 30,
                          ),
                          onPressed: _swapBases,
                        ),
                      ),

                      // 'To' Dropdown
                      Expanded(
                        child: _buildDropdown('To', toBase, (String? newValue) {
                          setState(() {
                            toBase = newValue;
                            _performConversion(); // Update result on change
                          });
                        }),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- 3. Convert Button ---
              ElevatedButton(
                onPressed: _performConversion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('CONVERT'),
              ),

              const SizedBox(height: 30),

              // --- 4. Result Display Card ---
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Result:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.white70),
                            onPressed: _copyToClipboard,
                            tooltip: 'Copy to Clipboard',
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2C2C2C),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        // Use SelectableText so the user can copy it
                        child: SelectableText(
                          result.isEmpty ? '-' : result,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: result.startsWith('Error')
                                ? Colors.redAccent
                                : Colors.greenAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
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
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C2C),
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedValue,
              isExpanded: true,
              dropdownColor: const Color(0xFF2C2C2C),
              style: const TextStyle(color: Colors.white, fontSize: 16),
              items: bases.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
