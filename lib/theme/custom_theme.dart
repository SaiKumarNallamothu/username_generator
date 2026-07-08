import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static const Color primaryColor = Color(0xFF0B0B0F); // Deep Obsidian
  static const Color secondaryColor = Color(0xFF12121A); // Dark Purple-Grey
  static const Color cardColor = Color(0xFF181824); // Card Background
  static const Color accentColor = Color(0xFF8B5CF6); // Electric Purple (Primary Accent)
  static const Color cyberCyan = Color(0xFF06B6D4); // Neon Cyan (Secondary Accent)
  static const Color successColor = Color(0xFF22C55E);
  static const Color warningColor = Color(0xFFF97316);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color primaryText = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF94A3B8); // Slate Grey

  // Gradients (Named to preserve backward compatibility while skinning)
  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)], // Electric Purple
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF06B6D4), Color(0xFF22D3EE)], // Neon Cyan
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldCyanGradient = LinearGradient(
    colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)], // Purple to Cyan Cyber Gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF181824), Color(0xFF12121A)],
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
        secondary: cyberCyan,
        surface: cardColor,
        error: errorColor,
      ),
      textTheme: GoogleFonts.interTextTheme(
        ThemeData.dark().textTheme.copyWith(
          bodyLarge: const TextStyle(color: primaryText),
          bodyMedium: const TextStyle(color: textSecondary),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          color: cyberCyan,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        iconTheme: const IconThemeData(color: cyberCyan),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryColor,
        selectedItemColor: cyberCyan,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: primaryText,
          backgroundColor: accentColor,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          textStyle: GoogleFonts.poppins(
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
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: cyberCyan, width: 1.5),
        ),
      ),
    );
  }
}
