Program Documentation: Technical Overview
Project: Number Converter Application
Primary Language: Dart
Framework: Flutter
Core Goal: Convert positive integers between common bases (Decimal, Binary, Hexadecimal, and Octal).

1. Application Architecture
The application follows the Model-View-ViewModel (MVVM) pattern, typical for larger Flutter applications, to ensure a clean separation of concerns:

| Layer | Responsibility | Key Files (Assumed) |
| View (UI) | Handles the user interface, displays results, and captures user input (text fields, buttons). | lib/main.dart (main widget), lib/widgets/... |
| ViewModel (Controller) | Manages the application state, handles input validation, and calls the core conversion logic. | lib/models/converter_view_model.dart |
| Model (Logic) | Contains the pure business logic: the algorithms for converting numbers between bases. | lib/logic/conversion_service.dart |

2. Core Conversion Logic (ConversionService)
The central part of the application is a dedicated service or utility class responsible for all mathematical transformations. It uses an intermediate base—Decimal (Base 10)—as the pivot for all conversions.

2.1 The Conversion Principle
All conversions are handled in two steps:

Input to Decimal: Convert the user's input string (e.g., Binary 1011 or Hex A5) into a Decimal (Base 10) integer.

Decimal to Output: Convert the resulting Decimal integer into the desired output base (Binary, Hex, or Octal).

2.2 Key Functions and Algorithms
The ConversionService (or similar logic file) typically contains the following core methods:

A. anyBaseToDecimal(String input, int fromBase)
Purpose: Converts a number from any base (2, 8, 16) into its Base 10 (Decimal) equivalent.

Algorithm: Iterative method based on positional notation. It iterates through the input string from right to left (least significant digit to most significant digit).

For each digit, it multiplies the digit's value by fromBase raised to the power of its position index (n), and sums the results.

Example (Binary '1011' to Decimal):
$$ (1 \times 2^3) + (0 \times 2^2) + (1 \times 2^1) + (1 \times 2^0) = 8 + 0 + 2 + 1 = 11 $$

Implementation Detail: Uses Dart's built-in int.parse(input, radix: fromBase) method for efficient and safe parsing.

B. decimalToAnyBase(int decimalInput, int toBase)
Purpose: Converts a Base 10 (Decimal) integer into a string representation in the target base (2, 8, or 16).

Algorithm: Repeated division and remainder method. The decimal input is repeatedly divided by the toBase, and the remainders (read in reverse order) form the digits of the new number.

Example (Decimal '11' to Binary):
$$ 11 \div 2 = 5 \text{ remainder } 1 $$
$$ 5 \div 2 = 2 \text{ remainder } 1 $$
$$ 2 \div 2 = 1 \text{ remainder } 0 $$
$$ 1 \div 2 = 0 \text{ remainder } 1 $$
(Reading remainders in reverse: 1011)

Implementation Detail: Uses Dart's built-in decimalInput.toRadixString(toBase) method for high performance and handling of hexadecimal digits (A-F).

3. Input Handling and Validation
The ViewModel layer is responsible for ensuring data integrity before conversion is attempted.

3.1 Input Validation
The application validates user input in real-time, preventing the conversion functions from receiving invalid data.

Non-Numeric Check: Ensures the input field only contains characters valid for the selected source base.

If Base is Binary (2): Only 0 and 1 are allowed.

If Base is Octal (8): Only digits 0-7 are allowed.

If Base is Hexadecimal (16): Digits 0-9 and letters A-F (case-insensitive) are allowed.

Value Range Check: Ensures the input number fits within the standard integer data type size in Dart.

3.2 Error Handling
If the input is invalid (e.g., the user enters the letter 'G' when the source base is set to Binary), the ViewModel displays a user-friendly error message on the screen instead of crashing the application or showing a cryptic error code.

4. State Management
The application uses ChangeNotifier (or a similar state management approach like Provider or Riverpod) to efficiently update the UI. When a user types a new digit, the following sequence occurs:

User input changes the text field (View).

The ViewModel detects the change, validates the input, and calls the ConversionService.

The ConversionService returns the four converted output values (Binary, Octal, Hex, Decimal).

The ViewModel updates its internal state variables.

All listening output fields (View) automatically rebuild to display the new converted numbers.