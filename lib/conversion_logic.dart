import 'dart:math';

// Helper map to convert string base names to integer radix values
final Map<String, int> baseMap = {
  'Binary': 2,
  'Octal': 8,
  'Decimal': 10,
  'Hexadecimal': 16,
};

/// Master function to handle all conversions, now with support for
/// negative numbers and fractional parts.
String convertNumber(String value, String fromBaseName, String toBaseName) {
  try {
    // 1. Get Radix Values
    int fromRadix = baseMap[fromBaseName]!;
    int toRadix = baseMap[toBaseName]!;

    // 2. Sanitize and Check for Negative
    // Remove whitespace and store if the number is negative.
    String input = value.trim();
    if (input.isEmpty) return ''; // No input, return empty

    final bool isNegative = input.startsWith('-');
    if (isNegative) {
      input = input.substring(1); // Remove sign for processing
    }

    // 3. Split into Integer and Fractional Parts
    // We use '.' as the universal separator.
    List<String> parts = input.split('.');
    String integerPart = parts[0];
    String fractionalPart = (parts.length > 1) ? parts[1] : '';

    // --- CONVERT TO DECIMAL (THE "BRIDGE") ---

    // 4. Convert Integer Part to Decimal
    // BigInt handles arbitrarily large integers.
    // If the integer part is empty (e.g., ".123"), default to 0.
    BigInt intDecimal = BigInt.zero;
    if (integerPart.isNotEmpty) {
      intDecimal = BigInt.parse(integerPart, radix: fromRadix);
    }

    // 5. Convert Fractional Part to Decimal (as a double)
    // 0.ABC (base X) = A * X^-1 + B * X^-2 + C * X^-3
    double fracDecimal = 0.0;
    if (fractionalPart.isNotEmpty) {
      for (int i = 0; i < fractionalPart.length; i++) {
        // int.parse handles 'A', 'B', 'F' etc. automatically
        int digit = int.parse(fractionalPart[i], radix: fromRadix);
        fracDecimal += digit / pow(fromRadix, i + 1);
      }
    }

    // --- CONVERT FROM DECIMAL TO TARGET BASE ---

    // 6. Convert Decimal Integer to Target Base
    // BigInt.toRadixString is perfect for this.
    String toIntegerPart = intDecimal.toRadixString(toRadix);

    // 7. Convert Decimal Fraction to Target Base
    // Repeatedly multiply the fractional part by the target base.
    // The integer part of the result is the next digit.
    String toFractionalPart = '';
    if (fracDecimal > 0) {
      // Set a precision limit to avoid infinite loops for repeating fractions
      // e.g., 0.1 (Decimal) is a repeating fraction in Binary.
      int precision = 20;
      double currentFrac = fracDecimal;

      while (currentFrac > 0 && toFractionalPart.length < precision) {
        double multiplied = currentFrac * toRadix;
        int digit = multiplied.floor();

        // Convert the single digit to its string representation in the target base
        toFractionalPart += digit.toRadixString(toRadix);

        currentFrac =
            multiplied - digit; // The new fractional part for next iteration
      }
    }

    // --- FINAL ASSEMBLY ---

    // 8. Combine Parts
    String finalResult = toIntegerPart;
    if (toFractionalPart.isNotEmpty) {
      finalResult += '.${toFractionalPart}';
    }

    // 9. Add the negative sign back if needed
    // Avoid returning "-0" or "-0.0"
    bool isZero = (intDecimal == BigInt.zero) && (fracDecimal == 0.0);
    if (isNegative && !isZero) {
      finalResult = '-${finalResult}';
    }

    // 10. Format and Return
    return finalResult.toUpperCase();
  } catch (e) {
    // Return an error message if the input is invalid (e.g., "123.ABC.456")
    return 'Error: Invalid input for $fromBaseName';
  }
}
