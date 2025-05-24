import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String daysBetween(dynamic date) {
  if (date is String) {
    date = DateTime.parse(date);
  } else if (date is Timestamp) {
    date = date.toDate();
  }
  if (DateTime.now().difference(date).inDays <= 5) {
    if ((DateTime.now().difference(date).inHours / 24).round() == 0) {
      if (DateTime.now().difference(date).inHours == 0) {
        if (DateTime.now().difference(date).inMinutes == 0) {
          return 'now';
        } else {
          return '${DateTime.now().difference(date).inMinutes.toString()}m';
        }
      } else {
        return '${DateTime.now().difference(date).inHours.toString()}h';
      }
    } else {
      return (' ${(DateTime.now().difference(date).inHours / 24).round().toString()}d');
    }
  } else {
    return date.toString().substring(0, 10);
  }
}

String formatDate(String date) {
  return DateFormat('dd MMMM yyyy').format(
    DateTime.parse(date),
  );
}
