import 'package:intl/intl.dart';

// Utility function to format the date or time based on today's date
String formatTimestamp(DateTime timestamp) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  // Check if the timestamp is from today
  final messageDate = DateTime(timestamp.year, timestamp.month, timestamp.day);
  
  if (messageDate == today) {
    // If today, show only the time (e.g., 12:30 PM)
    return DateFormat.jm().format(timestamp);
  } else {
    // Otherwise, show the date and month (e.g., 12 Oct)
    return DateFormat('d MMM').format(timestamp);
  }
}
