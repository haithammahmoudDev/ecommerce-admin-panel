import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../constants/enums.dart';

class THelperFunctions {
  static DateTime getStartOfWeek(DateTime date) {
    // الأسبوع في مصر بيبدأ بيوم السبت
    // Dart weekday: Mon=1, Tue=2, Wed=3, Thu=4, Fri=5, Sat=6, Sun=7
    final int daysUntilSaturday = (date.weekday - 6 + 7) % 7;
    final DateTime startOfWeek = date.subtract(Duration(days: daysUntilSaturday));
    return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day, 0, 0, 0, 0);
  }

  static Color getOrderStatusColor(OrderStatus value) {
    if (OrderStatus.pending == value) {
      return Colors.blue;
    } else if (OrderStatus.processing == value) {
      return Colors.orange;
    } else if (OrderStatus.shipped == value) {
      return Colors.purple;
    } else if (OrderStatus.delivered == value) {
      return Colors.green;
    } else if (OrderStatus.cancelled == value) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  static Color? getColor(String value) {
    /// Define your product specific colors here and it will match the attribute colors and show specific 🟠🟡🟢🔵🟣🟤

    if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Green') {
      return Colors.green;
    } else if (value == 'Red') {
      return Colors.red;
    } else if (value == 'Blue') {
      return Colors.blue;
    } else if (value == 'Pink') {
      return Colors.pink;
    } else if (value == 'Grey') {
      return Colors.grey;
    } else if (value == 'Purple') {
      return Colors.purple;
    } else if (value == 'Black') {
      return Colors.black;
    } else if (value == 'White') {
      return Colors.white;
    } else if (value == 'Yellow') {
      return Colors.yellow;
    } else if (value == 'Orange') {
      return Colors.deepOrange;
    } else if (value == 'Brown') {
      return Colors.brown;
    } else if (value == 'Teal') {
      return Colors.teal;
    } else if (value == 'Indigo') {
      return Colors.indigo;
    } else {
      return null;
    }
  }

  /// Gets safe area height based on notch presence
  static double  getTopSafeArea(BuildContext context) {
    return MediaQuery.of(context).viewPadding.top;
  }

  /// Gets bottom safe area (for devices with bottom gestures)
  static double getBottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).viewPadding.bottom;
  }

  static void showSnackBar(String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  static void showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme
        .of(context)
        .brightness == Brightness.dark;
  }

  static bool isPortrait(BuildContext context) {
    return MediaQuery
        .of(context)
        .orientation == Orientation.portrait;
  }

  static Size screenSize() {
    return MediaQuery
        .of(Get.context!)
        .size;
  }

  static double screenHeight() {
    return MediaQuery
        .of(Get.context!)
        .size
        .height;
  }

  static double screenWidth() {
    return MediaQuery
        .of(Get.context!)
        .size
        .width;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<T> removeDuplicates<T>(List<T> list) {
    return list.toSet().toList();
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    final wrappedList = <Widget>[];
    for (var i = 0; i < widgets.length; i += rowSize) {
      final rowChildren = widgets.sublist(
          i, i + rowSize > widgets.length ? widgets.length : i + rowSize);
      wrappedList.add(Row(children: rowChildren));
    }
    return wrappedList;
  }


  static String maskPhoneNumber(String number) {
    if (number.length > 6) {
      final visibleStart = number.substring(0, 2);
      final visibleEnd = number.substring(number.length - 3);
      final maskedPart = '*' * (number.length - visibleStart.length - visibleEnd.length);
      return '$visibleStart $maskedPart $visibleEnd';
    }
    return number;
  }


  static String generateReferralCode(String firstName) {
    final random = Random();
    final randomNumber = random.nextInt(1000);
    return firstName.toUpperCase() + randomNumber.toString();
  }


  /// Converts a dynamic [value] to a [DateTime] object.
  ///
  /// This method supports:
  /// - [T] Use this to pass firestore Timestamp
  /// - Firestore Timestamps (calls `toDate()`).
  /// - [DateTime] objects (returns as-is).
  /// - [String] values (attempts to parse using [DateTime.tryParse]).
  /// - [int] or [double] values (interpreted as Unix timestamp in milliseconds).
  ///
  /// If conversion fails, the method returns `null`.
  static DateTime? convertToDateTime<T>(dynamic value) {
    if (value == null) return null;

    // If already a DateTime, return it.
    if (value is DateTime) return value;

    // Handle Firestore Timestamp. Adjust if you're using a specific Timestamp type.
    if (value.runtimeType.toString() == 'Timestamp' || (value is T)) {
      try {
        return value.toDate();
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  // Helper method to format distance
  static String formatDistance(int distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '$distanceInMeters m';
    } else {
      double km = distanceInMeters / 1000;
      return '${km.toStringAsFixed(1)} km';
    }
  }

  static int calculateAge(String formattedDate) {
    // Parse the formatted date string back into a DateTime object
    final dateOfBirth = DateFormat('dd-MMM-yyyy').parse(formattedDate);
    final now = DateTime.now();
    int age = now.year - dateOfBirth.year;

    if (now.month < dateOfBirth.month ||
        (now.month == dateOfBirth.month && now.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  static String getOptimizedUrl(String originalUrl, {int width = 400}) {
    if (originalUrl.isEmpty) return originalUrl;
    return '$originalUrl?width=$width&quality=75&format=webp';
  }

}
