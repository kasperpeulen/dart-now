library dartnow.common;

import 'dart:html';
import 'package:intl/intl.dart';

/**
 * A [NodeValidator] which allows everything.
 */
class TrustedNodeValidator implements NodeValidator {
  bool allowsElement(Element element) => true;
  bool allowsAttribute(Element element, String attributeName, String value) {
    return true;
  }
}

String formatDate(DateTime date, {bool short: true, bool includeSeconds: false}) {
  Duration difference = new DateTime.now().difference(date);
  int days = difference.inDays;
  int hours = difference.inHours;
  int minutes = difference.inMinutes;
  int seconds = difference.inSeconds;

  if (days <= 7 && hours > 24) {
    return '$days day ago';
  }
  if (hours <= 24 && minutes > 60) {
    return '$hours hour${hours >1 ? 's' : ''} ago';
  }
  if (minutes <= 60 && seconds > 60) {
    return '$minutes min${minutes >1 ? 's' : ''} ago';
  }
  if (seconds <= 60) {
    return '$seconds sec${seconds > 1 ? 's' : ''} ago';
  }
  return new DateFormat("MMM d ''yy 'at' HH:mm").format(date);
}