import 'package:flutter/material.dart';

class AppTheme {
  /// The application's main ThemeData
  static ThemeData get themeData => ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Colors.transparent,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF4FC3F7),
      secondary: Colors.teal,
    ),
  );

  // Colors
  static const primaryColor = Color(0xFF009688);
  static const secondaryColor = Color(0xFF4FC3F7);
  static const backgroundColor = Color(0xFF2E3136);
  static const inputBackgroundColor = Color(0xFF1A1F24);
  static const textPrimaryColor = Colors.white;
  static const textSecondaryColor = Color(0xFF9E9E9E);

  // Gradients
  static const backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1A1F24),
      Color(0xFF121417),
    ],
  );

  static const buttonGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF4FC3F7),
      Color(0xFF009688),
    ],
  );

  // Decorations
  static BoxDecoration inputDecoration = BoxDecoration(
    color: inputBackgroundColor,
    borderRadius: BorderRadius.circular(12),
  );

  static BoxDecoration containerDecoration = BoxDecoration(
    color: backgroundColor,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [containerShadow],
  );

  static BoxDecoration gradientButtonDecoration = BoxDecoration(
    gradient: buttonGradient,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [buttonShadow],
  );

  // Shadows
  static final containerShadow = BoxShadow(
    color: const Color(0x33000000), // Black with 20% opacity
    blurRadius: 10,
    offset: const Offset(0, 5),
  );

  static final buttonShadow = BoxShadow(
    color: const Color(0x4D008080), // Teal with 30% opacity
    spreadRadius: 1,
    blurRadius: 8,
    offset: const Offset(0, 2),
  );

  // Text Styles
  static const headingStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const buttonTextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static TextStyle linkTextStyle = TextStyle(
    color: Colors.grey[400],
    fontSize: 14,
  );

  static const bodyTextStyle = TextStyle(
    fontSize: 16,
    color: textPrimaryColor,
  );

  static const errorTextStyle = TextStyle(
    fontSize: 12,
    color: Colors.red,
    fontWeight: FontWeight.w500,
  );

  // Input Decoration
  static InputDecoration getInputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[600]),
      border: InputBorder.none,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffixIcon,
      contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
    );
  }

  // Button Style
  static final ButtonStyle gradientButtonStyle = ElevatedButton.styleFrom(
    padding: const EdgeInsets.symmetric(vertical: 16),
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );

  // Common Sizes
  static const double defaultPadding = 16.0;
  static const double containerPadding = 32.0;
  static const double borderRadius = 12.0;
  static const double containerWidth = 400.0;
  static const double buttonHeight = 50.0;
  static const double logoWidth = 200.0;
}
