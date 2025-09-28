// lib/conversion_logic.dart

// Helper map to convert string base names to integer radix values
final Map<String, int> baseMap = {
  'Binary': 2,
  'Octal': 8,
  'Decimal': 10,
  'Hexadecimal': 16,
};

// Master function to handle all conversions
String convertNumber(String value, String fromBaseName, String toBaseName) {
  try {
    // 1. Convert Base Name to Radix (e.g., 'Decimal' -> 10)
    int fromRadix = baseMap[fromBaseName]!;
    int toRadix = baseMap[toBaseName]!;

    // 2. Convert input string to an integer (Decimal value is the bridge)
    // The value.trim() is important for cleaning up user input
    BigInt decimalValue = BigInt.parse(value.trim(), radix: fromRadix);

    // 3. Convert the Decimal value to the Target Radix
    String result = decimalValue.toRadixString(toRadix);

    // 4. Format the output (e.g., convert hex to uppercase)
    return result.toUpperCase();

  } catch (e) {
    // Return an error message if the input is invalid for the selected base
    return 'Error: Invalid input for $fromBaseName';
  }
}