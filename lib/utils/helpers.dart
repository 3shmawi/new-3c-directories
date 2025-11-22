import 'package:timeago/timeago.dart' as timeago;

String formatTimeAgo(DateTime dateTime) {
  return timeago.format(dateTime);
}

String getChatId(String userId1, String userId2) {
  final sorted = [userId1, userId2]..sort();
  return '${sorted[0]}_${sorted[1]}';
}

