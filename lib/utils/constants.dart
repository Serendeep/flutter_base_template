// Add your constants here

import 'dart:async';
import 'dart:ui';

/// Utility constants for the application
class AppConstants {
  // App-wide sizing constants
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 12.0;
  static const double defaultElevation = 4.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 250);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 500);
  static const Duration longAnimationDuration = Duration(milliseconds: 1000);
}

/// Enum for log levels
enum LogLevel { info, warning, error }

/// Extension methods for String manipulation
extension StringCasingExtension on String {
  /// Capitalize first letter of the string
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  /// Convert to title case (first letter of each word capitalized)
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');

  /// Truncate string with ellipsis
  String truncate(int maxLength, {String ellipsis = '...'}) {
    return length <= maxLength ? this : '${substring(0, maxLength)}$ellipsis';
  }
}

/// Extension methods for DateTime
extension DateTimeExtension on DateTime {
  /// Format date in a readable format
  String get formattedDate {
    return '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
  }

  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return now.year == year && now.month == month && now.day == day;
  }
}

/// Utility extension for asynchronous operations
extension AsyncExtension on Future {
  /// Add timeout to any future
  Future timeoutAfter<T>(Duration duration,
      {required FutureOr<T> Function()? onTimeout}) {
    return timeout(
      duration,
      onTimeout:
          onTimeout ?? () => throw TimeoutException('Operation timed out'),
    );
  }
}

/// Debounce utility for rate-limiting function calls
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  void dispose() {
    _timer?.cancel();
  }
}
