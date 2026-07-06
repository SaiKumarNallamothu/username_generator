import 'package:flutter/material.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xFF0A0D14); // Deep Space Black
  static const Color accentColor = Color(0xFF00F2FE);  // Neon Cyan
  static const Color secondaryColor = Color(0xFF141A29); // Dark Navy/Slate
  static const Color cardColor = Color(0xFF1B2236); // Lighter Navy/Slate
  static const Color successColor = Color(0xFF00FF87); // Neon Green
  static const Color errorColor = Color(0xFFFF007F); // Neon Magenta/Pink
  static const Color textSecondary = Color(0xFF8E9AA8);

  static const Color purpleAccent = Color(0xFF8B5CF6); // Electric Purple

  // Gradients for cards, backgrounds, and buttons
  static const LinearGradient cyberGradient = LinearGradient(
    colors: [accentColor, purpleAccent],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient premiumGradient = LinearGradient(
    colors: [Color(0xFFFF007F), Color(0xFF8B5CF6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: primaryColor,
      cardColor: cardColor,
      colorScheme: const ColorScheme.dark(
        primary: accentColor,
        secondary: purpleAccent,
        surface: cardColor,
        error: errorColor,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: accentColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        iconTheme: IconThemeData(color: accentColor),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryColor,
        selectedItemColor: accentColor,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryColor,
          backgroundColor: accentColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: secondaryColor,
        filled: true,
        hintStyle: const TextStyle(color: textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: accentColor, width: 1.5),
        ),
      ),
    );
  }
}
