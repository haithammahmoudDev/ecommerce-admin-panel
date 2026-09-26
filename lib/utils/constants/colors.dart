import 'package:flutter/material.dart';

class TColors {
  // App theme colors

  static const Color secondaryLight = Color(0xC9346DAE);
   static const Color secondaryBackground = Color(0xFFFFE4E6); // Secondary Color Background

  //Gradient Colors
  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0, 0),
      end: Alignment(0.787, -0.787),
      colors: [
        Color(0xFFff9a9e),
        Color(0xFFfad0c4),
        Color(0xFFfad0c4),
     ]);

  // Dashboard Specific Colors
  static const Color dashboardAppbarBackground = Color(0xFF4b68ff);

  // Text colors
   static const Color textDarkPrimary = Color(0xFFFFFFFF); // Theme Nightingale Gray White
  static const Color textDarkSecondary = Color(0xFFD1D5DB); // Theme Nightingale Gray 30

  static const Color disabledTextLight = Color(0xFFD1D5DB); // Theme Nightingale Gray 30
  static const Color disabledBackgroundLight = Color(0xFFF3F4F6); // Theme Nightingale Gray ?

  static const Color disabledTextDark = textSecondary; // Theme Nightingale Gray 60
  static const Color disabledBackgroundDark = Color(0xFF222A3D); // Theme Nightingale Gray 80

  // Background colors
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF02040A); // Theme Nightingale Gray 100

  // Background Container colors
    static const Color cardBackgroundColor = Color(0xFFF7F5F1); // Theme Nightingale Gray 90

  // Button colors

  // -- Social Button Colors
  static const Color googleBackgroundColor = Color(0xFFDFEFFF);
  static const Color googleForegroundColor = Color(0xFF167EE6);
  static const Color facebookBackgroundColor = Color(0xFF1877F2);

  // -- ON-BOARDING COLORS
  static const Color onBoardingPage1Color = Colors.white;
  static const Color onBoardingPage2Color = Color(0xfffddcdf);
  static const Color onBoardingPage3Color = Color(0xffffdcbd);

  // Icon colors
  static const Color iconPrimaryLight = Color(0xFF284C76); // Theme Nightingale Gray 80
  static const Color iconSecondaryLight = Color(0xFF9CA3AF); // Theme Nightingale Gray 40
  static const Color iconPrimaryDark = Color(0xFFFFFFFF); // Theme Nightingale Gray White
  static const Color iconSecondaryDark = Color(0xFF9CA3AF); // Theme Nightingale Gray 40

  // Border colors
   static const Color borderLight = Color(0xFFD1D5DB); // Gray 30
  static const Color borderDark = Color(0xFF9CA3AF); // Gray 40

  // Error and validation colors

  // Neutral Shades
   static const Color teal90 = Color(0xFF004D40);
  static const Color teal80 = Color(0xFF00695C);
  static const Color teal20 = Color(0xFF99F6E4);
  static const Color grey10 = Color(0xFFF3F4F6);
   static const Color lightGrey = Color(0xFFF9F9F9);
  static const Color white = Color(0xFFFFFFFF);
  static const Color red = Color(0xfff43F5E);
  // App theme colors
  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFF4b68ff);
  static const Color accent = Color(0xFFb0c7ff);

  // Icon colors
  static const Color iconPrimary = Color(0xFF383838);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textWhite = Colors.white;

  // Background colors
  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF5F5F5);

  // Background Container colors
  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = TColors.textWhite.withOpacity(0.1);

  // Button colors
  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  // Border colors
  static const Color borderPrimary = Color(0xFFD9D9D9);
  static const Color borderSecondary = Color(0xFFE6E6E6);

  // Error and validation colors
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF388E3C);
  static const Color warning = Color(0xFFFBC02D);
  static const Color info = Color(0xFF1976D2);

  // Neutral Shades
  static const Color black = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFFF4F4F4);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFF4F4F4);
}
